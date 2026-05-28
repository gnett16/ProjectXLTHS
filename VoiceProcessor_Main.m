
clc; clear; close all;
 
fs = 44100;        
 duration_input = input('>>> Nhập thời gian ghi âm (giây, mặc định = 5): ', 's');
if isempty(duration_input)
    duration = 5;
else
    duration = max(1, min(30, str2double(duration_input)));
    if isnan(duration), duration = 5; end
end
disp(['>>> Thời gian ghi âm: ', num2str(duration), ' giây.']);
 
fprintf('Ấn phím  '); pause; fprintf('\n');
 
recObj = audiorecorder(fs, 16, 1);
 
disp('>>> ĐANG GHI ÂM');
recordblocking(recObj, duration);
disp('>>> Done');
 
x = getaudiodata(recObj);

x = x - mean(x); 
ignore_samples = round(0.1 * fs);
if length(x) > ignore_samples
    x = x(ignore_samples+1 : end);
end
 
if isempty(x) || max(abs(x)) < 1e-6
    error(['bug ', ...
           'recheck']);
end
disp(['>>>  Biên độ tối đa: ', num2str(max(abs(x)), '%.4f')]);
 
 
x_clean = vp_spectralSubtraction(x, fs);
 
if max(abs(x_clean)) < 1e-6
    warning('bug.');
    x_clean = x; 
end
 

y_male   = vp_pitchShift(x_clean, -2.5, fs);

y_female = vp_femaleVoice(x_clean, fs);
 
y_robot  = vp_robotVoice(x_clean, fs, 400);
 
disp('>>> Đang biểu diễn tín hiệu và xuất đồ thị phân tích');
vp_plotAll(x_clean, y_robot, fs, 'Phân tích Phổ Tín hiệu');
 
disp('>>> lưu file ');
 
output_dir = 'audio_output';
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end
 
safeWrite = @(path, sig, rate) audiowrite(path, ...
    max(-1, min(1, sig / max(abs(sig) + eps))), rate);
 
safeWrite([output_dir, '/audio_original.wav'],  x,        fs);
safeWrite([output_dir, '/audio_clean.wav'],     x_clean,  fs);
safeWrite([output_dir, '/audio_male.wav'],      y_male,   fs);
safeWrite([output_dir, '/audio_female.wav'],    y_female, fs);
safeWrite([output_dir, '/audio_robot.wav'],     y_robot,  fs);
 
