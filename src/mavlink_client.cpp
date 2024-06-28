#include "mavlink_client.hpp"
#include <iostream>
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <stdint.h>


MavlinkClient::MavlinkClient() {
    RETURN_TYPE status = this->initialize();

    if (status) {
        this->is_initilized = true;
    }
}

MavlinkClient::~MavlinkClient() {

}


MavlinkClient::RETURN_TYPE MavlinkClient::initialize() {
    this->socket_fd = socket(PF_INET, SOCK_DGRAM, 0);

    if (socket_fd < 0) {
        std::cerr << "socket error: " << strerror(errno) << std::endl;
        return BAD;
    }

    return GOOD;
}