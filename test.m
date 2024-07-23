% Simulate a Digital Channel with 2-level PAM

% Parameters
M = 2;              % Number of PAM levels (2 for 2-level PAM)
bitsPerSymbol = 1;  % Number of bits per symbol
SNR_dB = -10:1:20;  % Range of SNR values in dB

% Create a PAM modulator and demodulator
pamModulator = comm.PAMModulator(M, 'SymbolMapping', 'Gray', 'NormalizationMethod', 'Average Power');
pamDemodulator = comm.PAMDemodulator(M, 'SymbolMapping', 'Gray', 'NormalizationMethod', 'Average Power');

% BER calculation loop
ber = zeros(size(SNR_dB));
for idx = 1:length(SNR_dB)
    % Generate random data
    data = randi([0, 1], 5, bitsPerSymbol);
    
    % Modulate the data
    modulatedSignal = pamModulator(data);
    
    % Add AWGN to the signal
    receivedSignal = awgn(modulatedSignal, SNR_dB(idx), 'measured');

    % Matched Filter
    matchedFilter = conj(flipud(modulatedSignal));
    filteredSignal = conv(receivedSignal, matchedFilter, 'same');

    % Demodulate the received signal
    demodulatedData = pamDemodulator(filteredSignal);
    
    % Calculate BER
    ber(idx) = biterr(data, demodulatedData) / (length(data) * bitsPerSymbol);
  
end

% Plot the signals
figure;
subplot(4,1,1);
stem(modulatedSignal, 'Marker', 'none');
title('Input Signal');

subplot(4,1,2);
stem(receivedSignal, 'Marker', 'none');
title('Received Signal with Noise');

subplot(4,1,3);
stem(filteredSignal, 'Marker', 'none');
title('Filtered Signal');

subplot(4,1,4);
stem(demodulatedData, 'Marker', 'none');
title('Demodulated Signal');

% Plot BER vs SNR
figure;
semilogy(SNR_dB, ber, 'o-');
grid on;
xlabel('Signal-to-Noise Ratio (SNR) [dB]');
ylabel('Bit Error Rate (BER)');
title('BER vs SNR for 2-level PAM');
