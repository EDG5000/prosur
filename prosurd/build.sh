rm -rf build || true
mkdir build
cd build
cmake ..
make -j8
cd ..