function estimated_messages = superpositionCoding_10(original_message_length)
    % Load the received superposition coded signals
    load('mapped_messages_Super_6.mat', 'superpositionCoded_signals_transmiter');

    % Load the original modulated signals (for reference constellation)
    load('modulated_signals_5.mat', 'modulated_signals');

    num_messages = size(superpositionCoded_signals_transmiter, 1);
    estimated_messages = zeros(num_messages, original_message_length);

    % Precompute squared Euclidean distances for efficiency
    distances = abs(modulated_signals - superpositionCoded_signals_transmiter).^2;

    for idx = 1:num_messages
        % Find the closest modulated signal (minimum distance)
        [~, closest_index] = min(distances(idx, :));

        % Demodulate the closest signal using 64-QAM
        demodulated_decimal = qamdemod(modulated_signals(closest_index), 64, 'UnitAveragePower', true, 'OutputType', 'integer');

        % Convert the decimal values back to binary
        demodulated_binary = de2bi(demodulated_decimal, 6, 'left-msb');

        % Reshape and truncate the message to original length
        estimated_messages(idx, :) = reshape(demodulated_binary', 1, original_message_length);
    end

    % Αποθήκευση κάθε αποτελέσματος σε νέο .mat file
    save('mapped_messages_Super_10.mat', 'mapped_messages_receiver');

end