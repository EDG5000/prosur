# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.16

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/joel/repos/infinus/prosur/prosurd

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/joel/repos/infinus/prosur/prosurd/build_TEST_FLAG_WEBMON_ONLY

# Include any dependencies generated for this target.
include CMakeFiles/prosurd.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/prosurd.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/prosurd.dir/flags.make

CMakeFiles/prosurd.dir/src/Main.cpp.o: CMakeFiles/prosurd.dir/flags.make
CMakeFiles/prosurd.dir/src/Main.cpp.o: ../src/Main.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/joel/repos/infinus/prosur/prosurd/build_TEST_FLAG_WEBMON_ONLY/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/prosurd.dir/src/Main.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/prosurd.dir/src/Main.cpp.o -c /home/joel/repos/infinus/prosur/prosurd/src/Main.cpp

CMakeFiles/prosurd.dir/src/Main.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/prosurd.dir/src/Main.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/joel/repos/infinus/prosur/prosurd/src/Main.cpp > CMakeFiles/prosurd.dir/src/Main.cpp.i

CMakeFiles/prosurd.dir/src/Main.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/prosurd.dir/src/Main.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/joel/repos/infinus/prosur/prosurd/src/Main.cpp -o CMakeFiles/prosurd.dir/src/Main.cpp.s

CMakeFiles/prosurd.dir/src/Log.cpp.o: CMakeFiles/prosurd.dir/flags.make
CMakeFiles/prosurd.dir/src/Log.cpp.o: ../src/Log.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/joel/repos/infinus/prosur/prosurd/build_TEST_FLAG_WEBMON_ONLY/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object CMakeFiles/prosurd.dir/src/Log.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/prosurd.dir/src/Log.cpp.o -c /home/joel/repos/infinus/prosur/prosurd/src/Log.cpp

CMakeFiles/prosurd.dir/src/Log.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/prosurd.dir/src/Log.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/joel/repos/infinus/prosur/prosurd/src/Log.cpp > CMakeFiles/prosurd.dir/src/Log.cpp.i

CMakeFiles/prosurd.dir/src/Log.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/prosurd.dir/src/Log.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/joel/repos/infinus/prosur/prosurd/src/Log.cpp -o CMakeFiles/prosurd.dir/src/Log.cpp.s

CMakeFiles/prosurd.dir/src/Datasource/RepRap/RepRap.cpp.o: CMakeFiles/prosurd.dir/flags.make
CMakeFiles/prosurd.dir/src/Datasource/RepRap/RepRap.cpp.o: ../src/Datasource/RepRap/RepRap.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/joel/repos/infinus/prosur/prosurd/build_TEST_FLAG_WEBMON_ONLY/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object CMakeFiles/prosurd.dir/src/Datasource/RepRap/RepRap.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/prosurd.dir/src/Datasource/RepRap/RepRap.cpp.o -c /home/joel/repos/infinus/prosur/prosurd/src/Datasource/RepRap/RepRap.cpp

CMakeFiles/prosurd.dir/src/Datasource/RepRap/RepRap.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/prosurd.dir/src/Datasource/RepRap/RepRap.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/joel/repos/infinus/prosur/prosurd/src/Datasource/RepRap/RepRap.cpp > CMakeFiles/prosurd.dir/src/Datasource/RepRap/RepRap.cpp.i

CMakeFiles/prosurd.dir/src/Datasource/RepRap/RepRap.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/prosurd.dir/src/Datasource/RepRap/RepRap.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/joel/repos/infinus/prosur/prosurd/src/Datasource/RepRap/RepRap.cpp -o CMakeFiles/prosurd.dir/src/Datasource/RepRap/RepRap.cpp.s

CMakeFiles/prosurd.dir/src/Webserver/Webserver.cpp.o: CMakeFiles/prosurd.dir/flags.make
CMakeFiles/prosurd.dir/src/Webserver/Webserver.cpp.o: ../src/Webserver/Webserver.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/joel/repos/infinus/prosur/prosurd/build_TEST_FLAG_WEBMON_ONLY/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building CXX object CMakeFiles/prosurd.dir/src/Webserver/Webserver.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/prosurd.dir/src/Webserver/Webserver.cpp.o -c /home/joel/repos/infinus/prosur/prosurd/src/Webserver/Webserver.cpp

