function all_mismatches = generate_mismatch(params, coeff_gain, coeff_phase)
all_mismatches = cell(0);
tx_mismatches = zeros(2, params.numTxAnt);
rx_mismatches = zeros(2, params.numRxAnt);

% coeff_gain = 0.0; % approximately +-5dB = 0.60
% coeff_phase = 0.0; % +-4.5 degrees = 0.05

for tx=1:params.numTxAnt
    tx_mismatches(1, tx) = 1; % 1 - coeff_gain * (randn(1) - 0.5);
    tx_mismatches(2, tx) = 0; % deg2rad(coeff * (randn(1) - 0.5) * 180);
end

for rx=1:params.numRxAnt
    rx_mismatches(1, rx) = 1 - coeff_gain * (randn(1) - 0.5);
    rx_mismatches(2, rx) = deg2rad(coeff_phase * (randn(1) - 0.5) * 180);
end
    
for tx=1:params.numTxAnt
    for rx=1:params.numRxAnt
        mismatch.tx_gain = tx_mismatches(1, tx);
        mismatch.tx_phase = tx_mismatches(2, tx);
        mismatch.rx_gain = rx_mismatches(1, rx);
        mismatch.rx_phase = rx_mismatches(2, rx);
        all_mismatches(tx, rx) = {mismatch};
    end
end

end