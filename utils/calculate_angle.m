function [angles, angle_fft_peak_locations] = calculate_angle(params, radar_data, window)
if nargin < 3
   window = ''; 
end

if strcmp(window, 'Hanning')
   w = hann(length(radar_data));
elseif strcmp(window, 'Harris')
   w = blackmanharris(length(radar_data)); 
elseif strcmp(window, 'Hamming')
   w = hamming(length(radar_data)); 
else 
    % No Window
   w = ones(length(radar_data), 1); 
end
    
radar_data_w = radar_data' .* w;
radar_rangle_angle_fft = fft(radar_data_w', 1024, 2);
angle_fft = fftshift(radar_rangle_angle_fft, 2);
angle_fft = cat(2, angle_fft, angle_fft(1:20));

peak_height = mean(abs(angle_fft)) + 1 * std(abs(angle_fft)); 
[~,angle_fft_peak_locations] = findpeaks(abs(angle_fft), 'MinPeakHeight', peak_height, 'SortStr', 'descend', 'NPeaks', 2);
angle_fft_peak_locations = angle_fft_peak_locations - 1;

wx_vec=-pi:2*pi/1024:pi;
wx_vec = wx_vec(1:end-1);
angles = asind(wx_vec(mod(angle_fft_peak_locations, 1024)+1)/(2*pi*params.d_optimal*1));

end