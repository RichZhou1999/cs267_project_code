cmake_minimum_required(VERSION 3.10 FATAL_ERROR)
project(gpu LANGUAGES CXX CUDA)
find_package(CUDA REQUIRED)

set(CMAKE_CXX_STANDARD 14)
# set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -pedantic")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall")

set(CUDA_NVCC_FLAGS "${CUDA_NVCC_FLAGS} -g -G")
set(CUDA_LINK_LIBRARIES_KEYWORD PRIVATE)

cuda_add_executable(gpu main.cu)
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} -g -G")
    set(CMAKE_CUDA_DEBUGGER_EXECUTABLE "cuda-gdb")
    set_property(TARGET gpu PROPERTY CUDA_DEBUGGER_ARGS "-x ${CMAKE_CURRENT_SOURCE_DIR}/debugger.gdb")
endif()