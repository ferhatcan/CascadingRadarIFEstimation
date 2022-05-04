function [time_signal_all, d_td] = simulate_radar(params, target_position, noise, mismatch)
if nargin < 3
   noise.sigma = 0;
   noise.mean = 0;
   mismatch_exist = false;
elseif nargin < 4   
   mismatch_exist = false;
else 
   mismatch_exist = true;
end


time_signal_all = zeros(params.nchirp_loops, params.numADCSample, params.numRxAnt, params.numTxAnt);

current_time = 0;

d_td = zeros(params.nchirp_loops, params.numRxAnt, params.numTxAnt);

for chirp = 1:params.nchirp_loops
    for tx = 1:params.numTxAnt
        tx_dist = sqrt(sum((target_position - params.Tx_positions(:, tx)).^2));
        t = current_time:1/params.adcSampleRate:current_time+params.chirpRampTime;
        t = t(1:end-1);
        for rx = 1:params.numRxAnt
            rx_dist = sqrt(sum((target_position - params.Rx_positions(:, rx)).^2));
            total_dist = tx_dist + rx_dist;
            td = total_dist / params.speedOfLight;
            d_td(chirp, rx, tx) = td;
            if mismatch_exist
                mixed_signal = antenna_model(params, t, tx_dist, rx_dist, 1, 1, mismatch{tx, rx});
            else
                mixed_signal = antenna_model(params, t, tx_dist, rx_dist, 1, 1);
            end
%             sigma = std(mixed_signal);
            additive_noise = normrnd(noise.mean, noise.sigma, size(mixed_signal));
            time_signal_all(chirp, :, rx, tx) = mixed_signal + additive_noise;
        end
    end
end

end