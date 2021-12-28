/*
 * Utility for interacting with Postgres using libpq.
 * Provides syntactical sugar for passing parameters along with queries.
 */

#include <DatabaseClient/DBUtil.hpp>
#include <string>
#include <map>
#include <vector>
#include <iostream>

#include <postgresql/libpq-fe.h>

using namespace std;

namespace Prosur::DatabaseClient::DBUtil{
	constexpr int FORMAT_TEXT = 0;
	constexpr int FORMAT_BINARY = 1;


	PGconn* conn;

	Param::Param(int pIntVal){
		intVal = pIntVal;
		type = Int;
	}

	Param::Param(long pLongVal){
		longVal = pLongVal;
		type = Long;
	}

	Param::Param(string pStringVal){
		stringVal = pStringVal;
		type = String;
	}

	Param::Param(vector<char> pBinaryVal){
		binaryVal = pBinaryVal;
		type = String;
	}

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

	PGresult* query(string query, vector<Param> params){
		// TODO reverse byte order? //uint32_t binaryIntVal = htonl((uint32_t) 2);

		// Initialize arrays
		int paramFormats[params.size()];
		int paramLengths[params.size()];
		const char* paramValues[params.size()];

		// Fill arrays
		int i = 0;
		for(const Param& param: params){
			paramFormats[i] = FORMAT_BINARY;
			if(param.type == String){
				paramLengths[i] = param.stringVal.size();
				if(param.stringVal.size() != 0){
					paramValues[i] = param.stringVal.c_str();
				}
			}else if(param.type == Int){
				if(param.intVal == INT32_MAX){
					paramLengths[i] = 0; // TODO is this how to set a NULL value
				}else{
					paramValues[i] = (const char*) &param.intVal;
					paramLengths[i] = 4;
				}
			}else if(param.type == Long){
				if(param.longVal == INT64_MAX){
					paramLengths[i] = 0; // TODO is this how to set a NULL value
				}else{
					paramValues[i] = (const char*) &param.longVal;
					paramLengths[i] = 8;
				}
			}
			i++;
		}

		// Perform query
		PGresult* result = PQexecParams(
				conn,
				query.c_str(),
				params.size(),
				NULL, // paramTypes
				paramValues,
				paramLengths, // paramLengths
				paramFormats,
				FORMAT_BINARY
		);

		if(PQresultStatus(result) != PGRES_TUPLES_OK){
			cerr << "dbclient: Unable to insert frame. Error: " << getError() << endl;
			return NULL;
		}

		return result;
	}

	string getError(){
		return getError();
	}
}


