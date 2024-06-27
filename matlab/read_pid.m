clc
clear
close all

% Copter rate is at 20Hz
base_rate = 20;
dt = 1/base_rate;

window = 1000;

time = -(window -1)*dt:dt:0;

target = nan(1, window);
actual = nan(1, window);
error = nan(1, window);
P_term = nan(1, window);
I_term = nan(1, window);
D_term = nan(1, window);
FF_term = nan(1, window);
DFF_term = nan(1, window);
Dmod_term = nan(1, window);
slew_rate = nan(1, window);
limit = nan(1, window);
PD_limit = nan(1, window);
reset = nan(1, window);
I_term_set = nan(1, window);


figure
subplot(3,1,1)
hold all

target_plot = plot(time, target);
actual_plot = plot(time, actual);
error_plot = plot(time, error);

xlim([time(1), 0]);
ylabel('angle (deg)');
legend('target', 'actual', 'error', 'location', 'eastoutside');

receiver=pnet('udpsocket', 9876);
pnet(receiver, 'setreadtimeout', 0);

datagram_size = 11 * 4;
frame_count = 0;
frame_time = tic;
target_print_frame_count = 10;

print_frame_count = target_print_frame_count;


while true
    read_bytes = pnet(receiver, 'readpacket', datagram_size);

    if read_bytes ~= 0
        if frame_count > print_frame_count - 1
            % there is already data waiting. and should have made up 
            % time since the last plot by now
            % bump the plot time so we can catch up.
            print_frame_count = print_frame_count + 1;
        end
    else
        while true
            read_bytes = pnet(receiver, 'readpacket', datagram_size);
            if read_bytes > 0
                break
            end
        end
    end
    frame_count = frame_count + 1;

    pid_info = double(pnet(receiver, 'read', 10, 'SINGLE', 'intel'));
    status_info = uint8(pnet(receive, 'read', 4, 'uint8', 'intel'));

    disp(pid_info);

end