CMakeFiles/prosurd.dir/src/Webserver/Webserver.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/prosurd.dir/src/Webserver/Webserver.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/joel/repos/infinus/prosur/prosurd/src/Webserver/Webserver.cpp > CMakeFiles/prosurd.dir/src/Webserver/Webserver.cpp.i

CMakeFiles/prosurd.dir/src/Webserver/Webserver.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/prosurd.dir/src/Webserver/Webserver.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/joel/repos/infinus/prosur/prosurd/src/Webserver/Webserver.cpp -o CMakeFiles/prosurd.dir/src/Webserver/Webserver.cpp.s

CMakeFiles/prosurd.dir/src/Webserver/Resources/Frames.cpp.o: CMakeFiles/prosurd.dir/flags.make
CMakeFiles/prosurd.dir/src/Webserver/Resources/Frames.cpp.o: ../src/Webserver/Resources/Frames.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/joel/repos/infinus/prosur/prosurd/build_TEST_FLAG_WEBMON_ONLY/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Building CXX object CMakeFiles/prosurd.dir/src/Webserver/Resources/Frames.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/prosurd.dir/src/Webserver/Resources/Frames.cpp.o -c /home/joel/repos/infinus/prosur/prosurd/src/Webserver/Resources/Frames.cpp

CMakeFiles/prosurd.dir/src/Webserver/Resources/Frames.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/prosurd.dir/src/Webserver/Resources/Frames.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/joel/repos/infinus/prosur/prosurd/src/Webserver/Resources/Frames.cpp > CMakeFiles/prosurd.dir/src/Webserver/Resources/Frames.cpp.i

CMakeFiles/prosurd.dir/src/Webserver/Resources/Frames.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/prosurd.dir/src/Webserver/Resources/Frames.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/joel/repos/infinus/prosur/prosurd/src/Webserver/Resources/Frames.cpp -o CMakeFiles/prosurd.dir/src/Webserver/Resources/Frames.cpp.s

CMakeFiles/prosurd.dir/src/Webserver/Resources/Jobs.cpp.o: CMakeFiles/prosurd.dir/flags.make
CMakeFiles/prosurd.dir/src/Webserver/Resources/Jobs.cpp.o: ../src/Webserver/Resources/Jobs.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/joel/repos/infinus/prosur/prosurd/build_TEST_FLAG_WEBMON_ONLY/CMakeFiles --progress-num=$(CMAKE_PROGRESS_6) "Building CXX object CMakeFiles/prosurd.dir/src/Webserver/Resources/Jobs.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/prosurd.dir/src/Webserver/Resources/Jobs.cpp.o -c /home/joel/repos/infinus/prosur/prosurd/src/Webserver/Resources/Jobs.cpp

CMakeFiles/prosurd.dir/src/Webserver/Resources/Jobs.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/prosurd.dir/src/Webserver/Resources/Jobs.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/joel/repos/infinus/prosur/prosurd/src/Webserver/Resources/Jobs.cpp > CMakeFiles/prosurd.dir/src/Webserver/Resources/Jobs.cpp.i

CMakeFiles/prosurd.dir/src/Webserver/Resources/Jobs.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/prosurd.dir/src/Webserver/Resources/Jobs.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/joel/repos/infinus/prosur/prosurd/src/Webserver/Resources/Jobs.cpp -o CMakeFiles/prosurd.dir/src/Webserver/Resources/Jobs.cpp.s

CMakeFiles/prosurd.dir/src/Webserver/Resources/Job.cpp.o: CMakeFiles/prosurd.dir/flags.make
CMakeFiles/prosurd.dir/src/Webserver/Resources/Job.cpp.o: ../src/Webserver/Resources/Job.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/joel/repos/infinus/prosur/prosurd/build_TEST_FLAG_WEBMON_ONLY/CMakeFiles --progress-num=$(CMAKE_PROGRESS_7) "Building CXX object CMakeFiles/prosurd.dir/src/Webserver/Resources/Job.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/prosurd.dir/src/Webserver/Resources/Job.cpp.o -c /home/joel/repos/infinus/prosur/prosurd/src/Webserver/Resources/Job.cpp

