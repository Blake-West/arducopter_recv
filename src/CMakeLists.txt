

add_executable(MAVLinkRecorder main.cpp mavlink_client.cpp)
target_link_libraries(MAVLinkRecorder PRIVATE MAVLink::mavlink pthread)
install(TARGETS MAVLinkRecorder)