function [temp1, temp2, x] = calc_beamforming_only_BOB(Hm, typeOfSignal, message)

    % FOR BOBBB (Hm)

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
    
    %% Αποστολή/λήψη σημάτων 
    % Τώρα ανάλογα με το αν το σήμα στέλνεται ή λαμβάνεται έχουμε
    % διαφορετική λειτουργικότητα, δηλαδή διαφορετικό τύπο (με βάση 
    % το pdf Exercise-ArtNoise-new.pdf σελ 25 και 26 )
    if(typeOfSignal == "sender")
        disp("--sender-functionality--")
        % Τύπος σελίδα 25
        % Ο τύπος αφορά την αποστολή μηνύματος
        
        temp1 = (1/sqrt(sum)) * Hm_ctranspose * Hm; % 1/sqrt(...) * Hm^H * Hm, το έβαλα ξεχωριστά για ο ερώτημα 17
        disp("--> (temp1) 1/sqrt(...) * Hm^H * Hm");
        disp(temp1);
        
        temp2 = (1/sqrt(sum)) * Hm_ctranspose; % 1/sqrt(...) * Hm^H
        disp("--> (temp2) 1/sqrt(...) * Hm^H");
        disp(temp2);

        x = (1/sqrt(sum)) * Hm_ctranspose * build_message_array(message, Hm);
        disp("--> Sended message");
        disp(x);
    else if(typeOfSignal == "receiver")
        disp("--receiver-functionality--")
        % Τύπος σελίδα 26
        % Ο τύπος αφορά την λήψη μηνύματος
        n = rand(M, 4); % Δημιουργία θορύβου
        temp1 = (1/sqrt(sum)) * Hm * Hm_ctranspose; % 1/sqrt(...) * Hm * Hm^H, το έβαλα ξεχωριστά για ο ερώτημα 17
        disp("--> 1/sqrt(...) * Hm * Hm^H");
        disp(temp1);
        y = (temp1 * build_message_array(message, Hm)) + n; 
        disp("--> Receiver message");
        disp(y);
    end
    end
end
%% Στον τύπο σελίδα 25 φαίνεται ο πίνακας του μηνύματος να έχει 
% ίδιες διαστάσεις με τον Hm άρα θα πρέπει να φτιάξουμε έναν πίνακα 
% που θα έχει ίδιες γραμμές με τον Hm αλλά θα έχει σε κάθε γραμμή το μήνυμα
% message (και φυσικά σε κάθε στήλη)
function [message_array] = build_message_array(message, Hm)
    [rows, ~] = size(Hm);
    message_array = zeros(rows, length(message));
    for i = 1:rows
        message_array(i, :) = message;
    end
end

