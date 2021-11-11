# Generate makefiles manually in order to use eclipse to invoke make
# Select clang or recent GCC before invoking cmake for the first time(optional)
#export CXX=/usr/bin/g++-10
#export CC=/usr/bin/gcc-10
#rm -rf build
#mkdir build
#cd build
#cmake ..

cmake_minimum_required(VERSION 3.16.3)

project(prosurd LANGUAGES CXX)

set(CMAKE_BUILD_TYPE Debug)
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -O0")
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O0")
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

#appearantly, this is supposed to be used:
#target_compile_features(${TARGET_NAME} PRIVATE cxx_std_17)

# Needed to use std::thread
set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)
link_libraries(Threads::Threads)

include_directories(vendor src)

add_executable(
prosurd 
src/main.cpp 
src/rrfclient.cpp 
src/tmclient.cpp
src/util.cpp
)

# not causing speedup on 9.3.0, it seems to be used correctly though
#target_precompile_headers(prosurd PRIVATE src/pch.hpp)

# Add cURL dependency
find_package(PkgConfig REQUIRED)
pkg_check_modules(libcurl REQUIRED IMPORTED_TARGET libcurl>=7.17.0)
target_link_libraries(prosurd PUBLIC PkgConfig::libcurl)