CMakeFiles/prosurd.dir/src/Webserver/Resources/Job.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/prosurd.dir/src/Webserver/Resources/Job.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/joel/repos/infinus/prosur/prosurd/src/Webserver/Resources/Job.cpp > CMakeFiles/prosurd.dir/src/Webserver/Resources/Job.cpp.i

CMakeFiles/prosurd.dir/src/Webserver/Resources/Job.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/prosurd.dir/src/Webserver/Resources/Job.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/joel/repos/infinus/prosur/prosurd/src/Webserver/Resources/Job.cpp -o CMakeFiles/prosurd.dir/src/Webserver/Resources/Job.cpp.s

CMakeFiles/prosurd.dir/src/Webserver/Resources/File.cpp.o: CMakeFiles/prosurd.dir/flags.make
CMakeFiles/prosurd.dir/src/Webserver/Resources/File.cpp.o: ../src/Webserver/Resources/File.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/joel/repos/infinus/prosur/prosurd/build_TEST_FLAG_WEBMON_ONLY/CMakeFiles --progress-num=$(CMAKE_PROGRESS_8) "Building CXX object CMakeFiles/prosurd.dir/src/Webserver/Resources/File.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/prosurd.dir/src/Webserver/Resources/File.cpp.o -c /home/joel/repos/infinus/prosur/prosurd/src/Webserver/Resources/File.cpp

CMakeFiles/prosurd.dir/src/Webserver/Resources/File.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/prosurd.dir/src/Webserver/Resources/File.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/joel/repos/infinus/prosur/prosurd/src/Webserver/Resources/File.cpp > CMakeFiles/prosurd.dir/src/Webserver/Resources/File.cpp.i

CMakeFiles/prosurd.dir/src/Webserver/Resources/File.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/prosurd.dir/src/Webserver/Resources/File.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/joel/repos/infinus/prosur/prosurd/src/Webserver/Resources/File.cpp -o CMakeFiles/prosurd.dir/src/Webserver/Resources/File.cpp.s

CMakeFiles/prosurd.dir/src/Webserver/Resources/Client.cpp.o: CMakeFiles/prosurd.dir/flags.make
CMakeFiles/prosurd.dir/src/Webserver/Resources/Client.cpp.o: ../src/Webserver/Resources/Client.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/joel/repos/infinus/prosur/prosurd/build_TEST_FLAG_WEBMON_ONLY/CMakeFiles --progress-num=$(CMAKE_PROGRESS_9) "Building CXX object CMakeFiles/prosurd.dir/src/Webserver/Resources/Client.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/prosurd.dir/src/Webserver/Resources/Client.cpp.o -c /home/joel/repos/infinus/prosur/prosurd/src/Webserver/Resources/Client.cpp

CMakeFiles/prosurd.dir/src/Webserver/Resources/Client.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/prosurd.dir/src/Webserver/Resources/Client.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/joel/repos/infinus/prosur/prosurd/src/Webserver/Resources/Client.cpp > CMakeFiles/prosurd.dir/src/Webserver/Resources/Client.cpp.i

CMakeFiles/prosurd.dir/src/Webserver/Resources/Client.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/prosurd.dir/src/Webserver/Resources/Client.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/joel/repos/infinus/prosur/prosurd/src/Webserver/Resources/Client.cpp -o CMakeFiles/prosurd.dir/src/Webserver/Resources/Client.cpp.s

CMakeFiles/prosurd.dir/src/Database/Database.cpp.o: CMakeFiles/prosurd.dir/flags.make
CMakeFiles/prosurd.dir/src/Database/Database.cpp.o: ../src/Database/Database.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/joel/repos/infinus/prosur/prosurd/build_TEST_FLAG_WEBMON_ONLY/CMakeFiles --progress-num=$(CMAKE_PROGRESS_10) "Building CXX object CMakeFiles/prosurd.dir/src/Database/Database.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/prosurd.dir/src/Database/Database.cpp.o -c /home/joel/repos/infinus/prosur/prosurd/src/Database/Database.cpp

