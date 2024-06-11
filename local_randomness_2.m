function local_randomness_2()
    % Φόρτωση των μηνυμάτων απο το προηγούμενο ερώτημα 1
    load('messages_generated_1.mat', 'message_series');
    
    % Αρχικά μηνύματα
    original_messages = {'000', '001', '010', '011', '100', '101', '110', '111'};
    
    %messages_generated = str2double(messages_generated);

    % Δημιουργία νέων μηνυμάτων με τοπική τυχαιότητα
    new_messages = zeros(1, length(message_series)); % Θα είναι 100.000
    for i = 1:length(message_series)
        original_message = dec2bin(message_series(i), 3); % 3-bit μήνυμα, το ότι είναι 3-bit μήνυμα το κατάλαβα από την εκφώνηση
        original_index = find(strcmp(original_messages, original_message));
        
        % Αντιστοίχιση με νέο μήνυμα 6-bit
        % --
        % Σκέφτηκα ότι για κάθε αρχικό μήνυμα 3-bit αντιστοιχίζουμε σε μια
        % ομάδα 8 νέων μηνυμάτων 6-bit.
        % Στην αντιστοίχιση αυτή, κάθε αρχικό μήνημα 3-bit μπορεί να
        % αντιστιχιθεί σε έναν αριθμό από 0 εώς 7. Για να καθορίσω την νέα
        % ομάδα και καλά των νεών μηνυμάτων κάθε αρχικό μήνυμα θα
        % αντιστιχίζεται σε μια ομάδα 8 νέων μηνυμάτων των 6-bit.
        % Για παραπάνω τυχαιότητα επιλέγουμε τυχαία ένα από τα 8 νέα
        % μηνύματα μέσα στην ομάδα αυτή (επιλογή από 0 - 7).
        % -- 
        % ΠΧ --> Το original index για το μήνυμα 000 (original_message) θα βρίσκετα στην θέση 1.
        % ΠΧ --> Το (original_index - 1) * 8 επιλέγει τον πρώτο στην κάθε
        % ομάδα, Για το αρχικό μήνυμα στη θέση 1 έχουμε (1-1) * 8 = 0
        % κτλ...
        new_message_index = (original_index - 1) * 8 + randi(8) - 1; % ξεκινάω από το 0
        % Η τυχαία επιλογή προστίθεται για να πάρουμε το νέο μήνυμα 6-bit.
        new_messages(i) = new_message_index;
        % --
        % Η τυχαία επιλογή μπορούμε να πούμε ότι γίνεται με ομοιόμορφη
        % κατανομή αφού  κάθε αρχικό μήνυμα 3-bit αντιστοιχείται τυχαία 
        % σε ένα από τα 8 νέα μηνύματα 6-bit με ίση πιθανότητα.
    end
    
    % Υπολογισμός κατανομών
    % Με την histcounts καταμετράω πόσες φορές εμφανίζεται κάθε τιμή (0 έως 63) στο σύνολο των νέων μηνυμάτων.
    % Οι συχνότητες τπους διαιρούνται με το συνολικό αριθμό των μηνυμάτων για να πάρω τις πιθανότητες εμφάνισης.
    M = histcounts(new_messages, 0:64) / length(new_messages);
    
    % Υπολογισμός εντροπιών
    entropy_random = -sum(M .* log2(M + eps)); % 2^6 = 64, ένα μήνυμα 6-bit που έχει 64 πιθανά μηνύματα
    entropy_conditional = 3; % Επειδή έχουμε 8 αρχικά μηνύματα log2​(8), για κάθε αρχικό μήνυμα, υπάρχουν 8 δυνατές επιλογές με ίση πιθανότητα.
    
    % Υπολογισμός αμοιβαίας πληροφορίας
    mutual_info = entropy_random - entropy_conditional;
    
    fprintf('Η εντροπία της τυχαιότητας είναι: %.2f bits\n', entropy_random);
    fprintf('Η υπό συνθήκη εντροπία είναι: %.2f bits\n', entropy_conditional);
    fprintf('Η αμοιβαία πληροφορία είναι: %.2f bits\n', mutual_info);
  
    % Τα βάζω και σε Stirng για να φαίνονται καλύτερα
    %messages_generated = string(new_messages);

    %save('new_message_series_string_2.mat', 'messages_generated');
    save('new_message_series_2.mat', 'new_messages');
end
