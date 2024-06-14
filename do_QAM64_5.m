function do_QAM64_5(MAX_SHOWOFF)
    % Η παράμετρος MAX_SHOWOFF είναι για το τέλος που δείχνω κάποια
    % διάγραμματα αστερισμών, όσο τιμή έχει τόσα θα δείξει.

    % Λαμβάνουμε τα κωδικοποιημένα μηνύματα από το 4 ερώτημα τα οποία
    % είναι μηνύματα που είναι κωδικοποιημένα με κώδικα Hamming.
    load('encoded_messages.mat', 'encoded_messages');
    
    num_messages = size(encoded_messages, 1);
    message_length = size(encoded_messages, 2);
    
    % Με την διαμόρφωση 64-QAM έχουμε 6 bits ανα σύμβολο 2^6, οπότε κάθε
    % μήνυμα, το οποίο αποτελείται από 56 bits θα πρέπει να γρουπαριστή σε
    % 6 bits (segments). 56/6 9.33 περίπου 10 σύμβολα.
    % Εγώ τα επεκτείνω σε 60 bits με σκοπό να είναι ίσάξια, κυρίως για το
    % τελευταίο σύμβολο, μην το χάσω.
    num_symbols_per_message = ceil(message_length / 6);
    
    % Αρχικοποιήση πίνακα για τα διαμορφωμένα σύμβολα, θα έιναι μιγαδικοί
    modulated_signals = zeros(num_messages, num_symbols_per_message);
    

    % Τώρα για κάθε μήνυμα, το "προετοιμάζουμε" κατάλληλα και κάνουμε την
    % διαμόεφψση.
    for idx = 1:num_messages
        encoded_message = encoded_messages(idx, :);
    
        padded_message_length = ceil(length(encoded_message) / 6) * 6;
        padded_message = [encoded_message, zeros(1, padded_message_length - length(encoded_message))];

        reshaped_message = reshape(padded_message, [], 6); % Κάθε γραμμή θα είναι ένα 6-bit segment
    
        disp(reshaped_message);

        decimal_message = bi2de(reshaped_message);
        
        % 64-QAM διαμόρφωση
        modulated_signal = qammod(decimal_message, 64, 'UnitAveragePower', true, 'InputType', 'integer');
        
        modulated_signals(idx, :) = modulated_signal;
    end

    
    save('modulated_signals_5.mat', 'modulated_signals');
    if MAX_SHOWOFF <= num_messages
        % Για δοκιμή δείχνουμε κάποιους αστερισμούς κάποιων μηνυμάτων.
        for idx = 1:MAX_SHOWOFF
            scatterplot(modulated_signals(idx,:));
            title(['Constellation Diagram for the ' num2str(idx) 'st. Encoded Message']);
            xlabel('In-phase Component');
            ylabel('Quadrature Component');
        end
    end
end
