
load('modulated_signals_5.mat', 'modulated_signals');
test_awgn = awgn(modulated_signals,1);
save('received_signals_7.mat', 'y');