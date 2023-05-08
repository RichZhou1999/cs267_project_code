cmake_minimum_required(VERSION 3.0)
project(create_network)
find_package(CUDA REQUIRED)
find_package(OpenMP REQUIRED)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
find_package(Boost REQUIRED COMPONENTS graph)

include_directories(${Boost_INCLUDE_DIRS})
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -pedantic")

set(CUDA_NVCC_FLAGS "${CUDA_NVCC_FLAGS} -g -G")
set(CUDA_LINK_LIBRARIES_KEYWORD PRIVATE)

add_executable(create_network main.cpp)

target_link_libraries(create_network ${Boost_LIBRARIES})
# if(CMAKE_BUILD_TYPE STREQUAL "Debug")
#     set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} -g -G")
#     set(CMAKE_CUDA_DEBUGGER_EXECUTABLE "cuda-gdb")
#     set_property(TARGET create_network PROPERTY CUDA_DEBUGGER_ARGS "-x ${CMAKE_CURRENT_SOURCE_DIR}/debugger.gdb")
# endif()