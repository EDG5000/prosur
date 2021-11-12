#include "dbclient.hpp"

#include <string>

using namespace std;

#include "pqxx/connection.hxx"

namespace dbclient{

//const string DB_STRING = "dbname=prosurd user=postgres password=pass123 hostaddr=127.0.0.1 port=5432";
const string DB_STRING = "dbname=prosurd user=postgres password=pass123 hostaddr=127.0.0.1 port=5432";
pqxx::connection conn(DB_STRING)

void init(){
}

/*
 * from: https://www.tutorialspoint.com/postgresql/postgresql_c_cpp.htm
 * pqxx::connection C( const std::string & dbstring )

This is a typedef which will be used to connect to the database. Here, dbstring provides required parameters to connect
 to the datbase, for example dbname = testdb user = postgres password=pass123 hostaddr=127.0.0.1 port=5432.
 */

}
