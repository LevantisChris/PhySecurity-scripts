function [total_errors, num_messages] = applyCRC_11_d()
    
    % Ειμαστε στο Δέκτη
    load('unRedundancy_messages_11c.mat', 'unRedundancy_messages');

    crc24_gen = comm.CRCGenerator('Polynomial', [1 1 0 0 0 0 1 1 0 0 1 0 0 1 1 0 0 1 1 1 1 1 0 1 1]);

    num_messages = size(unRedundancy_messages, 1);


    total_errors = 0;
    for i = 1:num_messages
        message = unRedundancy_messages(i, :);
        % Εφαρμόζουμε την παρακάτω συνάρτηση για κάθε ολόκληρο μήνυμα του 
        % ερωτήματος 11 c
        error = check_errors_CRC(array2string(message), ...
            array2string([1 1 0 0 0 0 1 1 0 0 1 0 0 1 1 0 0 1 1 1 1 1 0 1 1]));
        if(error == 0)
           total_errors = total_errors + 1; 
        end
    end
end

%% CRC check error
% 0 --> error
% 1 --> no-error
function [error] = check_errors_CRC(receivedMessage, divisor)
    receivedMessage = receivedMessage - '0';
    divisor = divisor - '0';

    divisorLength = length(divisor);

    % Βάζουμε μηδενικά στο λαμβανόμενο μήνυμα για να ταιριάζει με το
    % μέγεθος του divisor
    appendedMessage = [receivedMessage, zeros(1, divisorLength - 1)];

    remainder = appendedMessage(1:divisorLength);

    % Κάνουμε την διαίρεση XOR
    for i = divisorLength:length(appendedMessage)
        if remainder(1) == 1
            % XOR με το divisitor
            remainder = xor(remainder, divisor);
        end
        
        % Shift δεξιά για να φέρουμε το νέο bit
        if i < length(appendedMessage)
            remainder = [remainder(2:end), appendedMessage(i + 1)];
        else
            remainder = remainder(2:end);
        end
    end

    % Αν αυτό που μένει από την διαίρεση είναι όλα 0 τότε δεν έχουμε λάθος
    if all(remainder == 0)
        %disp('No error in the received message.');
        error = 1;
    else
        %disp('Error detected in the received message.');
        error = 0;
    end
end

%% Για να μετατραπεί array σε string
function str_array = array2string(array)
    reshapedArray = reshape(array, 1, []);
    strWithSpaces = num2str(reshapedArray);
    strWithoutSpaces = strrep(strWithSpaces, ' ', '');
    str_array = strWithoutSpaces;
end