clear all;
% Define the set of M values for PAM modulation
M_vals = [4, 16, 64];
% Define the range of SNR values in dB and the number of bits to transmit
SNR_dB_range = 0:1:20; % SNR values in decibels
num_bits = 1000; % Number of bits to transmit

% Initialize a matrix to store BER values for each M
BER_results = zeros(length(M_vals), length(SNR_dB_range));

% Loop over each M value
for idx = 1:length(M_vals)
    M = M_vals(idx);
    % Generate random bits for transmission
    tx_bits = randi([0, M-1], 1, num_bits);
    % Modulate the bits using PAM
    modulated_signal = pammod(tx_bits, M);
    
    % Loop over each SNR value
    for j = 1:length(SNR_dB_range)
        SNR_linear = 10^(SNR_dB_range(j)/10); % Convert SNR from dB to linear scale
        % Transmit the modulated signal through an AWGN channel
        received_signal = awgn(modulated_signal, SNR_linear, 'measured');
        % Demodulate the received signal
        demodulated_bits = pamdemod(received_signal, M);
        % Calculate the Bit Error Rate (BER)
        bit_errors = sum(demodulated_bits ~= tx_bits);
        BER_results(idx, j) = bit_errors / num_bits;
    end
end

% Plot SNR vs. BER for different M values
figure;
semilogy(SNR_dB_range, BER_results(1,:), '-o', 'DisplayName', ['M = ' num2str(M_vals(1))]);
hold on;
semilogy(SNR_dB_range, BER_results(2,:), '-s', 'DisplayName', ['M = ' num2str(M_vals(2))]);
semilogy(SNR_dB_range, BER_results(3,:), '-^', 'DisplayName', ['M = ' num2str(M_vals(3))]);
grid on;
xlabel('Signal to Noise Ratio (SNR) in dB');
ylabel('Bit Error Rate (BER)');
title('BER vs SNR using PAM for Different M Values');
legend('Location', 'best');
hold off;

%Plot the pulse signal before transmission and after demodulation for M = 4
figure;
subplot(2,1,1);
stem(modulated_signal(1:50), 'filled');
title('Modulated Signal (First 50 Samples)');
xlabel('Sample Index');
ylabel('Amplitude');

subplot(2,1,2);
stem(demodulated_bits(1:50),'filled');
title('Demodulated Signal (First 50 Samples)');
xlabel('Sample Index');
ylabel('Amplitude');

%Plot the recieved signal after the AWGN
figure;
stem(received_signal(1:50),'filled');
title('Recieved Signal after AWGN (First 50 Samples)');
xlabel('Sample Index');
ylabel('Amplitude');