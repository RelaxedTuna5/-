clear; 
clear; 
clc; 
% Parameters 
fs = 25e6; % Sampling frequency (Hz) 
fft_size = 1024; % FFT size 
overlap = 512; % Overlap 
signal_duration = 102.4e-6; % Duration of each signal (seconds) 
n_samples_per_signal = signal_duration * fs; % Number of samples per signal 
 
% Frequencies of the signals 
frequencies = [1e6, 5e6, -2e6]; % Frequencies of the signals (Hz) 
 
% Time vector for each signal 
t = (0:n_samples_per_signal-1) / fs; 
 
% Generate the complex signals 
signals = []; 
for i = 1:length(frequencies) 
    freq = frequencies(i); 
    signal = exp(1j * 2 * pi * freq * t); 
    signals = [signals, signal]; 
end 

% Масштабирование сигнала
wr_sig_full_real = round(real(signals) * 2048); % Реальная часть
wr_sig_full_imag = round(imag(signals) * 2048); % Мнимая часть

% Объединение реальной и мнимой частей в один массив
wr_sig_full = [wr_sig_full_real; wr_sig_full_imag]';
disp(max(wr_sig_full))
disp(min(wr_sig_full))
% Запись отсчетов в файл формата .dat
dlmwrite('generated_signals.dat', wr_sig_full, 'delimiter', ' ');
% signals = flip(signals);
%% fft 
maxhold_res = zeros(1,1024); 
window = zeros(1, 1024);
for i = 0:512:6656
    for j = 1:1024
        window(j) = signals(j + i);
    end
    fft_res = fft(window, fft_size);
    maxhold_res = max([maxhold_res; abs(fft_res)]);
end    

maxhold_res = fftshift(maxhold_res');   
disp(max(maxhold_res))
%% 
fpga_res = dlmread('MAX_hold.dat');
fpga_res_1 = fpga_res / 2048;
maxhold_fpga = 20 * log10(fpga_res_1);
maxhold_res_log = 20*log10(maxhold_res); 

% signalAnalyzer(maxhold_fpga)
% signalAnalyzer(maxhold_res_log)
% figure
% semilogy(fpga_res_1)

figure
plot(maxhold_res_log);
grid on
hold on
xlim([0, 1023]);
xlabel('Спектр (fpga и matlab)');
ylabel('Амплитуда (дБ)');
xticks([0, 431, 554, 718, 1023]);  % Указываем, где должны быть метки на оси X
xticklabels({'-12.5 МГц', '-2 МГЦ', '1 МГц', '5 МГц', '12.5 МГц'}); % Подписи для этих меток
plot(maxhold_fpga) ;