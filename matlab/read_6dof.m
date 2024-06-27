% C++ Struct is of the following form
% {
%  float roll;
%  float pitch;
%  float yaw;
%  float roll_rate;
%  float pitch_rate;
%  float yaw_rate;
% 
% }
clc
clear
close all

% Initialize parameters
datagram_size = 6 * 4;
window_size = 1000;
udpReceiver = udpport('LocalPort', 8903, 'ByteOrder', 'little-endian');

% Initialize circular buffers
rollBuffer = CircularBuffer(window_size, 'single');
pitchBuffer = CircularBuffer(window_size, 'single');
yawBuffer = CircularBuffer(window_size, 'single');
rollRateBuffer = CircularBuffer(window_size, 'single');
pitchRateBuffer = CircularBuffer(window_size, 'single');
yawRateBuffer = CircularBuffer(window_size, 'single');

% Set up the plot
figure
rollPlot = subplot(3, 1, 1)
hold all
roll_plot = plot(rollBuffer);
pitchPlot = subplot(3, 1, 2);
yawPlot = subplot(3, 1, 3);

% Plot properties
rollLine = plot(rollPlot, zeros(window_size, 1), 'r');
pitchLine = plot(pitchPlot, zeros(window_size, 1), 'g');
yawLine = plot(yawPlot, zeros(window_size, 1), 'b');

% Set plot titles and labels
title(rollPlot, 'Roll');
xlabel(rollPlot, 'Sample');
ylabel(rollPlot, 'Value');
title(pitchPlot, 'Pitch');
xlabel(pitchPlot, 'Sample');
ylabel(pitchPlot, 'Value');
title(yawPlot, 'Yaw');
xlabel(yawPlot, 'Sample');
ylabel(yawPlot, 'Value');

% Real-time data acquisition and plotting

frame_count = 0;
frame_time 
while true
    % Check if data is available
    if udpReceiver.NumBytesAvailable >= datagram_size
        % Read the data as a single precision float array
        data = read(udpReceiver, 6, 'single');
        
        % Update the circular buffers
        rollBuffer.update(data(1));
        pitchBuffer.update(data(2));
        yawBuffer.update(data(3));
        rollRateBuffer.update(data(4));
        pitchRateBuffer.update(data(5));
        yawRateBuffer.update(data(6));
        display(data(1));

        % Get ordered buffers for plotting
        rollData = rollBuffer.getOrderedBuffer(mod(rollBuffer.CurrentIndex + 1, window_size) + 1);
        pitchData = pitchBuffer.getOrderedBuffer(mod(pitchBuffer.CurrentIndex + 1, window_size) + 1);
        yawData = yawBuffer.getOrderedBuffer(mod(yawBuffer.CurrentIndex + 1, window_size) + 1);
        
        % Update plot data
        set(rollLine, 'YData', rollData);
        set(pitchLine, 'YData', pitchData);
        set(yawLine, 'YData', yawData);
        
        % Refresh the plot
        drawnow;
    end
    
    pause(0.01); % To prevent busy-waiting
end

clear udpReceiver;