CMakeFiles/prosurd.dir/src/Database/Database.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/prosurd.dir/src/Database/Database.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/joel/repos/infinus/prosur/prosurd/src/Database/Database.cpp > CMakeFiles/prosurd.dir/src/Database/Database.cpp.i

CMakeFiles/prosurd.dir/src/Database/Database.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/prosurd.dir/src/Database/Database.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/joel/repos/infinus/prosur/prosurd/src/Database/Database.cpp -o CMakeFiles/prosurd.dir/src/Database/Database.cpp.s

CMakeFiles/prosurd.dir/src/Database/DBUtil.cpp.o: CMakeFiles/prosurd.dir/flags.make
CMakeFiles/prosurd.dir/src/Database/DBUtil.cpp.o: ../src/Database/DBUtil.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/joel/repos/infinus/prosur/prosurd/build_TEST_FLAG_WEBMON_ONLY/CMakeFiles --progress-num=$(CMAKE_PROGRESS_11) "Building CXX object CMakeFiles/prosurd.dir/src/Database/DBUtil.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/prosurd.dir/src/Database/DBUtil.cpp.o -c /home/joel/repos/infinus/prosur/prosurd/src/Database/DBUtil.cpp

CMakeFiles/prosurd.dir/src/Database/DBUtil.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/prosurd.dir/src/Database/DBUtil.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/joel/repos/infinus/prosur/prosurd/src/Database/DBUtil.cpp > CMakeFiles/prosurd.dir/src/Database/DBUtil.cpp.i

CMakeFiles/prosurd.dir/src/Database/DBUtil.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/prosurd.dir/src/Database/DBUtil.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/joel/repos/infinus/prosur/prosurd/src/Database/DBUtil.cpp -o CMakeFiles/prosurd.dir/src/Database/DBUtil.cpp.s

CMakeFiles/prosurd.dir/src/Database/Frame.cpp.o: CMakeFiles/prosurd.dir/flags.make
CMakeFiles/prosurd.dir/src/Database/Frame.cpp.o: ../src/Database/Frame.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/joel/repos/infinus/prosur/prosurd/build_TEST_FLAG_WEBMON_ONLY/CMakeFiles --progress-num=$(CMAKE_PROGRESS_12) "Building CXX object CMakeFiles/prosurd.dir/src/Database/Frame.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/prosurd.dir/src/Database/Frame.cpp.o -c /home/joel/repos/infinus/prosur/prosurd/src/Database/Frame.cpp

CMakeFiles/prosurd.dir/src/Database/Frame.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/prosurd.dir/src/Database/Frame.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/joel/repos/infinus/prosur/prosurd/src/Database/Frame.cpp > CMakeFiles/prosurd.dir/src/Database/Frame.cpp.i

CMakeFiles/prosurd.dir/src/Database/Frame.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/prosurd.dir/src/Database/Frame.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/joel/repos/infinus/prosur/prosurd/src/Database/Frame.cpp -o CMakeFiles/prosurd.dir/src/Database/Frame.cpp.s

CMakeFiles/prosurd.dir/src/Util/Util.cpp.o: CMakeFiles/prosurd.dir/flags.make
CMakeFiles/prosurd.dir/src/Util/Util.cpp.o: ../src/Util/Util.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/joel/repos/infinus/prosur/prosurd/build_TEST_FLAG_WEBMON_ONLY/CMakeFiles --progress-num=$(CMAKE_PROGRESS_13) "Building CXX object CMakeFiles/prosurd.dir/src/Util/Util.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/prosurd.dir/src/Util/Util.cpp.o -c /home/joel/repos/infinus/prosur/prosurd/src/Util/Util.cpp

CMakeFiles/prosurd.dir/src/Util/Util.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/prosurd.dir/src/Util/Util.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/joel/repos/infinus/prosur/prosurd/src/Util/Util.cpp > CMakeFiles/prosurd.dir/src/Util/Util.cpp.i

CMakeFiles/prosurd.dir/src/Util/Util.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/prosurd.dir/src/Util/Util.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/joel/repos/infinus/prosur/prosurd/src/Util/Util.cpp -o CMakeFiles/prosurd.dir/src/Util/Util.cpp.s

