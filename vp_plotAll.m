function vp_plotAll(x_original, x_processed, fs, title_str)

    if nargin < 4, title_str = 'Phân tích tín hiệu'; end

    freq_display_max = min(5000, fs / 2);

    fig = figure('Name', title_str, 'Position', [50, 50, 1100, 850]);
    sgtitle(title_str, 'FontSize', 13, 'FontWeight', 'bold');

    t_orig = (0:length(x_original)-1)' / fs;
    t_proc = (0:length(x_processed)-1)' / fs;

    subplot(3,2,1); plot(t_orig, x_original, 'b', 'LineWidth', 0.8);
    title('Tín hiệu Gốc (Thời gian)'); xlabel('s'); ylabel('Biên độ');
    ylim([-1.1 1.1]); grid on;

    subplot(3,2,2); plot(t_proc, x_processed, 'r', 'LineWidth', 0.8);
    title('Tín hiệu Xử lý (Thời gian)'); xlabel('s'); ylabel('Biên độ');
    ylim([-1.1 1.1]); grid on;

    N1 = length(x_original);
    f1 = (0:floor(N1/2)-1) * (fs/N1);
    X1_db = 20*log10(abs(fft(x_original))/N1 + eps);
    subplot(3,2,3); plot(f1, X1_db(1:floor(N1/2)), 'b', 'LineWidth', 0.8);
    title('Phổ FFT Tín hiệu Gốc (dB)'); xlabel('Hz'); ylabel('dB');
    xlim([0 freq_display_max]); ylim([-80 0]); grid on;

    N2 = length(x_processed);
    f2 = (0:floor(N2/2)-1) * (fs/N2);
    X2_db = 20*log10(abs(fft(x_processed))/N2 + eps);
    subplot(3,2,4); plot(f2, X2_db(1:floor(N2/2)), 'r', 'LineWidth', 0.8);
    title('Phổ FFT Tín hiệu Xử lý (dB)'); xlabel('Hz'); ylabel('dB');
    xlim([0 freq_display_max]); ylim([-80 0]); grid on;

    win_len = 512;
    overlap = 256;
    nfft    = 1024;

    subplot(3,2,5);
    spectrogram(x_original, hanning(win_len), overlap, nfft, fs, 'yaxis');
    title('Spectrogram Tín hiệu Gốc (STFT)');
    ylim([0 freq_display_max/1000]); colormap(gca, 'jet');

    subplot(3,2,6);
    spectrogram(x_processed, hanning(win_len), overlap, nfft, fs, 'yaxis');
    title('Spectrogram Tín hiệu Xử lý (STFT)');
    ylim([0 freq_display_max/1000]); colormap(gca, 'jet');

  
    if ~exist('audio_output', 'dir')
        mkdir('audio_output');
    end
    imagePath = 'audio_output/vp_signal_analysis_STFT.png';
    saveas(fig, imagePath);

end