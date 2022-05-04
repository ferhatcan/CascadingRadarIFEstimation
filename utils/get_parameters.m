function params = get_parameters(param_name)
if nargin < 1
    param_name = 'short';
end
%% Parameters
params = struct();

if strcmp(param_name, 'short')
    params.chirpSlope = 7.898600e+13; %Hz/s 
elseif strcmp(param_name, 'mid')
    params.chirpSlope = 2.4e+13; %Hz/s 
elseif strcmp(param_name, 'long')
    params.chirpSlope = 0.8e+13; %Hz/s 
end

slope_cal = @(dmax, params) params.adcSampleRate * params.speedOfLight / (2 * dmax);


params.numADCSample = 2.560000e+02; 
params.adcSampleRate = 8.000000e+06; %Hz/s 
params.startFreqConst = 7.700000e+10; %Hz 

params.chirpIdleTime = 5.000000e-06; %s 
params.adcStartTimeConst = 6.000000e-06; %s 
params.chirpRampEndTime = 4.000000e-05; %s 
params.framePeriodicty = 1.000000e-01; 
params.frameCount = 1.000000e+01; %s 
params.numChirpsInLoop = 1.200000e+01; %s 
params.nchirp_loops = 1; 
params.centerFreq = 7.826378e+10;
params.TI_Cascade_Antenna_DesignFreq = 76.8e+9;
params.speedOfLight = 3e8;
params.interp_fact = 1;

params.chirpRampTime = params.numADCSample/params.adcSampleRate;
params.chirpBandwidth = params.chirpSlope * params.chirpRampTime; % Hz
params.rangeResolution = params.speedOfLight/2/params.chirpBandwidth;
params.rangeFFTSize = 1024;%2^(ceil(log2(params.numADCSample)));
params.rangeBinSize = params.rangeResolution*params.numADCSample/params.rangeFFTSize;

params.alpha = params.chirpBandwidth / params.chirpRampTime;
params.d_optimal = 0.5 * params.centerFreq / params.TI_Cascade_Antenna_DesignFreq;

params.TI_Cascade_TX_position_azi = 0:4:32;
params.TI_Cascade_RX_position_azi = [ 0:3 11:14 46:49 50:53 ];
% params.TI_Cascade_RX_position_azi = [ 46:49 50:53 ];
% params.TI_Cascade_TX_position_azi = 0;
% params.TI_Cascade_RX_position_azi = 0:64;
params.numTxAnt = size(params.TI_Cascade_TX_position_azi, 2); 
params.numRxAnt = size(params.TI_Cascade_RX_position_azi, 2); 

params.antennaDistance = params.d_optimal * params.speedOfLight / (params.centerFreq * 10^9);

end