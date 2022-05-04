function [range_peaks_location, range_peaks_locations, range_fft_peaks, radar_range_fft_linear] = calcultate_range(time_signal_all, params)
% find range
radar_range_fft = fft(time_signal_all, params.interp_fact*params.rangeFFTSize, 2);
radar_range_fft_linear = reshape(radar_range_fft,...
                            size(radar_range_fft,1), ...
                            size(radar_range_fft,2), ...
                            size(radar_range_fft,3)*size(radar_range_fft,4));
radar_range_fft_linear = squeeze(radar_range_fft_linear);
sig_integrate = sum((abs(radar_range_fft_linear)).^2,2) + 1;

limits = floor(params.interp_fact*params.rangeFFTSize*(10/1024));
range_fft_peaks = zeros(1, size(radar_range_fft_linear, 2));
for rng = 1:size(radar_range_fft_linear, 2)
    signal = abs(radar_range_fft_linear(:, rng));
    peak_height = mean(signal) + 0 * std(signal); 
    [~, range_peaks_locations(rng)] = findpeaks(signal(limits+1:end-limits),'MinPeakHeight',peak_height, 'SortStr', 'descend', 'NPeaks', 1);
    range_peaks_locations(rng) = range_peaks_locations(rng) + limits;
    range_distances(rng) = (range_peaks_locations(rng) / params.interp_fact) * params.rangeBinSize;
    range_fft_peaks(1, rng) = radar_range_fft_linear(range_peaks_locations(rng), rng);
end

peak_height = mean(sig_integrate) + 0 * std(sig_integrate); 
[~, range_peaks_location] = findpeaks(sig_integrate(limits+1:end-limits),'MinPeakHeight',peak_height, 'SortStr', 'descend', 'NPeaks', 1);
range_peaks_location = range_peaks_location + limits;
range_fft_peaks = radar_range_fft_linear(range_peaks_location, :);

end