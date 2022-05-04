function  [params_out] = set_antenna_position(params)
Tx_positions = zeros(3, params.numTxAnt);
Rx_positions = zeros(3, params.numRxAnt);

tx_mid_x = params.TI_Cascade_TX_position_azi(end) / 2;
rx_mid_x = params.TI_Cascade_RX_position_azi(end) / 2;
% tx_mid_x = 0;
% rx_mid_x = 0;

antenna_distance = params.d_optimal * (params.speedOfLight / params.centerFreq);

ti_tx_normalized_x = (params.TI_Cascade_TX_position_azi - tx_mid_x) * antenna_distance;
ti_rx_normalized_x = (params.TI_Cascade_RX_position_azi - rx_mid_x) * antenna_distance;

tx_y = -2 * antenna_distance;
rx_y = 2 * antenna_distance;

for tx = 1:params.numTxAnt
    Tx_positions(:, tx) = [ti_tx_normalized_x(tx) tx_y 0];
end

for rx = 1:params.numRxAnt
    Rx_positions(:, rx) = [ti_rx_normalized_x(rx) rx_y 0];
end

params.virtual_antennas = [];

for tx = 1:params.numTxAnt
    params.virtual_antennas = cat(2, params.virtual_antennas, params.TI_Cascade_TX_position_azi(tx) + params.TI_Cascade_RX_position_azi);
end

[val, ID_unique] = unique(params.virtual_antennas);
params.antenna_azimuthonly = ID_unique; 

params.Tx_positions = Tx_positions;
params.Rx_positions = Rx_positions;
params_out = params;

end