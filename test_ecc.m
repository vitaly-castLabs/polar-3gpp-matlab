function test_ecc() %#codegen
    num_iterations = 3;

    for i = 1:num_iterations
        % Generate a random length for 'a' between 12 and 1706
        A = randi([12, 32]);

        % Generate a random binary row vector 'a' of length A
        a = randi([0, 1], 1, A);

        a_len = length(a);
        E = a_len * 3;

        disp("Org message:");
        disp(a);

        % Encode
        f = PUCCH_encoder(a, E);
        disp("Encoded:");
        disp_segmented(f, a_len);

        f_corrupted = f;
        f_tilde = bits_to_llr(f_corrupted);

        n = length(f_tilde);  % Get the length of f_tilde
        num_zeros = n - (A + 6);
        fprintf("Num erasures: %d / %d, intact bits: %d\n\n", int32(num_zeros), int32(E), int32(E - num_zeros));

        indices = randperm(n, num_zeros);  % Randomly select indices to set to 0
        f_tilde(indices) = 0;  % Set selected indices to 0
        f_tilde = f_tilde.';
        disp("Received:");
        disp_segmented(f_tilde, a_len);

        % Decode
        L = 8; % List size for decoding
        min_sum = true; % Use log-sum-product for better performance
        decoded_a = PUCCH_decoder(f_tilde, length(a), L, min_sum);

        disp("Decoded:");
        disp(decoded_a);

        if isequal(a, decoded_a)
            disp("success" + newline);
        else
            disp("failure" + newline);
        end
    end
end
