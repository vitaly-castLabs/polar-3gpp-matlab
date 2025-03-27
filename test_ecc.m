function test_ecc() %#codegen
    % binary message to "send" (12 bits or more)
    a = [1 1 1 1 0 0 0 0 1 1 1 1 0 0 0 0];
    G = 32; % codeword length, has to be power of 2, more than length(a)

    disp("Org message:");
    disp(a);

    % Encode
    f = PUCCH_encoder(a, G);
    disp("Encoded:");
    disp(f);

    f_corrupted = f;

    % flip some bits: our (32,16) code should be roughly equivalent to RM(2,5) which
    % has a minimum distance of 8. So 3-bit flips should work, but 4+ ones should fail
    flips = [1, 2, 3];
    for i = 1:length(flips)
        idx = flips(i);
        f_corrupted(idx) = mod(f(idx) + 1, 2);
    end

    disp("Corrupted:");
    disp(f_corrupted);

    % Convert to LLR (ln (p0/p1)), that is what decoder expects
    f_tilde = bits_to_llr(f_corrupted);

    % Decode
    L = 8; % List size for decoding
    min_sum = true; % Use log-sum-product for better performance
    decoded_a = PUCCH_decoder(f_tilde, length(a), L, min_sum);

    disp("Decoded:");
    disp(decoded_a);

    disp("Test #1 (3 bit flips, burst):");
    if isequal(a, decoded_a)
        disp("success" + newline);
    else
        disp("failure" + newline);
    end

    % Test #2 - 3 flips with gaps
    f_corrupted = f;
    flips = [2, 4, 6];
    for i = 1:length(flips)
        idx = flips(i);
        f_corrupted(idx) = mod(f(idx) + 1, 2);
    end

    f_tilde = bits_to_llr(f_corrupted);
    decoded_a = PUCCH_decoder(f_tilde, length(a), L, min_sum);
    disp("Test #2 (3 bit flips, spread):");
    if isequal(a, decoded_a)
        disp("success" + newline);
    else
        disp("failure" + newline);
    end

    % Test #3 - 4 flips
    f_corrupted = f;
    flips = [1, 3, 5, 7];
    for i = 1:length(flips)
        idx = flips(i);
        f_corrupted(idx) = mod(f(idx) + 1, 2);
    end

    f_tilde = bits_to_llr(f_corrupted);
    decoded_a = PUCCH_decoder(f_tilde, length(a), L, min_sum);
    disp("Test #3 (4 bit flips, spread):");
    if isempty(decoded_a)
        disp("success (decoding failed as expected)" + newline);
    else
        disp("failure - decoded:");
        disp(decoded_a);
        disp();
    end

    % Test #4 - 4 erasures
    f_tilde = bits_to_llr(f);

    erasures = [5, 10, 15, 20];
    for i = 1:length(erasures)
        idx = erasures(i);
        f_tilde(idx) = 0; % setting it to 0 indicates equal probs for 0 and 1
    end

    decoded_a = PUCCH_decoder(f_tilde, length(a), L, min_sum);
    disp("Test #4 (4 erasures, spread):");
    if isequal(a, decoded_a)
        disp("success" + newline);
    else
        disp("failure" + newline);
    end

    % Test #5 - 5 erasures
    f_tilde = bits_to_llr(f);

    erasures = [3, 4, 5, 6, 7];
    for i = 1:length(erasures)
        idx = erasures(i);
        f_tilde(idx) = 0;
    end

    decoded_a = PUCCH_decoder(f_tilde, length(a), L, min_sum);
    disp("Test #5 (5 erasures, burst):");
    if isequal(a, decoded_a)
        disp("success" + newline);
    else
        disp("failure" + newline);
    end
end
