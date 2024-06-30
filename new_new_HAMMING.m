function encoded_messages_new =  new_new_HAMMING()

    load('new_data_3.mat', 'new_data');

    numMessages = numel(new_data); % Number of messages in the cell array
    
    encoded_messages_new = cell(1, numMessages); % Initialize cell array to store encoded messages
    
    n = 7; % Total length of codeword
    k = 4; % Length of original message


    for i = 1:numMessages
        message = new_data{i}; % Get the current message
    
        % Calculate number of 4-bit segments in the message
        num_segments = ceil(length(message) / k);
    
        % Initialize array to store encoded bits
        encoded_bits = [];
    
        % Encode each 4-bit segment using Hamming code
        for j = 1:num_segments
            % Extract 4-bit segment (or less if it's the last segment)
            segment = message((j-1)*k + 1 : min(j*k, length(message)));
    
            % Pad the segment with zeros if it's shorter than 4 bits
            if length(segment) < k
                segment = [segment, zeros(1, k - length(segment))];
            end
    
            % Generate Hamming code
            encoded_segment = encodeHamming74(segment);
    
            % Append the encoded segment to the result
            encoded_bits = [encoded_bits, encoded_segment];
        end
    
        % Store the encoded message in the cell array
        encoded_messages_new{i} = encoded_bits;
    end
    
end

function encoded_bits = encodeHamming74(input_bits)
    % Generate the parity bits
    p1 = mod(sum(input_bits([1 2 4])), 2);
    p2 = mod(sum(input_bits([1 3 4])), 2);
    p3 = mod(sum(input_bits([2 3 4])), 2);

    % Concatenate the parity bits with the original data bits
    encoded_bits = [input_bits p1 p2 input_bits(1) p3 input_bits(2:4)];
end
