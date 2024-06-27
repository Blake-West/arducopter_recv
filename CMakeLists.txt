project("Mavlink Attitude Recorder")
cmake_minimum_required(VERSION 3.1)

set(CMAKE_CXX_STANDARD 11)

#set(CMAKE_INSTALL_PREFIX ${CMAKE_SOURCE_DIR}"/install")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin)


set(MAVLINK_DIALECT "common" CACHE STRING "MAVLink Dialect")
set(MAVLINK_VERSION "2.0" CACHE STRING "MAVLink Version")
include_directories(${CMAKE_SOURCE_DIR}/mavlink_2.0)
include_directories(${CMAKE_SOURCE_DIR}/src)
find_package(MAVLink REQUIRED)




add_executable(MAVLinkRecorder src/main.cpp)
target_link_libraries(MAVLinkRecorder PRIVATE MAVLink::mavlink pthread)
install(TARGETS MAVLinkRecorder DESTINATION bin)

