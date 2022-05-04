function [angle_estimation, range_estimation] = get_IF_estimations(params, time_signal_all)
    
radarRaw = reshape(time_signal_all,...
                size(time_signal_all,1), ...
                size(time_signal_all,2), ...
                size(time_signal_all,3)*size(time_signal_all,4));

radarRaw = squeeze(radarRaw);
radarRaw = radarRaw(:, params.antenna_azimuthonly);

% [instf,t]=instfreq(radar_data');
% figure,
% plot(t, instf);

IF_means = zeros(1, size(radarRaw, 2));
for i=1:size(radarRaw, 2)
    radar_signal = radarRaw(:, i);
    [instf,~]=instfreq(radar_signal);
    IF_means(i) = mean(instf);
end

% figure,
% plot(IF_means);

c = polyfit(1:size(radarRaw, 2),IF_means,1);

angle_estimation = asind(params.speedOfLight*c(1)/(19.89*(2*pi*params.alpha*params.antennaDistance)));
% disp(['angle estimated = ' num2str(angle_estimation) '  (' num2str(obj_angle) ' )']);

range_estimation = IF_means(1) * params.speedOfLight / (19.89*4*pi*params.alpha) * 1e9;

end