CMakeFiles/prosurd.dir/src/JobFile/JobFile.cpp.o: CMakeFiles/prosurd.dir/flags.make
CMakeFiles/prosurd.dir/src/JobFile/JobFile.cpp.o: ../src/JobFile/JobFile.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/joel/repos/infinus/prosur/prosurd/build_TEST_FLAG_WEBMON_ONLY/CMakeFiles --progress-num=$(CMAKE_PROGRESS_14) "Building CXX object CMakeFiles/prosurd.dir/src/JobFile/JobFile.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/prosurd.dir/src/JobFile/JobFile.cpp.o -c /home/joel/repos/infinus/prosur/prosurd/src/JobFile/JobFile.cpp

CMakeFiles/prosurd.dir/src/JobFile/JobFile.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/prosurd.dir/src/JobFile/JobFile.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/joel/repos/infinus/prosur/prosurd/src/JobFile/JobFile.cpp > CMakeFiles/prosurd.dir/src/JobFile/JobFile.cpp.i

CMakeFiles/prosurd.dir/src/JobFile/JobFile.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/prosurd.dir/src/JobFile/JobFile.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/joel/repos/infinus/prosur/prosurd/src/JobFile/JobFile.cpp -o CMakeFiles/prosurd.dir/src/JobFile/JobFile.cpp.s

CMakeFiles/prosurd.dir/src/JobFile/ParameterExtractor/PrusaSlicer.cpp.o: CMakeFiles/prosurd.dir/flags.make
CMakeFiles/prosurd.dir/src/JobFile/ParameterExtractor/PrusaSlicer.cpp.o: ../src/JobFile/ParameterExtractor/PrusaSlicer.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/joel/repos/infinus/prosur/prosurd/build_TEST_FLAG_WEBMON_ONLY/CMakeFiles --progress-num=$(CMAKE_PROGRESS_15) "Building CXX object CMakeFiles/prosurd.dir/src/JobFile/ParameterExtractor/PrusaSlicer.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/prosurd.dir/src/JobFile/ParameterExtractor/PrusaSlicer.cpp.o -c /home/joel/repos/infinus/prosur/prosurd/src/JobFile/ParameterExtractor/PrusaSlicer.cpp

CMakeFiles/prosurd.dir/src/JobFile/ParameterExtractor/PrusaSlicer.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/prosurd.dir/src/JobFile/ParameterExtractor/PrusaSlicer.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/joel/repos/infinus/prosur/prosurd/src/JobFile/ParameterExtractor/PrusaSlicer.cpp > CMakeFiles/prosurd.dir/src/JobFile/ParameterExtractor/PrusaSlicer.cpp.i

CMakeFiles/prosurd.dir/src/JobFile/ParameterExtractor/PrusaSlicer.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/prosurd.dir/src/JobFile/ParameterExtractor/PrusaSlicer.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/joel/repos/infinus/prosur/prosurd/src/JobFile/ParameterExtractor/PrusaSlicer.cpp -o CMakeFiles/prosurd.dir/src/JobFile/ParameterExtractor/PrusaSlicer.cpp.s

CMakeFiles/prosurd.dir/src/Datasource/AuxTemp/AuxTemp.cpp.o: CMakeFiles/prosurd.dir/flags.make
CMakeFiles/prosurd.dir/src/Datasource/AuxTemp/AuxTemp.cpp.o: ../src/Datasource/AuxTemp/AuxTemp.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/joel/repos/infinus/prosur/prosurd/build_TEST_FLAG_WEBMON_ONLY/CMakeFiles --progress-num=$(CMAKE_PROGRESS_16) "Building CXX object CMakeFiles/prosurd.dir/src/Datasource/AuxTemp/AuxTemp.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/prosurd.dir/src/Datasource/AuxTemp/AuxTemp.cpp.o -c /home/joel/repos/infinus/prosur/prosurd/src/Datasource/AuxTemp/AuxTemp.cpp

CMakeFiles/prosurd.dir/src/Datasource/AuxTemp/AuxTemp.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/prosurd.dir/src/Datasource/AuxTemp/AuxTemp.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/joel/repos/infinus/prosur/prosurd/src/Datasource/AuxTemp/AuxTemp.cpp > CMakeFiles/prosurd.dir/src/Datasource/AuxTemp/AuxTemp.cpp.i

