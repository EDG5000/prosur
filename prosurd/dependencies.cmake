find_package(PkgConfig REQUIRED)

#
#	Requires installation from package manager
#

# libpq-dev (for database)
pkg_check_modules(libpq REQUIRED IMPORTED_TARGET libpq>=12)
target_link_libraries(prosurd PUBLIC PkgConfig::libpq)

# libv4l2-dev (for camera)
pkg_check_modules(libv4l2 REQUIRED IMPORTED_TARGET libv4l2>=1.18)
target_link_libraries(prosurd PUBLIC PkgConfig::libv4l2)

#
#	Present on each Linux distribution by default
#

# pthreads (for C++ threads)
set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)
target_link_libraries(prosurd PUBLIC Threads::Threads)

# dl (for printing backtraces)
target_link_libraries(prosurd PUBLIC dl)