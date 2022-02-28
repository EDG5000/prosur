#
#	Specify minimum CMake version, project name, language, language standard and build type
#

cmake_minimum_required(VERSION 3.16.3)
project(prosurd LANGUAGES CXX)

set(CMAKE_BUILD_TYPE Release)
#SET(CMAKE_CXX_FLAGS_DEBUG "-O0")
#SET(CMAKE_C_FLAGS_DEBUG "-O0")
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
#set(CMAKE_EXE_LINKER_FLAGS "-Wl,-export-dynamic") # Some say it is needed for printing stacktraces

#
#	Build configuration options
#	Various test modes, defaulting to OFF
#

# Optionally enable any number of test flags

option(
	TEST_FLAG_WEBMON_ONLY
	"Only enable Webserver, allowing serving of the webmon client, allowing testing of serving of Resources without any frame collection occuring"
)

# Optionally enable one of the TEST_MODE options

option(
	TEST_MODE_MOCK_INPUT 
	"Compile with all input data replaced with simulated mock data, no waiting between frames and terminating after reaching fixed cycle count. WARNING: High resource utilisation until simulation finished. WARNING: Writes a large amount of mock data into the database."
)

option(
	TEST_MODE_CAMERA 
	"Run camera unit test"
)

option(
	TEST_MODE_HTTP
	"Run HTTP client unit text"
)

#
#	Specify include paths
#

include_directories(
	vendor
	src
)

#
#	Mirror any CMake flags with compiler defines to allow using them in the code
#

if(TEST_FLAG_WEBMON_ONLY)
	add_definitions(-DTEST_FLAG_WEBMON_ONLY)
endif()

if(TEST_MODE_MOCK_INPUT)
	add_definitions(-DTEST_MODE_MOCK_INPUT)
endif()

if(TEST_MODE_CAMERA)
	add_definitions(-DTEST_MODE_CAMERA)
endif()

if(TEST_MODE_HTTP)
	add_definitions(-DTEST_MODE_HTTP)
endif()

#
#	Specify implementation units
#	Set SOURCE_FILES depending on which TEST_MODE_*'s are active
#

set(SOURCE_FILES)

if(TEST_MODE_CAMERA)
	# Test Camera in isolated mode
	set(
    	SOURCE_FILES 
    	${SOURCE_FILES} 
    	
    	src/Util/Util.cpp
    	src/Test/MainTestCamera.cpp 
	   	src/Log.cpp
    	src/Datasource/Camera/Camera.cpp
	    src/Database/Frame.cpp
    )
    
elseif(TEST_MODE_HTTP)
	# Test HTTP client in isolated mode
	set(
    	SOURCE_FILES 
    	${SOURCE_FILES} 
    	src/Util/Util.cpp
    	src/Log.cpp
    	src/Test/MainTestHTTPClient.cpp 
    	src/HTTPClient/HTTPClient.cpp
    )
    
else()
	# Regular mode
	set( 
		SOURCE_FILES
		${SOURCE_FILES} 
	
		src/Main.cpp 
		src/Log.cpp
		src/Datasource/RepRap/RepRap.cpp 
		src/Webserver/Webserver.cpp
		src/Webserver/Resources/Frames.cpp
		src/Webserver/Resources/Jobs.cpp
		src/Webserver/Resources/Job.cpp
		src/Webserver/Resources/File.cpp
		src/Webserver/Resources/Client.cpp
		src/Database/Database.cpp
		src/Database/DBUtil.cpp
		src/Database/Frame.cpp
		src/Util/Util.cpp
		src/JobFile/JobFile.cpp
		src/JobFile/ParameterExtractor/PrusaSlicer.cpp
	)
	
	# Add real data sources or mock data sources
	if(TEST_MODE_MOCK_INPUT)
		# Mock data sources used in place of real datasources when in TEST_MODE
	    set(
	    	SOURCE_FILES 
	    	${SOURCE_FILES} 
	    	
	    	src/Test/AuxTempMock.cpp
	    	src/Test/HTTPClientMock.cpp
	    	src/Test/CameraMock.cpp
		)
	else()
		# Compile real data sources when not in TEST_MODE
		set(
	    	SOURCE_FILES 
	    	${SOURCE_FILES} 
	    	
	    	src/Datasource/AuxTemp/AuxTemp.cpp
			src/HTTPClient/HTTPClient.cpp # For the RapRap datasource, the mocking happens at HTTP layer, feeding the RepRap datasource  prerecorded HTTP responses
			src/Datasource/Camera/Camera.cpp
		)
	endif()
endif()



#
#	Executable
#

add_executable(
	prosurd 
	
	${SOURCE_FILES}
)

#
#	Load dependencies
#

include(dependencies.cmake)


# For pedantic warnings
#target_compile_options(prosurd PRIVATE -Wall -Wextra -Wpedantic -Werror)
