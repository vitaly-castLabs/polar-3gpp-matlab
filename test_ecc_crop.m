function test_ecc_crop()
%{
This test picks a randomly placed range of ${crop} bits/LLRs to preserve,
then all other bits/LLRs are set to 0 and decoding is attempted.
Crop: 15 bits, decoding success: 10.9%, wrong corrections: 11.8%
Crop: 16 bits, decoding success: 15.7%, wrong corrections: 10.6%
Crop: 17 bits, decoding success: 28.7%, wrong corrections: 8.1%
Crop: 18 bits, decoding success: 44.7%, wrong corrections: 6.1%
Crop: 19 bits, decoding success: 60.9%, wrong corrections: 4.9%
Crop: 20 bits, decoding success: 79.8%, wrong corrections: 2.1%
Crop: 21 bits, decoding success: 86.3%, wrong corrections: 1.9%
Crop: 22 bits, decoding success: 92.7%, wrong corrections: 0.8%
Crop: 23 bits, decoding success: 96.3%, wrong corrections: 0.5%
Crop: 24 bits, decoding success: 96.9%, wrong corrections: 0.4%
Crop: 25 bits, decoding success: 98.9%, wrong corrections: 0.0%
Crop: 26 bits, decoding success: 99.4%, wrong corrections: 0.0%
Crop: 27 bits, decoding success: 99.4%, wrong corrections: 0.0%
Crop: 28 bits, decoding success: 99.9%, wrong corrections: 0.0%
Crop: 29 bits, decoding success: 100.0%, wrong corrections: 0.0%
Crop: 30 bits, decoding success: 100.0%, wrong corrections: 0.0%

Wrong correction is when PUCCH_decoder returns some bit sequence, but it
doesn't match the original message (in most cases PUCCH_decoder returns an
empty array if it cannot decode/correct the message).
%}
    for crop = 15:30
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
    
            range_start = randi([1, E]);
            range_end = range_start + crop;
            if range_end > E
                range_end = E;
                range_start = range_end - crop;
            end
            
            % zero out everything outside the range
            f_tilde(1:range_start - 1) = 0;
            f_tilde(range_end:end) = 0;
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
    
        fprintf("Crop: %d bits, decoding success: %.1f%%, wrong corrections: %.1f%%\n", crop, (100.0 * succ) / num_iterations, (100.0 * wrong_dec) / num_iterations);
    end
end
