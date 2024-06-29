function errorCounts = test(generatorPolynomial)
    load('receiver_decoded_CRC_11d.mat', 'receiver_decoded_CRC');
    numMessages = size(receiver_decoded_CRC, 1);
    errorCounts = zeros(numMessages, 1);  % To store error results for each message

    for i = 1:numMessages
        receivedMessage = logical(receiver_decoded_CRC(i, :));  % Convert to logical
        generatorPolynomial = logical(generatorPolynomial(:));

        % Append zeros for CRC bits (only if needed)
        if length(receivedMessage) < length(generatorPolynomial)
            receivedMessage = [receivedMessage; zeros(length(generatorPolynomial) - length(receivedMessage), 1)];
        end

        % Perform modulo-2 division
        remainder = mod(conv(receivedMessage, generatorPolynomial), 2);

        % Count errors (without displaying each time)
        errorCounts(i) = any(remainder);  % 1 if error, 0 if no error
    end
end
