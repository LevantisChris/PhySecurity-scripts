function test2(Hm)
        
    % MRC: 
    % Παίρνουμε τις διαστάσεις του για να ξέρουμε πόσα σήματα θα στείλουμε.
    [M, ~] = size(Hm); 

    P_each = 1/M; % Επίσης σε κάθε σήμα κατανέμεται ίση ισχύς, P = 1/2.

    Hm_ctranspose = ctranspose(Hm);

    P_all = [];
    for signal_id = 1:M
        sum = (Hm_ctranspose(signal_id, 1)) ...
            + (Hm_ctranspose(signal_id, 2));

        P_new = (abs(sum)^2) * P_each;
        
        %disp(Hm_ctranspose(signal_id, :));
        %disp(P_new)
        %disp("------------------------------")
        P_all(signal_id, :) = P_new;
    end
    disp("----------------------------------")
    disp(P_all);

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
end