find_package(PkgConfig REQUIRED)

# pthreads
set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)
target_link_libraries(prosurd PUBLIC Threads::Threads)

# libcurl
pkg_check_modules(libcurl REQUIRED IMPORTED_TARGET libcurl>=7.17.0)
target_link_libraries(prosurd PUBLIC PkgConfig::libcurl)

# libpq
pkg_check_modules(libpq REQUIRED IMPORTED_TARGET libpq>=12.9)
target_link_libraries(prosurd PUBLIC PkgConfig::libpq)

# libv4l2
pkg_check_modules(libv4l2 REQUIRED IMPORTED_TARGET libv4l2>=1.18.0)
target_link_libraries(prosurd PUBLIC PkgConfig::libv4l2)

