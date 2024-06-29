function apply_crc_11d()
    % CRC στην πλευρά του δέκτη.
    
    % Λαμβάνουμε τα απο-κωδικοποιημένα μηνύματα, από apply_hamming_de_coding_11_b(). 
    load('decoded_messages_de_Hamming_11b.mat', 'decoded_messages');
    
    % CRC-24 Πολυώνυμο
    crc24_gen = comm.CRCGenerator('Polynomial', [1 1 0 0 0 0 1 1 0 0 1 0 0 1 1 0 0 1 1 1 1 1 0 1 1]);

    % Προετοιμασία του πίνακα για αποθήκευση των αποτελεσμάτων CRC
    num_messages = size(decoded_messages, 1);

    for i = 1:num_messages
        message = decoded_messages(i, :);
        
        % Το μήνυμα είναι ήδη σε δυαδική μορφή, δεν χρειάζεται μετατροπή
        binary_message = message(:);
        
        % Υπολογισμός του CRC για το τρέχον μήνυμα
        crc = step(crc24_gen, binary_message);
        
        % Αποθήκευση του αποτελέσματος του CRC
        receiver_decoded_CRC(i, :) = crc';
    end
    
    % Το αποτέλεσμα μετα από CRC στο δέκτη
    save('receiver_decoded_CRC_11d.mat', 'receiver_decoded_CRC');
end
