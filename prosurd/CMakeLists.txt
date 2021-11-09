cmake_minimum_required(VERSION 3.5)

project(prosurd LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Needed to use std::thread
set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)
link_libraries(Threads::Threads)

include_directories(vendor src)

add_executable(prosurd src/main.cpp src/rrfclient.cpp src/util.cpp)