CMakeFiles/prosurd.dir/src/Datasource/AuxTemp/AuxTemp.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/prosurd.dir/src/Datasource/AuxTemp/AuxTemp.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/joel/repos/infinus/prosur/prosurd/src/Datasource/AuxTemp/AuxTemp.cpp -o CMakeFiles/prosurd.dir/src/Datasource/AuxTemp/AuxTemp.cpp.s

CMakeFiles/prosurd.dir/src/HTTPClient/HTTPClient.cpp.o: CMakeFiles/prosurd.dir/flags.make
CMakeFiles/prosurd.dir/src/HTTPClient/HTTPClient.cpp.o: ../src/HTTPClient/HTTPClient.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/joel/repos/infinus/prosur/prosurd/build_TEST_FLAG_WEBMON_ONLY/CMakeFiles --progress-num=$(CMAKE_PROGRESS_17) "Building CXX object CMakeFiles/prosurd.dir/src/HTTPClient/HTTPClient.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/prosurd.dir/src/HTTPClient/HTTPClient.cpp.o -c /home/joel/repos/infinus/prosur/prosurd/src/HTTPClient/HTTPClient.cpp

CMakeFiles/prosurd.dir/src/HTTPClient/HTTPClient.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/prosurd.dir/src/HTTPClient/HTTPClient.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/joel/repos/infinus/prosur/prosurd/src/HTTPClient/HTTPClient.cpp > CMakeFiles/prosurd.dir/src/HTTPClient/HTTPClient.cpp.i

CMakeFiles/prosurd.dir/src/HTTPClient/HTTPClient.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/prosurd.dir/src/HTTPClient/HTTPClient.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/joel/repos/infinus/prosur/prosurd/src/HTTPClient/HTTPClient.cpp -o CMakeFiles/prosurd.dir/src/HTTPClient/HTTPClient.cpp.s

CMakeFiles/prosurd.dir/src/Datasource/Camera/Camera.cpp.o: CMakeFiles/prosurd.dir/flags.make
CMakeFiles/prosurd.dir/src/Datasource/Camera/Camera.cpp.o: ../src/Datasource/Camera/Camera.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/joel/repos/infinus/prosur/prosurd/build_TEST_FLAG_WEBMON_ONLY/CMakeFiles --progress-num=$(CMAKE_PROGRESS_18) "Building CXX object CMakeFiles/prosurd.dir/src/Datasource/Camera/Camera.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/prosurd.dir/src/Datasource/Camera/Camera.cpp.o -c /home/joel/repos/infinus/prosur/prosurd/src/Datasource/Camera/Camera.cpp

CMakeFiles/prosurd.dir/src/Datasource/Camera/Camera.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/prosurd.dir/src/Datasource/Camera/Camera.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/joel/repos/infinus/prosur/prosurd/src/Datasource/Camera/Camera.cpp > CMakeFiles/prosurd.dir/src/Datasource/Camera/Camera.cpp.i

CMakeFiles/prosurd.dir/src/Datasource/Camera/Camera.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/prosurd.dir/src/Datasource/Camera/Camera.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/joel/repos/infinus/prosur/prosurd/src/Datasource/Camera/Camera.cpp -o CMakeFiles/prosurd.dir/src/Datasource/Camera/Camera.cpp.s

# Object files for target prosurd
prosurd_OBJECTS = \
"CMakeFiles/prosurd.dir/src/Main.cpp.o" \
"CMakeFiles/prosurd.dir/src/Log.cpp.o" \
"CMakeFiles/prosurd.dir/src/Datasource/RepRap/RepRap.cpp.o" \
"CMakeFiles/prosurd.dir/src/Webserver/Webserver.cpp.o" \
"CMakeFiles/prosurd.dir/src/Webserver/Resources/Frames.cpp.o" \
"CMakeFiles/prosurd.dir/src/Webserver/Resources/Jobs.cpp.o" \
"CMakeFiles/prosurd.dir/src/Webserver/Resources/Job.cpp.o" \
"CMakeFiles/prosurd.dir/src/Webserver/Resources/File.cpp.o" \
"CMakeFiles/prosurd.dir/src/Webserver/Resources/Client.cpp.o" \
"CMakeFiles/prosurd.dir/src/Database/Database.cpp.o" \
"CMakeFiles/prosurd.dir/src/Database/DBUtil.cpp.o" \
"CMakeFiles/prosurd.dir/src/Database/Frame.cpp.o" \
"CMakeFiles/prosurd.dir/src/Util/Util.cpp.o" \
"CMakeFiles/prosurd.dir/src/JobFile/JobFile.cpp.o" \
"CMakeFiles/prosurd.dir/src/JobFile/ParameterExtractor/PrusaSlicer.cpp.o" \
"CMakeFiles/prosurd.dir/src/Datasource/AuxTemp/AuxTemp.cpp.o" \
"CMakeFiles/prosurd.dir/src/HTTPClient/HTTPClient.cpp.o" \
"CMakeFiles/prosurd.dir/src/Datasource/Camera/Camera.cpp.o"

