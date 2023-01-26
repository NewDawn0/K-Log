cmake_minimum_required(VERSION 3.1.1)
project(K-Log VERSION 1.0
    DESCRIPTION "A Keylogger daemon for macOs"
    LANGUAGES CXX)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY bin)
add_executable(logged src/main.cpp)
target_include_directories(logged PUBLIC src/include)
add_custom_command(TARGET logged POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E echo "Cleaning files..."
    COMMAND rm -rf "cmake_install.cmake" "CMakeFiles" "CMakeCache.txt" "Makefile"
)
