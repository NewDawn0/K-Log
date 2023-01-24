cmake_minimum_required(VERSION 3.1.1)
project(K-Log VERSION 1.0
    DESCRIPTION "A Keylogger daemon for macOs"
    LANGUAGES CXX)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY bin)
add_executable(k-log src/main.cpp)
target_include_directories(k-log PUBLIC src/include)
add_custom_command(TARGET k-log POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E echo "Cleaning files..."
    COMMAND rm -rf "cmake_install.cmake" "CMakeFiles" "CMakeCache.txt" "Makefile"
)
