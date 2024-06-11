function calculate_probabilities_4()
    % Κάνουμε load τις νέες κωδικολέξεις μετά το Hamming code
    load('encoded_messages.mat', 'encoded_messages');
    
    num_messages = size(encoded_messages, 1); 
    encoded_with_probabilities = [encoded_messages, zeros(num_messages, 1)];
    frequency_map = containers.Map('KeyType', 'char', 'ValueType', 'double');
    
    % Εξετάζουμε κάθε μήνυμα με σκοπό να βρούμε τις εμφανίσεις.
    for idx = 1:num_messages
        encoded_message = encoded_messages(idx, :);
        encoded_str = mat2str(encoded_message);
        
        if isKey(frequency_map, encoded_str)
            frequency_map(encoded_str) = frequency_map(encoded_str) + 1;
        else
            frequency_map(encoded_str) = 1;
        end
    end
    
    % Μετατροπή σε πιθανότητες
    for idx = 1:num_messages
        encoded_message = encoded_messages(idx, :);
        encoded_str = mat2str(encoded_message);
        probability = frequency_map(encoded_str) / num_messages;
        encoded_with_probabilities(idx, end) = probability;
    end
    
    %% Plot
    figure;
    bar(1:num_messages, encoded_with_probabilities(:, end));
    xlabel('Encoded Message Index');
    ylabel('Probability');
    title('Probability of Encoded Messages');
    xlim([0, num_messages+1]); % Set x-axis limits
    
    
    saveas(gcf, 'encoded_messages_probabilities_plot.png');
    save('encoded_with_probabilities.mat', 'encoded_with_probabilities');
    save('probability_map.mat', 'frequency_map');
end
