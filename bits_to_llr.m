function f_tilde = bits_to_llr(f, confidence)
    arguments
       f (:,1) {mustBeNumeric, mustBeInteger, mustBeMember(f, [0,1])}
       confidence double = 10
    end

    % 0 gets translated into +confidence, and 1 into -confidence
    f_tilde = (1 - 2 * f) * confidence;
end
