% Convert integers to binary format with 8 bits (1 byte) width
binary_messages = dec2bin(new_messages(1, 2), 8);

% Convert binary strings to numeric array
binary_messages_numeric = double(binary_messages) - 48; % Convert ASCII '0' and '1' to numeric 0 and 1