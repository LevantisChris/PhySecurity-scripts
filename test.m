function test(received_message)
    
    %load('decoded_messages_de_Hamming_11b.mat', 'decoded_messages');
    
    %received_message = demodulated_messages(idx, :);
    for i = 1:8
        seven_bit_segment = received_message((i-1)*7 + 1 : i*7); % 7-bit segment
        final_segment = remove_parity_bits(seven_bit_segment); % Καλούμε την συνάρτηση
        final_segments((i-1)*4 + 1 : i*4) = final_segment; % Τώρα θα είναι 4-bit (7 - 3)
    end
    unRedundancy_messages(1, :) = final_segments;
    disp(unRedundancy_messages);
end

function seven_bit_segment = remove_parity_bits(seven_bit_segment)
    %             Π3 Π2 Π1 'Ε2' Π0 'Ε1' 'Ε0' --> 7 - 3 = 4-bit
    % example:    1  1  0   0   1   1    0 --> 1 1 0 1
    seven_bit_segment([7, 6, 4]) = [];
    disp(seven_bit_segment);
end