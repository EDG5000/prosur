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

#include <postgresql/libpq-fe.h>
#include <postgresql/12/server/catalog/pg_type_d.h> // Nasty

#include "Util/Util.hpp"
#include <Database/DBValue.hpp>

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
		// local   all             all                                     trust
		PGconn* conn = PQconnectdb("dbname=postgres user=postgres");

		// Check to see that the backend connection was successfully made
		if (PQstatus(conn) != CONNECTION_OK){
			cerr << "dbclient: Connection to database failed: " << string(PQerrorMessage(conn)) << endl;
			PQfinish(conn);
			terminate();
		}

		return conn;
	}

	vector<map<string, DBValue>> query(string query, vector<DBValue> params){
		// Check if a connection is present for the current thread, if not, set it up
		PGconn* conn;
		if(!connections.contains(this_thread::get_id())){
			conn = connect();
			connections[this_thread::get_id()] = conn;
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

		if(params.size() == 0){
			// Perform query
			result = PQexec(
				conn,
				query.c_str()
			);
		}else{
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
			cerr << "DBUtil: Query failed. Error: " << string(PQerrorMessage(conn)) << " Query was: " << query << " Parameters: ";
			for(auto& param: params){
				cerr << param.toString() << " ";
			}
			cerr << endl;
			terminate();
		}

		// Collect values, store as Param in a vector<map<string, Param>>
		vector<map<string, DBValue>> resultData;

		int rows = PQntuples(result);
		if(rows == 0){
			return resultData;
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

		// Fill values
		for(int row = 0; row < rows; row++){
			map<string, DBValue> rowData;
			for(int column = 0; column < columnNames.size(); column++){
				if(PQgetisnull(result, row, column)){
					continue;
				}
				string columnName = columnNames[column];
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
				}
			}
			resultData.push_back(rowData);
		}
		return resultData;
	}
}


