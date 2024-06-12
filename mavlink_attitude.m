clear % clear up remaining receiver
dialect = mavlinkdialect("mavlink/message_definitions/common.xml");

mavlink_forward_port = 14445; % default port forwarding from ground station
window = 1000;

x_axis = 1:1:window;
yaw_vector = nan(1, window);
pitch_vector = nan(1, window);
roll_vector = nan(1, window);
mavlink_receiver = mavlinkio(dialect);
mavlink_client = mavlinkclient(mavlink_receiver, 1, 1);
connect(mavlink_receiver, "UDP", "LocalPort", mavlink_forward_port);

attitude_sub = mavlinksub(mavlink_receiver, mavlink_client, "ATTITUDE");
figure;
yaw_plot = plot(x_axis, yaw_vector);
ylim([-1, 1]);

num_messages = 0;


while true
    % read message from attitude subscription
    message = latestmsgs(attitude_sub, 1);
    is_message_empty = isempty(message);

    % if the message is not empty add it to the circular buffer
    if ~is_message_empty
        payload = message.Payload;

        % this is how we create a "circular" buffer
        yaw_vector = [yaw_vector(2:end), payload.yaw];
        % yaw_vector(vector_index) = payload.yaw;
        num_messages = num_messages + 1;
    end

    % update the plot
    if num_messages > 9 || is_message_empty
        num_messages = 0; % reset num_messages
                          % this should really be like messages since
                          % print
        
        % Where I'm lost.
        % How do we actually update the plots in real time?
        % Are we constrained somehow?
        set(yaw_plot, 'YData', yaw_vector);
        drawnow;
        pause(0.05);
        
    end
end