%% Radar Model
clear all;
% close all;
% clc;

addpath('utils\');
addpath(genpath('..\tftb-0.1'))

params = get_parameters('short');
params = set_antenna_position(params);

coeff_gain = 0.6; % approximately +-5dB = 0.60
coeff_phase = 0.005; % +-4.5 degrees = 0.05
all_mismatches = generate_mismatch(params, coeff_gain, coeff_phase);

noise.sigma = 0.01;
noise.mean = 0;

target_distance = 6.12;
% obj_angle = -55;
count = 1;
angles_tested = -73:0.1:73;
for ang = angles_tested
    obj_angle = ang;
    target_angle = -1 * obj_angle;
    target_position = target_distance * [sind(target_angle), 0, cosd(target_angle)]';


    [time_signal_all, d_td] = simulate_radar(params, target_position, noise, all_mismatches);

    [range_peaks_location, range_peaks_locations, range_fft_peaks, radar_range_fft_linear] = calcultate_range(time_signal_all, params);
    radar_data = range_fft_peaks(:, params.antenna_azimuthonly);

    window = '';
    [angles, angle_fft_peak_locations] = calculate_angle(params, radar_data, window);
    angle_estimation_fft(count) = angles(1);
    range_estimation_fft(count) = range_peaks_location * params.rangeBinSize;

    %% IF estimations
    [angle_estimation(count), range_estimation(count)] = get_IF_estimations(params, time_signal_all);
    count = count + 1;

%     disp(['angle estimated = ' num2str(angle_estimation) '  (' num2str(obj_angle) ' )']);
%     disp(['range estimated = ' num2str(range_estimation) '  (' num2str(target_distance) ' )']);

end
range_estimation_fft(range_estimation_fft > 0) = range_estimation_fft(range_estimation_fft > 0) - params.rangeBinSize;

%% Draw figures

angle_errors = angle_estimation - angles_tested;
angle_errors_fft = angle_estimation_fft - angles_tested;
figure, 
hold on;
plot(angles_tested, abs(angle_errors))
plot(angles_tested, abs(angle_errors_fft))
legend('IF estimation', 'FFT estimation')
xlabel('Angle of the Object (degrees)')
ylabel('Angle Errors (degrees)')
title('Comparison of Angle Estimation Errors')

range_errors = range_estimation - target_distance;
range_errors_fft = range_estimation_fft - target_distance;
figure,
hold on;
plot(angles_tested, abs(range_errors))
plot(angles_tested, abs(range_errors_fft))
legend('IF estimation', 'FFT estimation')
xlabel('Angle of the Object (degrees)')
ylabel('Range Estimation Errors (m)')
title('Comparison of Range Estimation Errors')
ylim([0, 0.1])
