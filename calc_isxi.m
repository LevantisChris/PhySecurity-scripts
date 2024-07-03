function [P] = calc_isxi(A, P_original) 
    P = (abs(A)^2) * P_original / 3;
    
    disp("abs(A)^2")
    disp(abs(A)^2)
end
