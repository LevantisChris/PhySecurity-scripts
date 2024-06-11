function messageSource_1()
    % Δημιουργία μηνυμάτων
    messages = {'000', '001', '010', '011', '100', '101', '110', '111'};
    N = length(messages);
    
    % Υπολογισμός της πιθανότητας και της εντροπίας
    prob = 1 / N;
    entropy = -sum(prob * log2(prob));
    
    fprintf('Η εντροπία της πηγής είναι: %.2f bits\n', entropy);
    
    % Δημιουργία σειράς 100,000 μηνυμάτων
    num_messages = 100000;
    message_series = randi([0, N - 1], 1, num_messages);

    %messages_generated = messages(message_series);
   
    
    %save('messages_generated_1_STRING.mat', 'messages_generated');
    save('messages_generated_1.mat', 'message_series');
end
