% Example input signal (complex)
x = randn(1, 100) + 1i * randn(1, 100);

% Desired SNR in dB
SNR_dB = 20;

% Pass the signal through the AWGN channel
y = awgn_channel_7(x, SNR_dB);

% Plot the original and noisy signals (optional)
figure;
subplot(2, 1, 1);
plot(real(x), 'b');
hold on;
plot(real(y), 'r');
title('Real Part: Original (Blue) and Noisy (Red)');

subplot(2, 1, 2);
plot(imag(x), 'b');
hold on;
plot(imag(y), 'r');
title('Imaginary Part: Original (Blue) and Noisy (Red)');
