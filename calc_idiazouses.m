function [U, S, V] = calc_idiazouses(H)
    
    % return [U, S, V] = svd(H);
    % Υπολογισμός ιδιάζουσων τιμών για τον πρώτο πίνακα
    disp("returns --> [U, S, V] = svd(H);")
    disp("NOTE: U is a matrix containing the --left singular vectors-- of H")
    disp("NOTE: S is a diagonal matrix containing the --singular values-- of H")
    disp("NOTE: V is a matrix containing the --right singular vectors-- of H")
    
    [U, S, V] = svd(H);
    S
end
