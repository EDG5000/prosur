#include "dbclient.hpp"

#include <map>
#include <string>
#include <vector>
#include <iostream>
#include <fstream>
#include <streambuf>
#include <sstream>
#include <ctime>

#include <arpa/inet.h>
#include <postgresql/libpq-fe.h>

#include "prosurd.hpp"
#include "rrfclient.hpp"

using namespace std;

namespace prosurd::dbclient{

constexpr int FORMAT_TEXT = 0;
constexpr int FORMAT_BINARY = 1;

PGconn* conn;

#include <climits>

// Set to latest inserted job at startup, incremented at runtime prior to insertion of a new job's first frame.
// Is written to each frame as long as rrfclient::is_printing.
int32_t lastJobId = -1;

bool init(){
	// As no host is supplied, libpq will connect using UNIX-domain socket for optimal performance.
	// Ensure the following is present in the table in /etc/postgres/12/main/pg_hba.conf:
	// # TYPE  DATABASE        USER            ADDRESS                 METHOD
	// local   all             all                                     trust
	// Warning: Use "trust" authentication only when there are no other untrusted Unix users on the system.
    conn = PQconnectdb("dbname=postgres user=postgres");

    // Check to see that the backend connection was successfully made
    if (PQstatus(conn) != CONNECTION_OK){
        cerr << "dbclient: Connection to database failed: " << PQerrorMessage(conn) << endl;
        PQfinish(conn);
        return false;
    }

    // Obtain the latest jobId currently in the database
    PGresult* result = PQexecParams(conn,
		"select job_id from frame "\
		"group by job_id "\
		"order by job_id desc "\
		"limit 1",
		0,
		NULL,
		NULL,
		NULL,
		NULL,
		1
	);

    if(PQresultStatus(result) != PGRES_TUPLES_OK){
        cerr << "dbclient: Unable to obtain latest job_id value. Error: " << PQerrorMessage(conn) << endl;
        return false;
    }

    // Get col number
    int colNum = PQfnumber(result, "job_id");
    if(colNum == -1){
    	cerr << "dbclient: Unable to obtain colNum for column job_id" << endl;
    	return false;
    }

    // Get row count
    int rowCount = PQntuples(result);

    // Set lastJobId
    if(rowCount == 0){
    	// No existing jobs present, start ID at 0
    	lastJobId = 0;
    }else if(rowCount != 1){
    	cerr << "dbclient: Unable to obtain latest job_id value. Row count was not 1, but " << rowCount << endl;
    	return false;
    }else if(rowCount == 1){
    	// Dereference, cast, and reverse byte order to little endian.
    	lastJobId = ntohl(*((uint32_t*)PQgetvalue(result, 0, colNum)));
    }

    return true;
}

bool update(){

	// Obtain param count
	int paramCount = values.size() + 3; // 3 columns plus all values from prosurd::values

    // Detect start of new job
    bool newJob = rrfclient::is_printing() && !rrfclient::was_printing();
    if(newJob){
    	// Create new jobId for insertion into database
    	lastJobId++;

    		// Insert job file
    		string fileInsertQuery = "insert into file (name, modified, data) values ($1, $2, $3)";
    		// Perform insert query
    		PGresult* result = PQexecParams(
    				conn,
    				fileInsertQuery.c_str(),
    				3,
    				NULL, // paramTypes
    				paramValues,
    				NULL, // paramLengths
    				paramFormats,
    				FORMAT_BINARY
    		);
    	    if(PQresultStatus(result) != PGRES_TUPLES_OK){
    	        cerr << "dbclient: Unable to insert frame. Error: " << PQerrorMessage(conn) << endl;
    	        return false;
    	    }
    }

	// Create arrays for passing to PQexecParams
	const char* paramValues[paramCount];
	int paramLengths[paramCount];

	// Set all formats
	int paramFormats[paramCount];
	for(int i = 0; i < paramCount; i++){
		paramFormats[i] = 1; // binary
	}

	// Set time, job_id, file_name as specified in insertQuery
	paramValues[0] = (char*) &time;
	if(rrfclient::is_printing()){
		paramValues[1] = (char*) &lastJobId;
	}else{
		paramValues[1] = NULL;
	}
	if(newJob){
		// Store job filename
		string fileName = rrfclient::get_filename();
		paramValues[2] = fileName;

	}

    // Generate frame insertion query.
	// Use keys in prosurd::values as column names.
    string insertQuery = "insert into frame (time, job_id, file_name, ";

    int i = 0;
    for(auto& [key, value]: values){
    	insertQuery += key;
    	if(i != values.size()-1){
    		insertQuery += ", ";
    	}
    	i++;
    }
    insertQuery += ") values (";

    for(int i = 0; i < paramCount; i++){
    	insertQuery += "$" + to_string(i+1);
    	if(i != paramCount-1){
    		insertQuery += ", ";
    	}
    }
    insertQuery += ")";

	// Perform insert query
	PGresult* result = PQexecParams(
			conn,
			insertQuery.c_str(),
			paramCount,
			NULL, // paramTypes
			paramValues,
			NULL, // paramLengths
			paramFormats,
			FORMAT_BINARY
	);
    if(PQresultStatus(result) != PGRES_TUPLES_OK){
        cerr << "dbclient: Unable to insert frame. Error: " << PQerrorMessage(conn) << endl;
        return false;
    }

    // Convert integer value "2" to network byte order
    //uint32_t binaryIntVal = htonl((uint32_t) 2);

	/*



	for(auto entry: values){

	}


    // Set up parameter arrays for PQexecParams
    const char *paramValues[] = {(char *) &binaryIntVal};
    int paramLengths[] = {sizeof(binaryIntVal)};
    int paramFormats[] = {1};

    )

    //PGresult* result = PQexecParams(conn, "SELECT * FROM test1 WHERE i = $1", 1, NULL, paramValues, paramLengths, paramFormats, FORMAT_BINARY);
		PGresult* res = PQexecParams(conn, "SELECT * FROM test1 WHERE i = $1", 1, NULL, paramValues, paramLengths, paramFormats, FORMAT_BINARY);


    if (PQresultStatus(res) != PGRES_TUPLES_OK){
        cerr << "dbclient: SELECT failed: " << PQerrorMessage(conn) << endl;
        PQclear(res);
        PQfinish(conn);
        return false;
    }

    // Get col num
    int colnum = PQfnumber(res, "mycol");

    // Get row count
    int rowcnt = PQntuples(res);

    // Retrieve data for each row
    for(int rownum = 0; rownum < rowcnt; rowcnt++){
        // Get field size
        int PQgetlength(const PGresult *res, int row_number, int column_number);

        // Get data
        const char* bptr = PQgetvalue(res, rownum, colnum);

    }


    PQclear(res);
*/
    return true;
}

}
