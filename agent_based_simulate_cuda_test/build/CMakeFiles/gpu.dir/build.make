# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.22

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
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
RM = /usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/yihua/Desktop/267_final_project/agent_based_simulate_cuda_test

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/yihua/Desktop/267_final_project/agent_based_simulate_cuda_test/build

# Include any dependencies generated for this target.
include CMakeFiles/gpu.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/gpu.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/gpu.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/gpu.dir/flags.make

CMakeFiles/gpu.dir/gpu_generated_main.cu.o: CMakeFiles/gpu.dir/gpu_generated_main.cu.o.depend
CMakeFiles/gpu.dir/gpu_generated_main.cu.o: CMakeFiles/gpu.dir/gpu_generated_main.cu.o.cmake
CMakeFiles/gpu.dir/gpu_generated_main.cu.o: ../main.cu
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --blue --bold --progress-dir=/home/yihua/Desktop/267_final_project/agent_based_simulate_cuda_test/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building NVCC (Device) object CMakeFiles/gpu.dir/gpu_generated_main.cu.o"
	cd /home/yihua/Desktop/267_final_project/agent_based_simulate_cuda_test/build/CMakeFiles/gpu.dir && /usr/bin/cmake -E make_directory /home/yihua/Desktop/267_final_project/agent_based_simulate_cuda_test/build/CMakeFiles/gpu.dir//.
	cd /home/yihua/Desktop/267_final_project/agent_based_simulate_cuda_test/build/CMakeFiles/gpu.dir && /usr/bin/cmake -D verbose:BOOL=$(VERBOSE) -D build_configuration:STRING= -D generated_file:STRING=/home/yihua/Desktop/267_final_project/agent_based_simulate_cuda_test/build/CMakeFiles/gpu.dir//./gpu_generated_main.cu.o -D generated_cubin_file:STRING=/home/yihua/Desktop/267_final_project/agent_based_simulate_cuda_test/build/CMakeFiles/gpu.dir//./gpu_generated_main.cu.o.cubin.txt -P /home/yihua/Desktop/267_final_project/agent_based_simulate_cuda_test/build/CMakeFiles/gpu.dir//gpu_generated_main.cu.o.cmake

# Object files for target gpu
gpu_OBJECTS =

# External object files for target gpu
gpu_EXTERNAL_OBJECTS = \
"/home/yihua/Desktop/267_final_project/agent_based_simulate_cuda_test/build/CMakeFiles/gpu.dir/gpu_generated_main.cu.o"

gpu: CMakeFiles/gpu.dir/gpu_generated_main.cu.o
gpu: CMakeFiles/gpu.dir/build.make
gpu: /usr/lib/x86_64-linux-gnu/libcudart_static.a
gpu: /usr/lib/x86_64-linux-gnu/librt.a
gpu: CMakeFiles/gpu.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/yihua/Desktop/267_final_project/agent_based_simulate_cuda_test/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable gpu"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/gpu.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/gpu.dir/build: gpu
.PHONY : CMakeFiles/gpu.dir/build

CMakeFiles/gpu.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/gpu.dir/cmake_clean.cmake
.PHONY : CMakeFiles/gpu.dir/clean

CMakeFiles/gpu.dir/depend: CMakeFiles/gpu.dir/gpu_generated_main.cu.o
	cd /home/yihua/Desktop/267_final_project/agent_based_simulate_cuda_test/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/yihua/Desktop/267_final_project/agent_based_simulate_cuda_test /home/yihua/Desktop/267_final_project/agent_based_simulate_cuda_test /home/yihua/Desktop/267_final_project/agent_based_simulate_cuda_test/build /home/yihua/Desktop/267_final_project/agent_based_simulate_cuda_test/build /home/yihua/Desktop/267_final_project/agent_based_simulate_cuda_test/build/CMakeFiles/gpu.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/gpu.dir/depend

