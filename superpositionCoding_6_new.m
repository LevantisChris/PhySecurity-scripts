function encoded_messages = superpositionCoding_6_new()
    
    % Παίρνουμε από προηγούμενο ερώτημα τα διαμορφποιημένα μηνύματα που
    % είναι σε μιγαδική μορφή αλλά και τα μηνλυματα μετά από το Hamming
    % κωδικοποιήση, δηλαδή πριν από την διαμόρφωση.
    load('encoded_messages.mat', 'encoded_messages');
    load('modulated_signals_5.mat', 'modulated_signals');

    input_messages = encoded_messages;
    
    % Ορίζουμε πίνακα 8χ8 λόγω 64-QAM ο οποίος θα ορίζει τα σημεία του
    % αστερισμού με τα οποία θα γίνει αντιστοίχηση σε τέσσερα σύνολα.
    % Γενικά δεν ήμουν σίγουρος άν έπρεπε να ορίσω μόνο 4 σύνολα αλλά
    % υπέθεσα ότι αυτό πρέπει.
    constellation_points = [
        1, 2, 3, 4, 1, 2, 3, 4;
        1, 2, 3, 4, 1, 2, 3, 4;
        1, 2, 3, 4, 1, 2, 3, 4;
        1, 2, 3, 4, 1, 2, 3, 4;
        1, 2, 3, 4, 1, 2, 3, 4;
        1, 2, 3, 4, 1, 2, 3, 4;
        1, 2, 3, 4, 1, 2, 3, 4;
        1, 2, 3, 4, 1, 2, 3, 4;
    ];

    % Διαχωρίζουμε πραγματικό από φανταστικό μέρος
    real_parts = real(modulated_signals);
    imag_parts = imag(modulated_signals);

    % Τα βάζουμε σε ζευγαράκια
    message_pairs = reshape(input_messages', 2, [])';

    % είναι σε δυαδική τα μετατρέπουμε
    decimal_indices = bi2de(message_pairs) + 1;

    superpositionCoded_signals_transmiter = zeros(size(input_messages, 1), 1);

    % Θα πάμε σε κάθε μήνυμα και τα κάνουμε superposition coding
    for i = 1:size(input_messages, 1)
        % Παρωουμε την αντίστιχη τιμή από τον πίνακα constellation_points
        % και το αντιστοιχουμε
        subset_indices = find(constellation_points == decimal_indices(i));

        % Σημαντικό είναι ότι μη ντεντερμινιστικά επιλέγουμε το σημείο
        selected_point_index = subset_indices(randi(length(subset_indices)));

        selected_real = real_parts(selected_point_index);
        selected_imag = imag_parts(selected_point_index);

        % Στο τέλος δημιουργοέυμε τον μιγαδικό
        superpositionCoded_signals_transmiter(i) = complex(selected_real, selected_imag);
    end

    save('mapped_messages_Super_6.mat', 'superpositionCoded_signals_transmiter');
end