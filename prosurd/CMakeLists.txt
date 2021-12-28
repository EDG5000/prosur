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

option(TEST_MODE_MOCK_INPUT "Compile with all input data replaced with simulated mock data, no waiting between frames and terminating after reaching fixed cycle count. WARNING: High resource utilisation until simulation finished. WARNING: Writes a large amount of mock data into the database.")
#option(TEST_MODE_HTTP "Run HTTP unit test")
#option(TEST_MODE_CAMERA "Run camera unit test")
#option(TEST_MODE_RRCLIENT "Test RepRap client")
#option(TEST_MODE_AUXTEMP "Test Aux. Temperatures client")

set(CMAKE_BUILD_TYPE Debug)
#set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -O0")
#set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O0")
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include_directories(vendor src)

#
#
set( 
	SOURCE_FILES
	
	src/Main.cpp 
	src/RepRapClient/RepRapClient.cpp 
	
	src/DatabaseClient/DatabaseClient.cpp
	src/DatabaseClient/DBUtil.cpp
	src/Util/Util.cpp
)



if (TEST_MODE)
	add_definitions(-DTEST_MODE)
	# Use mock input modules
    set(
    	SOURCE_FILES 
    	${SOURCE_FILES} 
    	
    	src/Test/AuxTempClientMock.cpp
    	src/Test/CameraClientMock.cpp
    	src/Test/HTTPMock
	)
else()
	# Use real input modules
	set(
    	SOURCE_FILES 
    	${SOURCE_FILES} 
    	
		src/RepRapClient/HTTPUtil.cpp
		src/AuxTempClient/AuxTempClient.cpp
		src/CameraClient/CameraClient.cpp

	)
endif()

add_executable(
	prosurd 
	
	${SOURCE_FILES}
)



include(dependencies.cmake)
