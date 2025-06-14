function apply_hamming_coding_4()
    % Παίρνουμε τα νέα μηνύματα μετά το CRC
    load('new_data_3.mat', 'new_data');
    
    num_messages = size(new_data, 1); % Θα είναι 100.000
    
    % Πίνακα που θα κρατά τα μηνύματα μετά το Hamming
    encoded_messages = zeros(num_messages, 56);
    
    for idx = 1:num_messages
        message = new_data(idx, :);
        
        % ΠΡΟΣΟΧΗ --> Στην εκφώνηση ζητά να γίνει κωδικοποιήση σε 24 bits
        % έγω στο προηγούμενο ερώτημα έβγαλα τα μηνύματα σε 32 bits.
        assert(length(message) == 32, 'Message length must be 32 bits.');
        
        % Καλούμε την παρακάτω συνάρτηση που κάνει Hamming encoding
        encodedMessage = hamming_encode_32bits(message);
        
        encoded_messages(idx, :) = encodedMessage;
    end

    % Αποθήκευση κάθε αποτελέσματος σε νέο .mat file
    save('encoded_messages.mat', 'encoded_messages');
end

function encodedMessage = hamming_encode_32bits(message)
    encodedMessage = zeros(1, 56); % 8 segments των 7 bits

    % Προσοχή -->
    % Κάθε 4-bit θα κωδικοποιηθεί σε 7-bit κωδικολέξη.
    % Οπότε έχουμε μηνύματα με μέγεθος 32-bit άρα 32/4 = 8bit
    % Τελικά θα έχουμε 8 * 7 = 56 bit.
    for i = 0:7
        % Παίρνουμε το 4-bit μέρος από όλο το μήνυμα που είναι 32-bits 
        segment = message(4*i+1:4*i+4);
        segment = flip(segment); % Το κάνουμε flip γιατί --> Π3Π2Π1Π0

        %fprintf('block: %d\n', message(4*i+1:4*i+4));
        
        % Υπολογίζουμε τα parity bits με βάση τους τύπους από την διαφάνεια
        % στο eclass, --> Ε0 Ε1 Ε2
        E0 = xor(xor(segment(1), segment(2)), segment(4)); % Π0 xor Π1 xor Π3
        %fprintf('E0: %d\n', segment(4));
        E1 = xor(xor(segment(1), segment(3)), segment(4)); % Π0 xor Π2 xor Π3
        %fprintf('E1: %d\n', E1);
        E2 = xor(xor(segment(2), segment(3)), segment(4)); % Π1 xor Π2 xor Π3
        %fprintf('E2: %d\n', E2);
        
        % Π3 Π2 Π1 Ε2 Π0 Ε1 Ε0
        encodedSegment = [segment(4) segment(3) segment(2) E2 segment(1) E1 E0];
        %fprintf('encodedSegment: %d\n', encodedSegment);
        
        % Store the encoded segment
        encodedMessage(7*i+1:7*i+7) = encodedSegment;
    end
end

