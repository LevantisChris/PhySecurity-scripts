function calc_beamforming_x(Hm)
    %% Υπολογισμός των νέων ισχύων: 
    % Παίρνουμε τις διαστάσεις του για να ξέρουμε πόσα σήματα θα στείλουμε.
    [M, N] = size(Hm); 

    P_each = 1/M; % Επίσης σε κάθε σήμα κατανέμεται ίση ισχύς, P = 1/3.

    Hm_ctranspose = ctranspose(Hm);

    P_all = [];
    % για κάθε ισχύ
    for signal_id = 1:M
        sum = (Hm_ctranspose(signal_id, 1));
        % για κάθε σήμα
        for idx = 2:M
            section = (Hm_ctranspose(signal_id, idx));
            sum = sum + section;
        end
        P_new = (abs(sum)^2) * P_each;
        
        %disp(Hm_ctranspose(signal_id, :));
        %disp(P_new)
        %disp("------------------------------")
        P_all(signal_id, :) = P_new;
    end
 
    %% Υπολογίζουμε την μέγιστη ισχύ
    disp("----------------------------------")
    disp("Power for each signal:")
    disp(P_all);
    
    [M, ~] = size(P_all);
    sum = 0;
    for signal_id = 1:M
        sum = sum + P_all(signal_id, 1);
    end
    disp("------------------------------")
    disp("The total power is:")
    disp(sum);

    %% Υπολογισμός x για όλα τα μηνύματα του ερωτήματος 6
    load('mapped_messages_Super_6.mat', 'superpositionCoded_signals_transmiter');
    
    Hm_ctranspose = ctranspose(Hm);

    num_messages = size(superpositionCoded_signals_transmiter, 1);
    for i = 1:num_messages
        message = superpositionCoded_signals_transmiter(i, :);

        x = (1/sqrt(sum)) * Hm_ctranspose * build_message_array(message, Hm);
        
        x_messages(i, :) = x;
    end
    save('x_messages_18.mat', 'x_messages');
end

function [message_array] = build_message_array(message, Hm)
    [rows, ~] = size(Hm);
    message_array = zeros(rows, length(message));
    for i = 1:rows
        message_array(i, :) = message;
    end
end