/*
 * Utility for interacting with Postgres using libpq.
 * Provides syntactical sugar for passing parameters along with queries.
 */

#include <Database/DBUtil.hpp>
#include <string>
#include <map>
#include <vector>
#include <iostream>
#include <thread>

#include <libpq-fe.h>

#include "Util/Util.hpp"
#include <Database/DBValue.hpp>
#include "OID.hpp"
#include "Main.hpp"

using namespace std;

namespace Prosur::Database::DBUtil{
	constexpr int FORMAT_TEXT = 0;
	constexpr int FORMAT_BINARY = 1;

	map<thread::id, PGconn*> connections; // One connection per thread is set up lazily

	static PGconn* connect(){
		// As no host is supplied, libpq will connect using UNIX-domain socket for optimal performance.
		// Warning: Use "trust" authentication only when there are no other untrusted Unix users on the system.
		// Ensure the following is present in the table in /etc/postgres/12/main/pg_hba.conf:
		// # TYPE  DATABASE        USER            ADDRESS                 METHOD
		// local   all             postgres                                trust
		PGconn* conn = PQconnectdb("dbname=postgres user=postgres");

		// Check to see that the backend connection was successfully made
		if (PQstatus(conn) != CONNECTION_OK){
			log("dbclient: Connection to database failed: " + string(PQerrorMessage(conn)));
			PQfinish(conn);
			terminate();
		}

		PGresult* result = PQexec(conn, "set search_path to prosur");
		ExecStatusType status = PQresultStatus(result);
		// Check for query error
		if(status != PGRES_TUPLES_OK && status != PGRES_COMMAND_OK){
			log("DBUtil: Setting up connection failed. Error: " + string(PQerrorMessage(conn)));
			terminate();
		}

		return conn;
	}

	vector<map<string, DBValue>> query(string query, vector<DBValue> params){
		//log(query);
		//cerr + query);
		/*log("DBUtil::query " + query + " is invoked with params: ");
		for(auto& param: params){
			cerr + param.toString() + " ";

		}
		cerr);*/

		// Check if a connection is present for the current thread, if not, set it up
		PGconn* conn;
		if(!connections.contains(this_thread::get_id())){
			conn = connect();

			// Set default schema to prosur
			// TODO is below call causing issues?
			//DBUtil::query("set search_path to prosur");

			connections[this_thread::get_id()] = conn;
			// TODO add error handling to this call
			//
		}else{
			conn = connections[this_thread::get_id()];
		}

		// Initialize arrays
		int paramFormats[params.size()];
		int paramLengths[params.size()];
		char* paramValues[params.size()];

		// Fill arrays
		int i = 0;
		for(const DBValue& param: params){
			paramFormats[i] = FORMAT_BINARY;
			paramLengths[i] = param.size();
			if(param.isNull()){
				paramValues[i] = nullptr;
			}else{
				paramValues[i] = param;
				// Convert to network byte order
				// Integer and floats are swapped. Binary array and string is not swapped.
				if(param.type != String && param.type != Binary){
					Util::swapbytes(paramValues[i], paramLengths[i]);
				}
			}
			i++;
		}

		PGresult* result;

		// Run query, either as multi-command, in which case no parameters will be passed and returned rows are discarded,
		// or as regular single-command query, where all parameters are passed and result rows are interpreted.
		bool isMultiCommandQuery = query.find(";") != string::npos;
		if(isMultiCommandQuery){
			// Perform multi-command query. Note: Cannot be used to retrieve data as the FORMAT_BINARY flag cannot be passed to
			// PQexec. Even if data is returned, below code will attempt to interpret it as binary, which will produce garbage
			// Therefore, when running a multi-command query, an empty vector is always returned and result rows are not interpreted
			result = PQexec(
				conn,
				query.c_str()
			);
		}else{
			/*log("Now running query " + query + " with params: ");
			for(auto& param: params){
				cerr + param.toString() + " ";

			}
			cerr);*/

			// Perform query
			result = PQexecParams(
				conn,
				query.c_str(),
				params.size(),
				NULL, // paramTypes
				paramValues,
				paramLengths,
				paramFormats,
				FORMAT_BINARY
			);
		}

		ExecStatusType status = PQresultStatus(result);
		// Check for query error
		if(status != PGRES_TUPLES_OK && status != PGRES_COMMAND_OK){
			string error = "DBUtil: Query failed. Error: " + string(PQerrorMessage(conn)) + " Query was: " + query + " Parameters: ";
			for(auto& param: params){
				error += param.toString() + " ";
			}
			log(error);
			terminate();
		}

		// Result rows are not fetched for a multi-command query. See above comment near "if(isMultiCommandQuery)"
		if(isMultiCommandQuery){
			return {};
		}

		// Get row count. Return empty vector if no rows
		int rows = PQntuples(result);
		if(rows == 0){
			PQclear(result);
			return {};
		}

		// Collect field names and types
		int columnCount = PQnfields(result);
		vector<string> columnNames;
		map<string, Oid> fieldTypes;
		for(int column = 0; column < columnCount; column++){
			string fieldName = PQfname(result, column);
			columnNames.push_back(fieldName);
			fieldTypes[fieldName] = PQftype(result, column);
		}

		// Fill values, store as Param in a vector<map<string, Param>>
		vector<map<string, DBValue>> resultData;
		for(int row = 0; row < rows; row++){
			map<string, DBValue> rowData;
			for(int column = 0; column < columnNames.size(); column++){
				string columnName = columnNames[column];
				if(PQgetisnull(result, row, column)){
					rowData[columnName] = DBValue();
					continue;
				}

				Oid type = fieldTypes[columnName];
				char* data = PQgetvalue(result, row, column);
				size_t size = PQgetlength(result, row, column);
				// Integer and floats are swapped. Binary array and string are not swapped.
				if(type != TEXTOID && type != BYTEAOID){
					Util::swapbytes(data, size);
				}

				switch(type){
				case INT4OID:
					rowData[columnName] = *((int*) data); // implicit Param constructor
					break;
				case INT8OID:
					//log("directly from the horses' mouth: " + *((int64_t*) data));
					rowData[columnName] = *((int64_t*) data); // implicit Param constructor
					break;
				case BYTEAOID: {
						vector<char> dataVector(data, data + size);
						rowData[columnName] = dataVector;
					}
					break;
				case TEXTOID:
					rowData[columnName] = string(data); // implicit Param constructor
					break;
				case FLOAT4OID:
					rowData[columnName] = *((float*) data);
					break;
				}
			}
			resultData.push_back(rowData);
		}

		PQclear(result);

		return resultData;
	}
}


