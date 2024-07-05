function calc_beamforming_y_eve(He)
%% Υπολογισμός των νέων ισχύων: 
    % Παίρνουμε τις διαστάσεις του για να ξέρουμε πόσα σήματα θα στείλουμε.
    [M, N] = size(He);

    P_each = 1/M; % Επίσης σε κάθε σήμα κατανέμεται ίση ισχύς, P = 1/3.

    Hm_ctranspose = ctranspose(He);

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

    %% Υπολογισμός y (EVE) για όλα τα μηνύματα x
    load('x_messages_18.mat', 'x_messages');
    
    Hm_ctranspose = ctranspose(He);

    num_messages = size(x_messages, 1);
    for i = 1:num_messages
        message = x_messages(i, :);
        n = rand(M, 3); % Δημιουργία θορύβου
        y = He * build_message_array(message, He) + n;
        
        y_eve_messages{i} = y; % y_bob_messages είναι ένα cell array
    end
    save('y_eve_messages_18.mat', 'y_eve_messages');
end

function [message_array] = build_message_array(message, Hm)
    [rows, ~] = size(Hm);
    message_array = zeros(rows, length(message));
    for i = 1:rows
        message_array(i, :) = message;
    end
end