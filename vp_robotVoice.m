function y_robot = vp_robotVoice(x, fs, f_carrier)

    
    if nargin < 3
        f_carrier = 400; 
    end
    
    t = (0:length(x)-1)' / fs;
    y_robot = x .* sin(2 * pi * f_carrier * t);
end