# External object files for target prosurd
prosurd_EXTERNAL_OBJECTS =

prosurd: CMakeFiles/prosurd.dir/src/Main.cpp.o
prosurd: CMakeFiles/prosurd.dir/src/Log.cpp.o
prosurd: CMakeFiles/prosurd.dir/src/Datasource/RepRap/RepRap.cpp.o
prosurd: CMakeFiles/prosurd.dir/src/Webserver/Webserver.cpp.o
prosurd: CMakeFiles/prosurd.dir/src/Webserver/Resources/Frames.cpp.o
prosurd: CMakeFiles/prosurd.dir/src/Webserver/Resources/Jobs.cpp.o
prosurd: CMakeFiles/prosurd.dir/src/Webserver/Resources/Job.cpp.o
prosurd: CMakeFiles/prosurd.dir/src/Webserver/Resources/File.cpp.o
prosurd: CMakeFiles/prosurd.dir/src/Webserver/Resources/Client.cpp.o
prosurd: CMakeFiles/prosurd.dir/src/Database/Database.cpp.o
prosurd: CMakeFiles/prosurd.dir/src/Database/DBUtil.cpp.o
prosurd: CMakeFiles/prosurd.dir/src/Database/Frame.cpp.o
prosurd: CMakeFiles/prosurd.dir/src/Util/Util.cpp.o
prosurd: CMakeFiles/prosurd.dir/src/JobFile/JobFile.cpp.o
prosurd: CMakeFiles/prosurd.dir/src/JobFile/ParameterExtractor/PrusaSlicer.cpp.o
prosurd: CMakeFiles/prosurd.dir/src/Datasource/AuxTemp/AuxTemp.cpp.o
prosurd: CMakeFiles/prosurd.dir/src/HTTPClient/HTTPClient.cpp.o
prosurd: CMakeFiles/prosurd.dir/src/Datasource/Camera/Camera.cpp.o
prosurd: CMakeFiles/prosurd.dir/build.make
prosurd: /usr/lib/x86_64-linux-gnu/libpq.so
prosurd: /usr/lib/x86_64-linux-gnu/libv4l2.so
prosurd: CMakeFiles/prosurd.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/joel/repos/infinus/prosur/prosurd/build_TEST_FLAG_WEBMON_ONLY/CMakeFiles --progress-num=$(CMAKE_PROGRESS_19) "Linking CXX executable prosurd"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/prosurd.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/prosurd.dir/build: prosurd

.PHONY : CMakeFiles/prosurd.dir/build

CMakeFiles/prosurd.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/prosurd.dir/cmake_clean.cmake
.PHONY : CMakeFiles/prosurd.dir/clean

CMakeFiles/prosurd.dir/depend:
	cd /home/joel/repos/infinus/prosur/prosurd/build_TEST_FLAG_WEBMON_ONLY && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/joel/repos/infinus/prosur/prosurd /home/joel/repos/infinus/prosur/prosurd /home/joel/repos/infinus/prosur/prosurd/build_TEST_FLAG_WEBMON_ONLY /home/joel/repos/infinus/prosur/prosurd/build_TEST_FLAG_WEBMON_ONLY /home/joel/repos/infinus/prosur/prosurd/build_TEST_FLAG_WEBMON_ONLY/CMakeFiles/prosurd.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/prosurd.dir/depend

