function y_female = vp_femaleVoice(x, fs)
    if nargin < 2, fs = 44100; end

    x = x(:);
    if isempty(x) || max(abs(x)) < 1e-9
        y_female = x;
        return;
    end

    target_len = length(x);

    y_pitched = vp_pitchShift(x, 4.0, fs);

    formant_ratio = 1 / 1.15;   
    [pf, qf] = rat(formant_ratio, 0.005);
    
    y_formant = resample(y_pitched, pf, qf);

    if length(y_formant) >= target_len
        y_formant = y_formant(1:target_len);
    else
        y_formant = [y_formant; zeros(target_len - length(y_formant), 1)];
    end

    breath_level = 0.015; 
    noise_raw = randn(target_len, 1);
    hpFilt = designfilt('highpassfir', 'FilterOrder', 60, ...
             'CutoffFrequency', 3500, 'SampleRate', fs);
    breath_noise = filter(hpFilt, noise_raw);

    breath_noise = breath_noise / (max(abs(breath_noise)) + eps);
    breath_noise = breath_noise * max(abs(y_formant)) * breath_level;

    y_mix = y_formant + breath_noise;

    bpBoost = designfilt('bandpassfir', 'FilterOrder', 60, ...
              'CutoffFrequency1', 1500, 'CutoffFrequency2', 3500, ...
              'SampleRate', fs);
    y_boost = filter(bpBoost, y_mix);
    y_mix   = y_mix + 0.20 * y_boost;

    peak = max(abs(y_mix));
    if peak > 1e-9
        y_female = y_mix / peak;
    else
        y_female = y_mix;
    end
end