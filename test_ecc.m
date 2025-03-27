function test_ecc() %#codegen
    % binary message to "send" (12 bits or more)
    a = [1 1 1 1 0 0 0 0 1 1 1 1 0 0 0 0];
    G = 32; % codeword length, has to be power of 2, more than length(a)

    disp('Org message:');
    disp(a);

    % Encode
    f = PUCCH_encoder(a, G);
    disp('Encoded:');
    disp(f);

    f_corrupted = f;

    % flip some bits: our (32,16) code should be roughly equivalent to RM(2,5) which
    % has a minimum distance of 8. So 3-bit flips should work, but 4+ ones should fail
    flips = [1, 2, 3];
    for i = 1:length(flips)
        idx = flips(i);
        f_corrupted(idx) = mod(f(idx) + 1, 2);
    end

    disp('Corrupted (3 bits):');
    disp(f_corrupted);

    % Convert to LLR (ln (p0/p1)), that is what decoder expects
    f_tilde = bits_to_llr(f_corrupted);

    % Decode
    L = 8; % List size for decoding
    min_sum = true; % Use log-sum-product for better performance
    decoded_a = PUCCH_decoder(f_tilde, length(a), L, min_sum);

    % Print decoded result
    disp('Decoded:');
    disp(decoded_a);

    % Check if decoding was successful
    if isequal(a, decoded_a)
        disp('Decoding successful!');
    else
        disp('Decoding failed!');
    end
end
