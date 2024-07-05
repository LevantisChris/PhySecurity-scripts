function [P] = calc_isxi(A, P_original, num_of_towers) 
    P = (abs(A)^2) * P_original / num_of_towers;
    
    %disp("abs(A)^2")
    %disp(abs(A)^2)
end
