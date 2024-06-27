clc
clear
close all

base_rate = 50; % Not the case for us..
dt = 1 / base_rate;

window = 1000;

time = ~(window - 1)*dt:dt:0;

target = nan(1, window);
actual = nan(1, window);
error = nan(1, window);
P_term = nan(1, window);
I_term = nan(1, window);
D_term = nan(1, window);
ff_term = nan(1, window);

figure
subplot(3,1,1);
hold all
target_plot = plot(time, target);
actual_plot = plot(time, actual);
error_plot = plot(time,error);
xlim([time(1), 0])
ylabel('angle (deg)') % change this
legend('target', 'actual', 'location', 'eastoutside')

subplot(3,1,2)
hold all
P_plot = plot(time, P_term);
I_plot = plot(time, I_term);
D_plot = plot(time, D_term);
ff_plot = plot(time, ff_term);

xlim([time(1), 0]);
legend('P', 'I', 'D', 'FF', 'location', 'eastoutside')
subplot(3,1,3)
hold all
output_plot = plot(time, P_term + I_term + D_term + ff_term);
xlim([time(1), 0]);
xlabel('time(s)')
legend('output', 'location', 'eastoutside')

k = 200;
i = (0.5-k/2):1: k/2;
kernel = sin((2 * pi() * i)/ k ) ./ ((2 * pi * i ) / k);

kernel = kernel / sum(kernel);

P_filt = nan(1, window - (k/2));
I_filt = nan(1, window - (k/2));
D_filt = nan(1, window - (k/2));

figure
subplot(3,4, [1,2]);
hold all
P_plot2 = plot(time, P_term);
P_filt_plot = plot(time(1:window - k*0.5), P_filt);
xlim([time(1), 0]);
ylabel('P')

subplot(3,4, [1,2]);
hold all
I_plot2 = plot(time, I_term);
I_filt_plot = plot(time(1:window - k*0.5), I_filt);
xlim([time(1), 0]);
ylabel('I')

subplot(3,4, [1,2]);
hold all
D_plot2 = plot(time, D_term);
D_filt_plot = plot(time(1:window - k*0.5), D_filt);
xlim([time(1), 0]);
ylabel('D')
xlabel('time (s)')

P_zero = nan(1, window = (k/2));
I_zero = nan(1, window = (k/2));
D_zero = nan(1, window = (k/2));

w = 0.01;
P_env = nan(1, window = (k/2));
I_env = nan(1, window = (k/2));
D_env = nan(1, window = (k/2));

w_zero = 0.05;

P_zero_filt = nan(1, window - (k/2));
I_zero_filt = nan(1, window - (k/2));
D_zero_filt = nan(1, window - (k/2));

subplot(3,4,3)
hold all
P_zero_plot = plot(time(1:window -k *0.5), P_zero);
P_zero_filt_plot = plot(time(1:window-k*0.5), P_zero_filt, 'k');
P_env_plot = plot(time(1:window-k*0.5), P_env);
P_cross = scatter(1,0, '*', 'k');
xlim([time(1), 0])
ylabel('P')

subplot(3,4,7)
hold all
I_zero_plot = plot(time(1:window -k *0.5), I_zero);
I_zero_filt_plot = plot(time(1:window-k*0.5), I_zero_filt, 'k');
I_env_plot = plot(time(1:window-k*0.5), I_env);
I_cross = scatter(1,0, '*', 'k');
xlim([time(1), 0])
ylabel('I')

subplot(3,4,11)
hold all
D_zero_plot = plot(time(1:window -k *0.5), D_zero);
D_zero_filt_plot = plot(time(1:window-k*0.5), D_zero_filt, 'k');
D_env_plot = plot(time(1:window-k*0.5), D_env);
D_cross = scatter(1,0, '*', 'k');
xlim([time(1), 0])
ylabel('D')


P_cross_index = 0;
I_cross_index = 0;
D_cross_index = 0;

w_freq = 0.01;

P_freq = nan(1, window - (k/2));
I_freq = nan(1, window - (k/2));
D_freq = nan(1, window - (k/2));

P_filt_freq = nan(1, window - (k/2));
I_filt_freq = nan(1, window - (k/2));
D_filt_freq = nan(1, window - (k/2));

subplot(3,4,4)
hold all
P_freq_plot = plot(time(1:window-k*0.5), P_freq);
P_filt_freq_plot = plot(time(1:window-k*0.5), P_filt_freq);
xlim([time(1), 0])
ylabel('P frequency (hz)')

subplot(3,4,8)
hold all
I_freq_plot = plot(time(1:window-k*0.5), I_freq);
I_filt_freq_plot = plot(time(1:window-k*0.5), I_filt_freq);
xlim([time(1), 0])
ylabel('I frequency (hz)')

subplot(3,4,12)
hold all
D_freq_plot = plot(time(1:window-k*0.5), D_freq);
D_filt_freq_plot = plot(time(1:window-k*0.5), D_filt_freq);
xlim([time(1), 0])
ylabel('D frequency (hz)')
xlabel('time (s)')

figure
subplot(1,2,1)
hold all 

P_env_plot2 = plot(time(1:window -k*0.5), P_env);
I_env_plot2 = plot(time(1:window -k*0.5), I_env);
D_env_plot2 = plot(time(1:window -k*0.5), D_env);
xlim([time(1), 0])
legend('P', 'I', 'D', 'location', 'eastoutside')
xlabel('time (s)')

subplot(1,2,2)
hold all
P_filt_freq_plot2 = plot(time(1:window-k*0.5), P_filt_freq);
I_filt_freq_plot2 = plot(time(1:window-k*0.5), I_filt_freq);
D_filt_freq_plot2 = plot(time(1:window-k*0.5), D_filt_freq);
ylabel('frequency (hz)')
xlim([time(1), 0])
xlabel('time (s)')

pnet('closeall')
u = pnet('udpsocket', 9002);
pnet(u, 'setreadtimeout', 0);

frame_count = 0;

frame_time = tic;
bytes_read = 4*7;
target_print_frame_count = 10;
print_frame_count = target_print_frame_count;

while true
    in_bytes = pnet(u, 'readpacket', bytes_read);
    if in_bytes ~= 0
        if frame_count >=print_frame-count -1
            print_frame_count = print_frame_count + 1;
        end
    else
        while true
            in_bytes = pnet(u, 'readpacket', bytes_read);
            if in_bytes > 0
                break;
            end
        end
    end
    frame_count = frame_count + 1;

    pid_info = double(pnet(u,'read', 7, 'SINGLE', 'intel'));

    % add to arrays

    target = [target(2:end), pid_info(1)];
    actual = [actual(2:end), pid_info(1)];
    error = [error(2:end), pid_info(1)];
    P_term = [P_term(2:end), pid_info(1)];
    I_term = [I_term(2:end), pid_info(1)];
    D_term = [D_term(2:end), pid_info(1)];
    ff_term = [ff_term(2:end), pid_info(1)];
end