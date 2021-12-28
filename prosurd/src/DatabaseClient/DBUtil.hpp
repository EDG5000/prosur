#pragma once

#include <string>
#include <vector>

#include <postgresql/libpq-fe.h>

using namespace std;

namespace Prosur::DatabaseClient::DBUtil{
	enum DBParamType{
		Int,
		Long,
		String
	};

	// Allows flexible passing of parameters along with query
	// vector<Param> can be used as parameter like so:
	// myfunc({1, 3423434, "string", myCharVector})
	class Param{
		public:
			int intVal = 0;
			int64_t longVal = 0;
			string stringVal;
			vector<char> binaryVal;
			DBParamType type = Int;
			Param (int64_t);
			Param (string);
			Param (int);
			Param(vector<char>);
			Param& operator=(int64_t value);
			Param& operator=(string value);
			Param& operator=(int value);
			Param& operator=(vector<char> value);
	};

	//ostream & operator << (ostream &out, const Param &param);

	// Perform query with flexible passing of parameters of common types
	// Optionally pass vector of params. Example:
	// query("insert into mytable where col_a = $1 and name = $2", {123, "John"})
	PGresult* query(string query, vector<Param> params = vector<Param>());

	// Will terminate application upon failed connection
	// See implementation comment about configuring Postgres
	void connect(string connectionString);

	string getError();
}
