/*
    Used when passing query parameers to DBUtil::query.

	DBValue will implicitly convert from various types, e.g.:

	vector<DBValue> test = {1.3, 3423434, "string", myCharVector};

	Allows various implicit conversions, including to char* to obtain raw data
 */

#pragma once

#include <string>
#include <vector>
#include <iostream>
#include <float.h>
#include <stdint.h>

#include "json.hpp"

using namespace std;
using namespace nlohmann;

namespace Prosur::Database{
	enum DBValueType{
		Int,
		Long,
		String,
		Binary,
		Float,
		Undefined // No type, was constructed without data.
	};

	class DBValue{
		// Union is causing issues with "implicitly deleted copy constructor". Annoying.'
		// If these fields can be easily put in a union, that would save some memory when fetching large datasets. Although for very large datasets, chunked streaming of sorts would be the most robust.
		int intVal = 0;
		int64_t longVal = 0;
		string stringVal;
		float floatVal = 0;
		vector<char> binaryVal;

		void checkType(DBValueType pType){
			if(type != pType){
				// This will slow down accessing of parameters, but better safe than sorry
				cerr << "DBUtil: Param: Attempt to access Param as "+to_string(pType)+" while type is " << to_string(type) << " Value: " << toString() << endl;
				terminate();
			}
		}

		public:
			DBValueType type = Int;

			// Allows assigning by any of the supported types. Sets the type and value.
			DBValue(){}; // Required to be present when used in std::map.
			DBValue(int64_t pLongVal): longVal(pLongVal), type(Long){}
			DBValue(string pStringVal): stringVal(pStringVal), type(String){}
			DBValue(const char* pStringVal): stringVal(pStringVal), type(String){}
			DBValue(int pIntVal): intVal(pIntVal), type(Int){}
			DBValue(vector<char> pBinaryVal): binaryVal(pBinaryVal), type(Binary){}
			DBValue(float pFloatVal): floatVal(pFloatVal), type(Float){}

			// DBUtil will insert NULLs when inserting a DBValue with isNull() == true
			bool isNull() const{
				switch(type){
				case Int:
					return intVal == INT32_MAX;
				case Float:
					return floatVal == FLT_MAX;
				case Long:
					return longVal == INT64_MAX;
				case String:
					return stringVal.size() == 0;
				case Binary:
					return binaryVal.size() == 0;
				case Undefined:
					cerr << "Error: Calling isNull() on DBValue with type Undefined causes undefined behaviour." << endl;
					terminate();
				}
				return 0;
			}

			// To use in conjuction with operator const char* when obtaining raw data.
			int size() const{
				switch(type){
				case Int:
				case Float:
					return 4;
				case Long:
					return 8;
				case String:
					return stringVal.size();
				case Binary:
					return binaryVal.size();
				case Undefined:
					cerr << "Error: Calling size() on DBValue with type Undefined causes undefined behaviour." << endl;
					terminate();
				}
				return 0;
			}

			// Allows obtaining as raw data pointer (see size())
			operator char*() const{
				switch(type){
				case Int:
					return (char*) &intVal;
				case Float:
					return (char*) &floatVal;
				case Long:
					return (char*) &longVal;
				case String:
					return (char*) stringVal.data();
				case Undefined:
					cerr << "Error: Calling operator char*() on DBValue with type Undefined causes undefined behaviour." << endl;
					terminate();
				default:
				case Binary:
					return (char*) binaryVal.data();
				}

			}

			// Allows interpreting as any of the supported types. Will perform runtime check on each access for safety.
			// TODO can this be made static, perhaps with templates or static_assert?
			// For large datasets, this will slow down each access
			operator int(){
				checkType(type);
				return intVal;
			}
			operator int64_t(){
				checkType(type);
				return longVal;
			}
			operator string(){
				checkType(type);
				return stringVal;
			}
			operator vector<char>(){
				checkType(type);
				return binaryVal;
			}
			operator float(){
				checkType(type);
				return floatVal;
			}
			operator json(){
				switch(type){
				case Int:
					return intVal;
				case Long:
					return longVal;
				case String:
					return stringVal;
				case Float:
					return floatVal;
				case Undefined:
					cerr << "Error: Calling operator json() on DBValue with type Undefined causes undefined behaviour." << endl;
					terminate();
				default:
				case Binary:
					return "<binary data of length: " + to_string(size()) + ">";
					terminate();
				}
			}

			// Used for serializing when printing to log
			string toString(){
				switch(type){
				case Int:
					return intVal == INT32_MAX ? "NULL" : to_string(intVal);
				case Long:
					return longVal == INT64_MAX ? "NULL" : to_string(longVal);
				case String:
					return stringVal;
				case Float:
					return floatVal == FLT_MAX ? "NULL" : to_string(floatVal);
				default:
				case Binary:
					return "<binary data of length: " + to_string(size()) + ">";
				case Undefined:
					cerr << "Error: Calling operator toString() on DBValue with type Undefined causes undefined behaviour." << endl;
					terminate();
				}
			}
	};
}
