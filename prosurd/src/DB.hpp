#pragma once

#include <string>
#include <vector>

#include <postgresql/libpq-fe.h>

using namespace std;

namespace prosurd::DB{
	enum DBParamType{
		Int,
		Long,
		String
	};

	class Param{
		public:
			int intVal;
			int64_t longVal;
			string stringVal;
			vector<char> binaryVal;
			DBParamType type;
			Param (int64_t);
			Param (string);
			Param (int);
			Param(vector<char>);

			Param& operator=(int64_t value);
			Param& operator=(string value);
			Param& operator=(int value);
			Param& operator=(vector<char> value);

	};

	ostream & operator << (ostream &out, const Param &param);

	PGresult* query(string query, vector<Param> params = vector<Param>());
}
