function do_unQAM64_9(original_message_length)
    % Load the received modulated signals after passing through the AWGN channel
    load('received_signals_7.mat', 'y');

    received_signals = y;

    num_messages = size(received_signals, 1);
    num_symbols_per_message = size(received_signals, 2);
    
    % Initialize a matrix to store the demodulated messages
    demodulated_messages = zeros(num_messages, original_message_length);

    for idx = 1:num_messages
        received_signal = received_signals(idx, :);
        
        % 64-QAM demodulation
        demodulated_decimal = qamdemod(received_signal, 64, 'UnitAveragePower', true, 'OutputType', 'integer');
        
        % Convert the decimal values back to binary
        demodulated_binary = de2bi(demodulated_decimal, 6, 'left-msb');  % 'left-msb' ensures the correct bit order
        
        % Reshape the binary matrix back to a single bitstream
        demodulated_message = reshape(demodulated_binary', 1, []);
        
        % Store the demodulated message, truncated to the original message length
        demodulated_messages(idx, :) = demodulated_message(1:original_message_length);
    end
    
    % Save the demodulated messages (optional)
    save('demodulated_messages_9.mat', 'demodulated_messages');
end
