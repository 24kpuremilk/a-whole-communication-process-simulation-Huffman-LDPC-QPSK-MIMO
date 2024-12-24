function [encoded_bin_Data] = get_bin_input(encoded_oct_Data, redundance2, redundance3)
    encoded_oct_Data = encoded_oct_Data(1:end-200);
    num_octal_digits = length(encoded_oct_Data)-redundance3;
    
    total_binary_length = num_octal_digits * 3;
    
    % Initialize the binary data array
    app = zeros(total_binary_length,1);
    
    % Convert octal to binary
    for i = 1:num_octal_digits
        % Convert each octal value to a 3-bit binary representation
        binary_str = dec2bin(encoded_oct_Data(i), 3); 
        app((i-1)*3 + 1:(i-1)*3 + 3) = binary_str - '0'; % Convert string to numeric array
    end
    
    % Remove any padding added to satisfy the binary length requirement
    encoded_bin_Data = app(1:end-redundance2);

end
