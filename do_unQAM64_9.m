function do_unQAM64_9(original_message_length)
    % Παίρνουμε τα λαμβανόμενα μηνύματα από το Gaussian κανάλι
    load('received_signals_7.mat', 'y');

    received_signals = y;

    num_messages = size(received_signals, 1);
    
    demodulated_messages = zeros(num_messages, original_message_length);

    for idx = 1:num_messages
        received_signal = received_signals(idx, :);
        
        % 64-QAM demodulation
        demodulated_decimal = qamdemod(received_signal, 64, 'UnitAveragePower', true, 'OutputType', 'integer');
        
        demodulated_binary = de2bi(demodulated_decimal, 6, 'left-msb');
        
        demodulated_message = reshape(demodulated_binary', 1, []);
        
        demodulated_messages(idx, :) = demodulated_message(1:original_message_length);
    end
    
    save('demodulated_messages_9.mat', 'demodulated_messages');
end
