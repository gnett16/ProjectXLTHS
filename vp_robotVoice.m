function y_robot = vp_robotVoice(x, fs, f_carrier)
    % VP_ROBOTVOICE Tạo hiệu ứng giọng Robot (Ring Modulation)
    % Đầu vào:
    %   x         : Tín hiệu âm thanh gốc
    %   fs        : Tần số lấy mẫu
    %   f_carrier : Tần số sóng mang (Mặc định: 400Hz)
    
    if nargin < 3
        f_carrier = 400; 
    end
    
    t = (0:length(x)-1)' / fs;
    y_robot = x .* sin(2 * pi * f_carrier * t);
end