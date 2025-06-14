function [temp1, y] = calc_beamforming_only_EVE(He, x_bob, temp_bob)

% FOR EVEEEE (He)

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
    
    %% Αποστολή/λήψη σημάτων EVEE!!!!
    disp("--receiver-functionality--")
    % Τύπος σελίδα 26
    % Ο τύπος αφορά την λήψη μηνύματος, EVE
    n = rand(M, 4); % Δημιουργία θορύβου

    temp1 = He * temp_bob; % 1/sqrt(...) * Hm * Hm^H, το έβαλα ξεχωριστά για ο ερώτημα 17
    disp("--> (temp1) 1/sqrt(...) * Hm^H * He ");
    disp(temp1);
    
    y = He * x_bob + n; 
    disp("--> Receiver message");
    disp(y);
end