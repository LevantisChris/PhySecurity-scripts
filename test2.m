function test2()
    % Load received data (assuming decoded_messages contains the 32-bit messages)
    load('decoded_messages_de_Hamming_11b.mat', 'decoded_messages'); % size 100000x32 each row has a message in 0 and 1

    % CRC-24 polynomial configuration
    crc_poly = [1 1 0 0 0 0 1 1 0 0 1 0 0 1 1 0 0 1 1 1 1 1 0 1 1];
    crc24_det = comm.CRCDetector('Polynomial', crc_poly);
    crc_length = numel(crc_poly) - 1;  % Length of CRC in bits
    
    % Initialize variables to store results
    num_messages = size(decoded_messages, 1);
    errors_detected = zeros(num_messages, 1);  % 1 if error detected, 0 otherwise
    
    for i = 1:num_messages
        % Extract the 32-bit message (8-bit original + 24-bit CRC)
        received_message_crc = decoded_messages(i, :);
        
        % Split into original message (first 8 bits) and CRC (last 24 bits)
        received_original = received_message_crc(1:6);
        received_crc = received_message_crc(7:end);
        
        expanded_bits = [received_original, zeros(1, 19)];
        disp(expanded_bits);
        
        % Pad the original message to match CRC polynomial degree (24 bits)
        %padded_original = [expanded_bits, zeros(1, crc_length)];
        
        % Compute CRC for the padded 24-bit message
        computed_crc = step(crc24_det, expanded_bits');
        
        % Compare computed CRC with received CRC
        if isequal(computed_crc, received_crc')
            % No error detected
            fprintf('Message %d: No error detected.\n', i);
        else
            % Error detected
            fprintf('Message %d: Error detected!\n', i);
            errors_detected(i) = 1;
        end
    end
    
    % Count total errors detected
    total_errors = sum(errors_detected);
    fprintf('Total errors detected: %d\n', total_errors);
end
