project("Mavlink Attitude Recorder")
cmake_minimum_required(VERSION 3.1)

set(CMAKE_CXX_STANDARD 11)

set(CMAKE_INSTALL_PREFIX ${CMAKE_SOURCE_DIR})
list(APPEND CMAKE_PREFIX_PATH ${CMAKE_SOURCE_DIR}/mavlink/install)

set(MAVLINK_DIALECT "common" CACHE STRING "MAVLink Dialect")
set(MAVLINK_VERSION "2.0" CACHE STRING "MAVLink Version")
find_package(MAVLink REQUIRED)

add_subdirectory(src)
