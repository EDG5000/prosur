find_package(PkgConfig REQUIRED)

# pthreads
set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)
link_libraries(Threads::Threads)

# pthreads
#pkg_check_modules(pthread-stubs REQUIRED IMPORTED_TARGET pthread-stubs>=0.4)
#target_link_libraries(prosurd PUBLIC PkgConfig::pthread-stubs)

# libcurl
pkg_check_modules(libcurl REQUIRED IMPORTED_TARGET libcurl>=7.17.0)
target_link_libraries(prosurd PUBLIC PkgConfig::libcurl)

# libgphoto2
pkg_check_modules(libgphoto2 REQUIRED IMPORTED_TARGET libgphoto2>=2.5.0)
target_link_libraries(prosurd PUBLIC PkgConfig::libgphoto2)

# libpqxx
pkg_check_modules(libpq REQUIRED IMPORTED_TARGET libpq>=12.9)
target_link_libraries(prosurd PUBLIC PkgConfig::libpq)
