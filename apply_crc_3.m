function apply_crc_3()

    % Φ�?�?τωση των δεδομένων απ�? 2ο ε�?�?τημα
    load('new_message_series_2.mat', 'new_messages');
    
    % Υλοποίηση του CRC-24
    crc24_gen = comm.CRCGenerator('Polynomial',[1 1 0 0 0 0 1 1 0 0 1 0 0 1 1 0 0 1 1 1 1 1 0 1 1]); % �?�?ισμ�?ς του CRC-24 generator

     for i = 1:size(new_messages, 2)
         % NOTE --> Τα μηνυματα είναι σε ακέ�?αια μο�?φή στον πίνακα
         % new_messages, οπο�?τε θα π�?έπει και να μετατ�?απο�?ν σε binary
         % μο�?φή. Π�?οσπάθησα να τα βάλω αυτο�?σια, αλλά δεν δο�?λευε η
         % CRCGenerator σωστά.
        % Παί�?νουμε το i-th μ�?νημα
        message = new_messages(:, i);
        
        % �?ετατ�?οπή σε κατάλληλη δυαδική μο�?φή
        binary_message = double(dec2bin(message, 8)) - 48;
        
        % Β�?ίσκουμε το CRC checksum
        crc = step(crc24_gen, binary_message');
        
        %% ΠΡ�?Σ�?ΧΗ!!!!!! 
        % --> Τ�?�?α θα πά�?ω πίνακα με διαστάσεις 100000x32, οποίος έχει σε
        % binary μο�?φή τα α�?χικά μηνυματα μαζί με τα CRC τους. Δηλαδή δεν
        % θα είμαστε σε integer μο�?φή �?πως π�?ιν αλλά θα έχουμε σε κάθε
        % γ�?αμμή κανονικά τα μην�?ματα σε σωστή μο�?φή με το CRC τους. Για
        % κάποιο λ�?γο μου τα έβαζε σε 32-bit, αλλά δεν μας πει�?άζει αυτή
        % την στιγμή πα�?αμ�?νο να είναι σωστά υπολογισμένα τα τελικά
        % μην�?ματα που ειναι καθ�?ς το εξέτασα και χει�?οκίνητα με το
        % ε�?γαλείο https://asecuritysite.com/comms/crc_div
        % 
        new_data(i, :) = [crc'];
    end
    
    % Αποθήκευση των νέων μηνυμάτων σε ένα νέο α�?χείο .mat
    save('new_data_3.mat', 'new_data');

end

function [binary_messages_numeric] = convert_to_ASCII_0_1(new_messages)
    binary_messages = dec2bin(new_messages, 8);
    binary_messages_numeric = double(binary_messages) - 48; % Convert ASCII '0' and '1' to numeric 0 and 1
end
