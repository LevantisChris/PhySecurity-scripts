function apply_hamming_de_coding_11_b()

    % Παίρνουμε τα μηνύματα μετά την αποδιαμόρφωση 
    load('demodulated_messages_9.mat', 'demodulated_messages');
    
    num_messages = size(demodulated_messages, 1);
    
    for idx = 1:num_messages
        received_message = demodulated_messages(idx, :);
        
        decoded_message = zeros(1, 32);
        
        % Κάνουμε Hamming decoding για κάθε 7-bit κομμάτι (Hamming (7,4)), καθώς έτσι
        % κάναμε και στο αποστελέα
        for i = 1:8
            % Παίρωουμε το κομμάτι
            segment = received_message((i-1)*7 + 1 : i*7);
            
            % Δεν είδα να υπάρχει κάποια έτοιμη συνάρτηση για decoding
            decoded_segment = hamming_decode_7bits(segment);
            
            % αποθηκεύουμε το 4-bit μέρος
            decoded_message((i-1)*4 + 1 : i*4) = decoded_segment;
        end
        
        % Το τελικό μήνυμα θα είναι 32 bit όπως και στην πλευρά του
        % αποστελέα.
        decoded_messages(idx, :) = decoded_message;
    end

    save('decoded_messages_de_Hamming_11b.mat', 'decoded_messages');

end

% Κάνουμε και διόρθωση σφαλμάτων
function decoded_segment = hamming_decode_7bits(segment)
    % Hamming (7,4) decoding
    % parity check matrix για Hamming (7,4)
    H = [1 1 1 0 1 0 0;
         0 1 1 1 0 1 0;
         1 0 1 1 0 0 1];
    
    % syndrome είναι 3-bit διάνυσμα και μας λέει που έχουμε λάθοι 
    syndrome = mod(segment * H.', 2);
    

    % Αν το syndrom είναι non-zero διόρθωσε το λάθος
    error_pos = bi2de(syndrome, 'left-msb') + 1; % + 1 λόγω 0 index
    if error_pos > 0 && error_pos <= 7
        segment(error_pos) = mod(segment(error_pos) + 1, 2);
    end
    
    decoded_segment = segment([3 5 6 7]);
end




