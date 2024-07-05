%% Δημιουργία θορύβου
% Ο θόρυβος σχετικά με την λήψη θα πρέπει να είναι τυχαίος
function [noise_array] = test2(rows, cols)
    % Generate a random noise array with the specified dimensions
    noise_array = rand(rows, cols);
    disp(noise_array);
end
