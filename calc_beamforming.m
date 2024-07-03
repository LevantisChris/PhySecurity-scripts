function calc_beamforming(Hm)
        
    % MRC: 
    % Παίρνουμε τις διαστάσεις του για να ξέρουμε πόσα σήματα θα στείλουμε.
    [M, N] = size(Hm); 

    P = 1/M; % Επίσης σε κάθε σήμα κατανέμεται ίση ισχύς, P = 1/3.
    
    Hm = ctranspose(Hm);

    P_all = [];
    for signal_id = 1:M
        P = abs( Hm(signal_id, 1) ...
            + Hm(signal_id, 2) ...
            + Hm(signal_id, 3) ...
            )^2 * P;
        disp(Hm(signal_id, :));
        disp(P)
        disp("------------------------------")
        P_all(signal_id, :) = P;
    end
    disp("----------------------------------")
    disp(P_all);
end