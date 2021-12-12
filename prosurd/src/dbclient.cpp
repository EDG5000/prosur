/*
	#frame (.1Hz)
	time int primary-key non-null #unixtime in seconds
	img blob non-null

	#struct prosurd_val
	int type
	blob data

	#values
	int time primary-key
	int name non-null
	prosurd_val value

	#names
	id (int primary-key autoincrement)
	varchar name NON-NULL

	#job
	#composite key on time+name
	time int primary-key non-null #unixtime in seconds
	varchar name #can be set to filename, or to any UTF-8 string of choosing
	blob data
	blob model

	#session
	int-primary-key time
*/

#include "dbclient.hpp"

#include <map>
#include <string>
#include <iostream>
#include <fstream>
#include <streambuf>
#include <sstream>

#include <arpa/inet.h>
#include <postgresql/libpq-fe.h>

using namespace std;

constexpr int FORMAT_TEXT = 0;
constexpr int FORMAT_BINARY = 1;

string readFile(string filename){
    ifstream t(filename);
    stringstream buffer;
    buffer << t.rdbuf();
    return buffer.str();
}

static void exit_nicely(PGconn *conn){
    PQfinish(conn);
    exit(1);
}

int main(){
	// As no host is supplied, it will connect using UNIX-domain socket for optimal performance
	// Ensure the following line is present in /etc/postgres/12/main/pg_hba.conf
	// # TYPE  DATABASE        USER            ADDRESS                 METHOD
	// local   all             all                                     trust
    PGconn *conn = PQconnectdb("dbname = postgres");

    // Check to see that the backend connection was successfully made
    if (PQstatus(conn) != CONNECTION_OK){
        fprintf(stderr, "Connection to database failed: %s",
        PQerrorMessage(conn));
        exit_nicely(conn);
    }

    // Convert integer value "2" to network byte order
    uint32_t binaryIntVal = htonl((uint32_t) 2);

    // Set up parameter arrays for PQexecParams
    const char *paramValues[] = {(char *) &binaryIntVal};
    int paramLengths[] = {sizeof(binaryIntVal)};
    int paramFormats[] = {1};

    PGresult* res = PQexecParams(conn, "SELECT * FROM test1 WHERE i = $1", 1, NULL, paramValues, paramLengths, paramFormats, FORMAT_BINARY);

    if (PQresultStatus(res) != PGRES_TUPLES_OK){
        fprintf(stderr, "SELECT failed: %s", PQerrorMessage(conn));
        PQclear(res);
        exit_nicely(conn);
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
}
