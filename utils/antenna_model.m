function mixed_signal = antenna_model(params, t, tx_dist, rx_dist, A, B, mismatch)
%% Antenna Model 
if nargin < 6
   mismatch.tx_gain = 1;
   mismatch.tx_phase = 0;
   mismatch.rx_gain = 1;
   mismatch.rx_phase = 0;
end

total_dist = tx_dist + rx_dist;
td = total_dist / params.speedOfLight;

int_phase = @(t) 2*pi*(params.centerFreq * t + params.alpha * ((t.^2)/2));

x_tx = @(t, A, phase_mismatch) A * cos(int_phase(t) + phase_mismatch);
x_tx_shift = @(t, A, phase_mismatch) A * sin(int_phase(t) + phase_mismatch);

x_rx = @(t, td, B, phase_mismatch) B * cos(int_phase(t-td) + phase_mismatch);

tx_power = 1;
RCS = 1;
wl = 200;
attn = RCS * wl^2 / (4*pi*(4*pi*rx_dist*tx_dist)^2);
signal_power = sqrt(tx_power*attn*50);

% mixed_signal = 1 * signal_power * (...
%     x_tx(t, A*mismatch.tx_gain, mismatch.tx_phase)...
%     .* x_rx(t, td, B*mismatch.rx_gain, mismatch.rx_phase)...
%     + 1i * ...
%     x_tx_shift(t, A*mismatch.tx_gain, mismatch.tx_phase)...
%     .* x_rx(t, td, B*mismatch.rx_gain, mismatch.rx_phase) );


mixed_signal = 1 * signal_power *(A*mismatch.tx_gain*B*mismatch.rx_gain/2)*(cos(int_phase(t) - int_phase(t-td)) + i*sin(int_phase(t) - int_phase(t-td)));

end