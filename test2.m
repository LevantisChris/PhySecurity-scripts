function y = test2(singal, SNR_dB)
    % Στο κανάλι περνάμε τα μηνύματα που έχουμε διαμορφώσει με 64-QAM στο
    % ερώτημα 5. Αυτά θα πρέπει να αποδιαμορφώση ο δέκτης
    %load('modulated_signals_5.mat', 'modulated_signals');

    x = singal;

    % Ισχύς σήματος
    signal_power = mean(abs(x(:)).^2);
    disp(signal_power)
    
    % Μετατροπή SNR
    SNR_linear = 10^(SNR_dB / 10);
    disp(ceil(SNR_linear)); % ceil γιατί έτσι γίνεται και στις διαφάνειες
    
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
