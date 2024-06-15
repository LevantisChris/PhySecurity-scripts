function y = awgn_channel_7(SNR_dB)

    % Στο κανάλι περνάμε τα μηνύματα που έχουμε διαμορφώση με 64-QAM στο
    % ερώτημα 5. Αυτά θα πρέπει να αποδιαμορφώση ο δέκτης
    load('modulated_signals_5.mat', 'modulated_signals');

    x = modulated_signals;

    % Ισχύς σήματος
    signal_power = mean(abs(x(:)).^2);
    
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

    save('received_signals_7.mat', 'y');
end
