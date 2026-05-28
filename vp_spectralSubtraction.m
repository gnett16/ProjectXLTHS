function x_clean = vp_spectralSubtraction(x, fs)

    bpFilt = designfilt('bandpassfir', 'FilterOrder', 100, ...
             'CutoffFrequency1', 300, 'CutoffFrequency2', 3400, ...
             'SampleRate', fs);

    x_clean = filter(bpFilt, x);
    
    x_clean = x_clean / max(abs(x_clean));
end