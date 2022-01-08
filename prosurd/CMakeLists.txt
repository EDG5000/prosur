#cd prosur/prosurd
#rm -rf build
#mkdir build
#cd build
#export CXX=/usr/bin/g++10
#cmake ..

cmake_minimum_required(VERSION 3.16.3)

project(prosurd LANGUAGES CXX)

option(TEST_MODE_MOCK_INPUT "Compile with all input data replaced with simulated mock data, no waiting between frames and terminating after reaching fixed cycle count. WARNING: High resource utilisation until simulation finished. WARNING: Writes a large amount of mock data into the database.")
#option(TEST_MODE_HTTP "Run HTTP unit test")
#option(TEST_MODE_CAMERA "Run camera unit test")
#option(TEST_MODE_RRCLIENT "Test RepRap client")
#option(TEST_MODE_AUXTEMP "Test Aux. Temperatures client")

set(CMAKE_BUILD_TYPE Debug)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include_directories(vendor src)

# List compilation units
set( 
	SOURCE_FILES
	
	src/Main.cpp 
	
	src/Datasource/RepRap/RepRap.cpp 
	
	src/Webserver/Webserver.cpp
	src/Webserver/Resources/Frames.cpp
	src/Webserver/Resources/Jobs.cpp
	src/Webserver/Resources/File.cpp
	src/Webserver/Resources/Client.cpp
	src/Database/Database.cpp
	src/Database/DBUtil.cpp
	src/Database/Frame.cpp
	src/Util/Util.cpp
	src/JobFile/JobFile.cpp
	src/JobFile/ParameterExtractor/PrusaSlicer.cpp
)

if (TEST_MODE)
	add_definitions(-DTEST_MODE)
	# Mock data sources used in place of real datasources when in TEST_MODE
    set(
    	SOURCE_FILES 
    	${SOURCE_FILES} 
    	
    	src/Test/AuxTempMock.cpp
    	src/Test/HTTPUtilMock.cpp
    	src/Test/CameraMock.cpp
    	
	)
else()
	# Compile real data sources when not in TEST_MODE
	set(
    	SOURCE_FILES 
    	${SOURCE_FILES} 
    	
    	src/Datasource/AuxTemp/AuxTemp.cpp
		src/Datasource/RepRap/HTTPUtil.cpp
		src/Datasource/Camera/Camera.cpp
	)
endif()

add_executable(
	prosurd 
	
	${SOURCE_FILES}
)



include(dependencies.cmake)
