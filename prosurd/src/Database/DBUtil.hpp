#pragma once

#include <string>
#include <vector>
#include <map>
#include <iostream>
#include <arpa/inet.h>
#include <bit>

#include <postgresql/libpq-fe.h>

using namespace std;

namespace Prosur::Database::DBUtil{
	enum DBParamType{
		Int,
		Long,
		String,
		Binary
	};

	// Allows flexible passing of parameters along with query
	// vector<Param> can be used as parameter like so:
	// myfunc({1, 3423434, "string", myCharVector})
	class Param{
		int intVal = 0;
		int64_t longVal = 0;
		string stringVal;
		vector<char> binaryVal;
		DBParamType type = Int;

		public:

			// Allows assigning by any of the supported types. Sets the type and value.
			Param(){}; // Required to be present when used in std::map.
			Param(int64_t pLongVal): longVal(pLongVal), type(Long){}
			Param(string pStringVal): stringVal(pStringVal), type(String){}
			Param(int pIntVal): intVal(pIntVal), type(Int){}
			Param(vector<char> pBinaryVal): binaryVal(pBinaryVal), type(Binary){}

			// TODO is this needed at all?
			/*Param& operator=(int64_t value){

			}
			Param& operator=(string value){

			}
			Param& operator=(int value){

			}
			Param& operator=(vector<char> value){

			}*/

			// To use in conjuction with operator const char* when obtaining raw data.
			// TODO can this be removed?
			int size() const{
				switch(type){
				case Int:
					return 4;
				case Long:
					return 8;
				case String:
					return stringVal.size();
				case Binary:
					return binaryVal.size();
				}
				return 0;
			}

			// Allows obtaining as raw data pointer (see size())
			// TODO can this be removed?
			operator char*() const{
				switch(type){
				case Int:
					return (char*) &intVal;
				case Long:
					return (char*) &longVal;
				case String:
					return (char*) stringVal.data();
				case Binary:
					return (char*) binaryVal.data();
				}
			}

			// Allows interpreting as any of the supported types. Will perform runtime check on each access for safety.
			// TODO can this be made static, perhaps with templates or static_assert?
			// For large datasets, this will slow down each access
			operator int(){
				if(type != Int){
					// This will slow down accessing of parameters, but better safe than sorry
					cerr << "DBUtil: Param: Attempt to access Param as int while type is " << type << endl;
					terminate();
				}
				return intVal;
			}
			operator int64_t(){
				if(type != Long){
					// This will slow down accessing of parameters, but better safe than sorry
					cerr << "DBUtil: Param: Attempt to access Param as int64_t while type is " << type << endl;
					terminate();
				}
				return longVal;
			}
			operator string(){
				if(type != String){
					// This will slow down accessing of parameters, but better safe than sorry
					cerr << "DBUtil: Param: Attempt to access Param as string while type is " << type << endl;
					terminate();
				}
				return stringVal;
			}
			operator vector<char>(){
				if(type != Binary){
					// This will slow down accessing of parameters, but better safe than sorry
					cerr << "DBUtil: Param: Attempt to access Param as vector<char> while type is " << type << endl;
					terminate();
				}
				return binaryVal;
			}

			string toString(){
				switch(type){
				case Int:
					return to_string(intVal);
				case Long:
					return to_string(longVal);
				case String:
					return stringVal;
				default:
				case Binary:
					cerr << "DBUtil: Calling toString on Param of type Binary is not supported." << endl;
					terminate();
				}
			}
	};

	//ostream & operator << (ostream &out, const Param &param);

	// Perform query with flexible passing of parameters of common types
	// Optionally pass vector of params. Example:
	// query("insert into mytable where col_a = $1 and name = $2", {123, "John"})
	vector<map<string, Param>> query(string query, vector<Param> params = vector<Param>());

	// Will terminate application upon failed connection
	// See implementation comment about configuring Postgres
	void connect(string connectionString);

	string getError();
}
