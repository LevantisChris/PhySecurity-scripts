function test_new_deHamming()
    %% DE-HAMMING AND CORRECTION
    
    % Παίρνουμε τα μηνύματα μετά την αποδιαμόρφωση 
    load('demodulated_messages_9.mat', 'demodulated_messages');

    num_messages = size(demodulated_messages, 1);

    for idx = 1:num_messages
        received_message = demodulated_messages(idx, :);
        % Κάνουμε Hamming decoding για κάθε 7-bit κομμάτι (Hamming (7,4)).
        % Στην κωδικοποιήση (7, 4) από 4bit λαμβάνουμε 7bit άρα τώρα θα
        % κάνουμε το ανάποδο, NOTE: 7-bit -> 
        % Π3 Π2 Π1 Ε2 Π0 Ε1 Ε0
        % Π3 --> segment(1)
        % Π2 --> segment(2)
        % Π1 --> segment(3)
        % Π0 --> segment(5)
        % E0 --> segment(7)
        % E1 --> segment(6)
        % E2 --> segment(4)
        
        % Τα μηνύματα είναι 58-bits άρα θα έχουμε 58/7 = 8 ζευγαράκια
        for i = 1:8
            % Παίρνουμε το 7-bit μέρος από όλο το μήνυμα που είναι 56-bits
            segment = received_message((i-1)*7 + 1 : i*7);

            % Τώρα πρέπει να υπολογίσουμε το σύνδρομο
            % Z0 = E0 xor Π0 xor Π1 xor Π3
            % Z1 = E1 xor Π0 xor Π2 xor Π3
            % Ζ2 = Ε2 xor Π1 xor Π2 xor Π3
            Z0 = xor( ...
                xor(segment(7), segment(5)), ...
                xor(segment(3), segment(1)));
            Z1 = xor( ...
                xor(segment(6), segment(5)), ...
                xor(segment(2), segment(1)));
            Z2 = xor( ...
                xor(segment(4), segment(3)), ...
                xor(segment(2), segment(1)));
            S = strcat(num2str(Z2), num2str(Z1), num2str(Z0));
            position = bin2dec(S); % Η θέση που το λάθος εντοπίστηκε, αυτό θα διορθώσουμε
            correct_segment = recplaceError(segment, position);
            
            % Τώρα κάνουμε concat ξανά πίσω τα νέα διορθωμένα μηνύματα
            corrected_message((i-1)*7 + 1 : i*7) = correct_segment;
        end
        decoded_messages(idx, :) = corrected_message;
    end
    save('decoded_messages_de_Hamming_11b.mat', 'decoded_messages');
end

function [new_segment] = recplaceError(segment, position)
    if position ~= 0 % Αν έχουμε 0 προφανώς δεν υπάρχει λάθος
        current_bit = segment(8 - position); % Πάρε το τωρινό bit (0 ή 1) που έχει το λάθος. θέλουμε το LSB για αυτό κάνω 7 - ...
        if current_bit == 0
            segment(8 - position) = 1; % Αυτή η γραμμή έχει διορθωθεί από 0 σε 1 με σκοπό να φτιαχτεί το error
        else
            segment(8 - position) = 0; % Αυτή η γραμμή έχει διορθωθεί από 1 σε 0 με σκοπό να φτιαχτεί το error
        end
    end
    new_segment = segment; % νέο "διορθωμένο" segment
end