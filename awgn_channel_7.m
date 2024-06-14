function y = awgn_channel_7(x, SNR_dB)

    % Ισχύς σήματος
    signal_power = mean(abs(x).^2);
    
    % Μετατροπή SNR
    SNR_linear = 10^(SNR_dB / 10);
    
    % πάμε να βρούμε την διασπορά
    % SNR = signal_power / σ =>     
    % σ * SNR = signal_power => 
    % σ = signal_power / SNR
    noise_variance = signal_power / SNR_linear;
    
    % Δημιουργούμε τον θόρυβο
    noise_real = sqrt(noise_variance / 2) * randn(size(x));
    noise_imag = sqrt(noise_variance / 2) * randn(size(x));
    noise = noise_real + 1i * noise_imag;
    
    % Προσθέτουμε τον θόρυβο
    y = x + noise;
end
