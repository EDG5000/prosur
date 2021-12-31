/*
 * Utility for interacting with Postgres using libpq.
 * Provides syntactical sugar for passing parameters along with queries.
 */

#include <Database/DBUtil.hpp>
#include <string>
#include <map>
#include <vector>
#include <iostream>

#include <postgresql/libpq-fe.h>
#include <postgresql/12/server/catalog/pg_type_d.h> // Nasty

#include "Util/Util.hpp"

using namespace std;

namespace Prosur::Database::DBUtil{
	constexpr int FORMAT_TEXT = 0;
	constexpr int FORMAT_BINARY = 1;

	PGconn* conn;

	/*
	// Could be used for printing param values to log
	ostream & operator << (ostream &out, const Param &param){
		if(param.type == Int){
			out << param.intVal;
		}else if(param.type == Long){
			out << param.longVal;
		}else if(param.type == String){
			out << param.stringVal;
		}
	    return out;
	}
	*/

	void connect(string connectionString){
		conn = PQconnectdb(connectionString.c_str());

		// Check to see that the backend connection was successfully made
		if (PQstatus(conn) != CONNECTION_OK){
			cerr << "dbclient: Connection to database failed: " << getError() << endl;
			PQfinish(conn);
			terminate();
		}
	}

	vector<map<string, Param>> query(string query, vector<Param> params){
		// Initialize arrays
		int paramFormats[params.size()];
		int paramLengths[params.size()];
		char* paramValues[params.size()];

		// Fill arrays
		int i = 0;
		for(const Param& param: params){
			paramFormats[i] = FORMAT_BINARY;
			paramLengths[i] = param.size();
			paramValues[i] = param; // TODO does byte order have to be reversed?
			i++;
		}

		// Swap byte order
		for(int i = 0; i < params.size(); i++){
			Util::swapbytes(paramValues[i], paramLengths[i]);
		}

		// Perform query
		PGresult* result = PQexecParams(
				conn,
				query.c_str(),
				params.size(),
				NULL, // paramTypes
				paramValues,
				paramLengths,
				paramFormats,
				FORMAT_BINARY
		);

		// Check for query error
		if(PQresultStatus(result) != PGRES_TUPLES_OK){
			cerr << "DBUtil: Query failed. Error: " << getError() << " Query was: " << query << endl;
			terminate();
		}

		// Collect values, store as Param in a vector<map<string, Param>>
		vector<map<string, Param>> resultData;

		int rows = PQntuples(result);
		if(rows == 0){
			return resultData;
		}

		// Collect field names
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
			map<string, Param> rowData;
			int column = 0;
			for(const string& columnName: columnNames){
				if(PQgetisnull(result, row, column)){
					continue;
				}
				Oid type = fieldTypes[columnName];
				char* data = PQgetvalue(result, row, column);
				size_t size = PQgetlength(result, row, column);
				if(type != TEXTOID){
					// For some reason, TEXT is not swapped, but INT4 and INT8 come in network byte order and need to be swapped to little endian.
					// TODO how about BYTEA?! Currently, it is swapped.
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
				column++;
			}
			resultData.push_back(rowData);
		}

		//PQclear(result)
		return resultData;
	}

	string getError(){
		return PQerrorMessage(conn);
	}
}


