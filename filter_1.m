%%Скрипт Matlab для подготовки тестовых данных для передачи в тестбенч.
fid = fopen('wifi_80211b_fd22.pcm');
% Чтение 16-битных целочисленных отсчетов из файла.

data = fread(fid,Inf,'int16');
fclose(fid);
data_i = downsample(data,2); % Синфазная составляющая входного сигнала
data_q = downsample(data,2,1); % Квадратурная составляющая входного сигнала
data_samples = complex(data_i,data_q); % Результирующий сигнал в основной полосе частот.

%% Запись отсчетов в файл
%wr_sig_full = round(data_samples*2048); % Масштабирование исходного сигнала для записи в текстовый файл
dlmwrite('data2fpga.dat', data_samples); 
%% Чтение результатов моделирования алгоритма в FPGA из файла
fpga_result = dlmread('data_from_fpga.dat');
fpga_result_full = complex(fpga_result(:, 1), fpga_result(:, 2));
%% эталон
fs = 1569401; % Частота дискретизации
dt = 1/fs; % Интервал дискретизации
n = (0:fs - 1)'; % Шкала времени (номера отсчетов)
t = n*dt; % Шкала времени (в секундах)

bar_sequence = [+1, +1, +1, -1, -1, -1, +1, -1, -1, +1, -1];
fil_2 = conv(data_samples, flip(conj(bar_sequence)));

figure(1) % выход фильтра Matlab
hold all
grid on
plot(t, abs(fil_2),'--r')

%%
fs = 1569391; % Частота дискретизации
dt = 1/fs; % Интервал дискретизации
n = (0:fs - 1)'; % Шкала времени (номера отсчетов)
t = n*dt; % Шкала времени (в секундах)

figure(2) % изначальный сигнал
hold all
grid on
plot(t, abs(data_samples),'-g')

figure(3) % выход фильтра fpga
hold all
grid on
plot(t, abs(fpga_result_full),'--b')
