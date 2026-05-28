function y_shifted = vp_pitchShift(x, semitones, fs)
    if nargin < 3, fs = 44100; end

    x = x(:);
    if isempty(x) || max(abs(x)) < 1e-9
        y_shifted = x;
        return;
    end

    try
        y_shifted = shiftPitch(x, semitones, 'LockPhase', true);

        target_len = length(x);
        if length(y_shifted) > target_len
            y_shifted = y_shifted(1:target_len);
        elseif length(y_shifted) < target_len
            y_shifted = [y_shifted; zeros(target_len - length(y_shifted), 1)];
        end

    catch
        ratio = 2^(-semitones / 12); 

        [p, q] = rat(ratio, 0.001);
        p = min(p, 500); q = min(q, 500); 

        y_raw      = resample(x, p, q);
        target_len = length(x);

        if length(y_raw) >= target_len
            fade_len  = min(round(0.05 * target_len), 2000); 
            y_shifted = y_raw(1:target_len);
            fade_win  = linspace(1, 0, fade_len)';
            y_shifted(end - fade_len + 1:end) = ...
                y_shifted(end - fade_len + 1:end) .* fade_win;
        else
            fade_len  = min(round(0.08 * length(y_raw)), 2000);
            fade_win  = linspace(1, 0, fade_len)';
            y_raw(end - fade_len + 1:end) = ...
                y_raw(end - fade_len + 1:end) .* fade_win;
            y_shifted = [y_raw; zeros(target_len - length(y_raw), 1)];
        end
    end

    peak = max(abs(y_shifted));
    if peak > 1e-9
        y_shifted = y_shifted / peak;
    end
end