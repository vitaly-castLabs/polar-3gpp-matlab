function test_ecc_scatter()
%{
This test picks randomly scattered ${crop} bits/LLRs to preserve,
while all other bits/LLRs are set to 0. This is different from
test_ecc_crop where we preserve contiguous blocks of bits/LLRs.
Scatter: 15 bits, decoding success: 14.2%, wrong corrections: 10.4%
Scatter: 16 bits, decoding success: 22.8%, wrong corrections: 8.6%
Scatter: 17 bits, decoding success: 37.7%, wrong corrections: 7.6%
Scatter: 18 bits, decoding success: 52.6%, wrong corrections: 6.0%
Scatter: 19 bits, decoding success: 70.8%, wrong corrections: 3.7%
Scatter: 20 bits, decoding success: 82.2%, wrong corrections: 2.4%
Scatter: 21 bits, decoding success: 88.7%, wrong corrections: 1.7%
Scatter: 22 bits, decoding success: 94.0%, wrong corrections: 1.0%
Scatter: 23 bits, decoding success: 96.6%, wrong corrections: 1.1%
Scatter: 24 bits, decoding success: 98.8%, wrong corrections: 0.1%
Scatter: 25 bits, decoding success: 98.8%, wrong corrections: 0.2%
Scatter: 26 bits, decoding success: 99.8%, wrong corrections: 0.0%
Scatter: 27 bits, decoding success: 99.5%, wrong corrections: 0.2%
Scatter: 28 bits, decoding success: 100.0%, wrong corrections: 0.0%
Scatter: 29 bits, decoding success: 100.0%, wrong corrections: 0.0%
Scatter: 30 bits, decoding success: 99.9%, wrong corrections: 0.0%

Wrong correction is when PUCCH_decoder returns some bit sequence, but it
doesn't match the original message (in most cases PUCCH_decoder returns an
empty array if it cannot decode/correct the message).
%}
    for num_bits = 15:30
        succ = 0;
        wrong_dec = 0;
        num_iterations = 1000;
        for i = 1:num_iterations
            % Generate a random length for 'a' between 12 and 1706
            A = 13;

            % Generate a random binary row vector 'a' of length A
            a = randi([0, 1], 1, A);
            E = 8040;

            % Encode
            f = PUCCH_encoder(a, E);

            f_corrupted = f;
            f_tilde = bits_to_llr(f_corrupted);

            n = length(f_tilde);
            % Randomly select indices to preserve
            preserved_indices = randperm(n, num_bits);
            % Create mask and zero out other values
            mask = false(1, n);
            mask(preserved_indices) = true;
            f_tilde(~mask) = 0;

            f_tilde = f_tilde.';
            %disp(f_tilde);

            % Decode
            L = 8; % List size for decoding
            min_sum = true; % Use log-sum-product for better performance
            decoded_a = PUCCH_decoder(f_tilde, length(a), L, min_sum);

            if isequal(a, decoded_a)
                succ = succ + 1;
            elseif length(decoded_a) > 0
                wrong_dec = wrong_dec + 1;
            end
        end

        fprintf("Scatter: %d bits, decoding success: %.1f%%, wrong corrections: %.1f%%\n", num_bits, (100.0 * succ) / num_iterations, (100.0 * wrong_dec) / num_iterations);
    end
end
