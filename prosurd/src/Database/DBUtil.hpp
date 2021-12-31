#pragma once

#include <string>
#include <vector>
#include <map>
#include <iostream>
#include <arpa/inet.h>
#include <bit>

#include <postgresql/libpq-fe.h>

#include <Database/DBParam.hpp>

using namespace std;

namespace Prosur::Database::DBUtil{
	// Perform query with flexible passing of parameters of common types
	// Optionally pass vector of params. Example:
	// query("insert into mytable where col_a = $1 and name = $2", {123, "John"})
	vector<map<string, DBParam>> query(string query, vector<DBParam> params = vector<DBParam>());

	// Will terminate application upon failed connection
	// See implementation comment about configuring Postgres
	void connect(string connectionString);

	string getError();
}
