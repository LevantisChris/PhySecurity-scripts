function test(SNR)
    load('modulated_signals_5.mat', 'modulated_signals');
    y = awgn(modulated_signals,SNR);
    save('received_signals_7.mat', 'y');
end