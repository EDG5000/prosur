# Generate makefiles manually in order to use eclipse to invoke make
# Select clang or recent GCC before invoking cmake for the first time(optional)
#export CXX=/usr/bin/g++10
#rm -rf build
#mkdir build
#cd build
#cmake ..
# not causing speedup on 9.3.0, it seems to be used correctly though
#target_precompile_headers(prosurd PRIVATE src/pch.hpp)
#appearantly, this is supposed to be used to set c++ standard instead of set():
#target_compile_features(${TARGET_NAME} PRIVATE cxx_std_17)


cmake_minimum_required(VERSION 3.16.3)

project(prosurd LANGUAGES CXX)

set(CMAKE_BUILD_TYPE Debug)
#set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -O0")
#set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O0")
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include_directories(vendor src)

add_executable(
prosurd 

src/prosurd.cpp 
src/rrfclient.cpp 
src/tmclient.cpp
src/util.cpp
src/cclient.cpp
src/dbclient.cpp
src/DB.cpp

)

include(dependencies.cmake)
