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

using namespace std;

namespace Prosur::Database::DBUtil{
	constexpr int FORMAT_TEXT = 0;
	constexpr int FORMAT_BINARY = 1;


	PGconn* conn;

	Param::Param(){
		// Only implemented to conform to std::map requirements.
		cerr << "Param default constructor not supported" << endl;
		terminate();
	}

	//Param::Param(int pIntVal){
		//intVal = pIntVal;

	//}



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
		// TODO reverse byte order? //uint32_t binaryIntVal = htonl((uint32_t) 2);

		// Initialize arrays
		int paramFormats[params.size()];
		int paramLengths[params.size()];
		const char* paramValues[params.size()];

		// Fill arrays
		int i = 0;
		for(const Param& param: params){
			paramFormats[i] = FORMAT_BINARY;
			paramLengths[i] = param.size();
			paramValues[i] = param; // TODO does byte order have to be reversed?
			i++;
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

		if(PQresultStatus(result) != PGRES_TUPLES_OK){
			cerr << "DBUtil: Query failed. Error: " << getError() << endl;
			terminate();
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

		// Collect values, store as Param in a vector<map<string, Param>>
		vector<map<string, Param>> resultData;
		for(int row = 0; row < PQntuples(result); row++){
			map<string, Param> rowData;
			int column = 0;
			for(const string& columnName: columnNames){
				Oid type = fieldTypes[columnName];
				char* data = PQgetvalue(result, row, column);
				switch(type){
				case INT4OID:
					//rowData[columnName] = *((int*) data); // implicit Param constructor
					break;
				case INT8OID:
					//rowData[columnName] = *((int64_t*) data); // implicit Param constructor
					break;
				case BYTEAOID:
					//rowData[columnName] = (data, PQfsize(result, column)); // implicit Vector constructor, implicit Param constructor
					break;
				case VARCHAROID:
					//rowData[columnName] = string(data); // implicit Param constructor
					break;
				}
				column++;
			}
		}

		//PQclear(result)
		return resultData;
	}

	string getError(){
		return PQerrorMessage(conn);
	}
}


