function Rm = calc_R_rythmos_metadosis(H, Kx, s_2)
    % Identity matrix
    I2 = eye(size(H, 1));

    % Noise variance
    sigma_m_squared = s_2;
    
    % Calculation
    Rm = log2(det(I2 + (1/sigma_m_squared) * H * Kx ));
    disp("Rythmos:")
    disp(Rm);
end
