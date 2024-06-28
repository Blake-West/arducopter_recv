#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/socket.h>


class MavlinkClient {
    typedef enum {
       BAD, GOOD
    } RETURN_TYPE;
    public:
        MavlinkClient();
        ~MavlinkClient();



    private:
        RETURN_TYPE initialize();

        bool is_initilized = false;

        int socket_fd = 0;
};