clear; close all;% clear up remaining receiver
dialect = mavlinkdialect("mavlink/message_definitions/common.xml");
save_attitude_as_csv = true;
mavlink_forward_port = 14445; % default port forwarding from ground station
window_size = 10000;

x_axis = 1:1:window_size;
yaw_vector = nan(1, window_size);
pitch_vector = nan(1, window_size);
roll_vector = nan(1, window_size);
mavlink_receiver = mavlinkio(dialect);
mavlink_client = mavlinkclient(mavlink_receiver, 1, 1);
connect(mavlink_receiver, "UDP", "LocalPort", mavlink_forward_port);

attitude_sub = mavlinksub(mavlink_receiver, mavlink_client, "ATTITUDE");
figure('Name', "YPR");
subplot(3,1,1);
yaw_plot = plot(x_axis, yaw_vector, 'r', 'LineWidth', 2);
title('Yaw');
subplot(3,1,2);
pitch_plot = plot(x_axis, pitch_vector, 'g', 'LineWidth', 2);
title('Pitch')
subplot(3,1,3);
title('Roll')
roll_plot = plot(x_axis, roll_vector, 'b', 'LineWidth', 2);

%%ylim([-1, 1]);
hold off
number_of_messages_since_print = 0;
print_after_how_many_messages = 50;

if save_attitude_as_csv
    f = fopen("attitude.csv", "w");
    fprintf(f,  'time_boot_ms, yaw, pitch, roll, yaw_rate, pitch_rate, roll_rate \n');
end
while true
    % read message from attitude subscription
    message = latestmsgs(attitude_sub, 1);
    is_message_empty = isempty(message);
    % payload =  0;
    % if the message is not empty add it to the circular buffer
    if ~is_message_empty
        payload = message.Payload;

        % this is how we create a "circular" buffer
        yaw_vector = [yaw_vector(2:end), payload.yaw];
        pitch_vector = [pitch_vector(2:end), payload.pitch];
        roll_vector = [roll_vector(2:end), payload.roll];
        % yaw_vector(vector_index) = payload.yaw;
        number_of_messages_since_print = number_of_messages_since_print + 1;
        if save_attitude_as_csv
            fprintf(f, '%d, %.16f, %.16f, %.16f, %.16f, %.16f, %.16f', payload.time_boot_ms, payload.yaw, payload.pitch, ...
                payload.yawspeed, payload.pitchspeed, payload.rollspeed);
            fprintf(f, '\n');
        end
    end
    
    % update the plot
    if is_message_empty || number_of_messages_since_print > print_after_how_many_messages
        number_of_messages_since_print = 0;
        
        % disp(payload);
        set(yaw_plot, 'YData', yaw_vector);
        set(pitch_plot, 'YData', pitch_vector);
        set(roll_plot, 'YData', roll_vector);
        drawnow;
        
    end
end
if save_attitude_as_csv 
    fclose(f);
end