function superpositionCoding_6()
    % Παίρνουμε από προηγούμενο ερώτημα τα διαμορφποιημένα μηνύματα που
    % είναι σε μιγαδική μορφή
    load('modulated_signals_5.mat', 'modulated_signals');
    
    % Ορίζουμε πίνακα 8χ8 λόγω 64-QAM ο οποίος θα ορίζει τα σημεία του
    % αστερισμού με τα οποία θα γίνει αντιστοίχηση σε τέσσερα σύνολα.
    % Γενικά δεν ήμουν σίγουρος άν έπρεπε να ορίσω μόνο 4 σύνολα αλλά
    % υπέθεσα ότι αυτό πρέπει. Πάντως κάθε γραμμή αντικατοπτρίζει
    % συγκεκριμένο έυρος πραγματικών και κάθε στήλη συγκεκριμένο ευρος
    % φανταστικού μέρος των μιγαδικών.
    % Παρακάτω κίολας βρίσκω το πραγματικό και το φανταστικό μέρος του κάθε
    % μιγαδικού
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
    
    % Ορίζουμε τα πραγματικά και τα φανταστικά μέροι, το έυρος τους
    real_range = linspace(-7, 7, 8);
    imag_range = linspace(-7, 7, 8);
    
    % Map κάθε μήνυμα
    map_to_subset = @(msg) arrayfun(@(x) ...
        constellation_points(find(real_range >= real(x), 1), find(imag_range >= imag(x), 1)), msg);
    
    num_messages = size(modulated_signals, 1);
    mapped_messages = zeros(num_messages, size(modulated_signals, 2));
    
    for i = 1:num_messages
        mapped_messages(i, :) = map_to_subset(modulated_signals(i, :));
    end
    
    % Δείχνω τα 10 πρώτα
    disp(mapped_messages(1:10, :));

    % Αποθήκευση κάθε αποτελέσματος σε νέο .mat file
    save('mapped_messages_Super_6.mat', 'mapped_messages');

end