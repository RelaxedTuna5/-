% Часть 1: Чтение и прослушивание
song1 = audioread("bass.mp3");
sound(song1, 44100);
duration_bass = length(song1) / 44100; 

disp("Длительность записи bass.mp3: " + duration_bass + " секунд.");
%%
song2 = audioread("guitars.mp3");
duration_guitars = length(song2) / 44100;
disp("Длительность записи guitar.mp3: " + duration_guitars + " секунд.");
sound(song2, 44100);
%%
song3 = audioread("synths.mp3");
duration_synths = length(song3) / 44100;
disp("Длительность записи synths.mp3: " + duration_synths + " секунд.");
sound(song3, 44100);
%%
song4 = audioread("drums.mp3");
duration_drums = length(song4) / 44100;
disp("Длительность записи drums.mp3: " + duration_drums + " секунд.");
sound(song4, 44100);

%%
% Часть 2: Матрица мелодии
song1 = audioread("bass.mp3");
song2 = audioread("guitars.mp3");
song3 = audioread("synths.mp3");
song4 = audioread("drums.mp3");
melodyMatrix = [song1, song2, song3, song4];

% Часть 3: Умножение на вектор

tmpVector = ones(4,1);
melody = melodyMatrix * tmpVector;
sound(melody, 44100); 
%%
% Часть 4: Вычитание искомого инструмента
song1 = audioread("bass.mp3");
song2 = audioread("guitars.mp3");
song3 = audioread("synths.mp3");
song4 = audioread("drums.mp3");
melodyMatrix = [song1, song2, song3, song4];

tmpVector = ones(4,1);
melody = melodyMatrix * tmpVector;
song1 = audioread("bass.mp3");
melody_minus_one = melody - song1;
sound(melody_minus_one, 44100);
%%
% Часть 5: Искажение сигнала
song1 = audioread("bass.mp3");
song2 = audioread("guitars.mp3");
song3 = audioread("synths.mp3");
song4 = audioread("drums.mp3");
melodyMatrix = [song1, song2, song3, song4];

tmpVector = ones(4,1);
melody = melodyMatrix * tmpVector;
t = (1:length(song1))*1/44100;
volumeMod = sin(2*pi*(t)*(2/duration_melody_distorted)); %1/15
volumeMod = volumeMod';
melody_distorted = melody .* volumeMod;
sound(melody_distorted, 44100);
duration_melody_distorted = length(melody_distorted) / 44100;
disp("Длительность записи melody_distorted: " + duration_melody_distorted + " секунд.")
%% Укорачивание музыки в 2 раза
song1 = audioread("bass.mp3");
song2 = audioread("guitars.mp3");
song3 = audioread("synths.mp3");
song4 = audioread("drums.mp3");
melodyMatrix = [song1, song2, song3, song4];
X = melodyMatrix';
tmp = X(1:1:length(X(:))/2);
halfMelodyMatrix = reshape(tmp, 4,length(tmp)/4);
halfMelody = sum(halfMelodyMatrix);
sound(halfMelody,44100);
duration_halfMelody = length(halfMelody) / 44100;
disp("Длительность записи halfMelody: " + duration_halfMelody + " секунд.");
%% Двухканальный звук
song1 = audioread("bass.mp3");
song2 = audioread("guitars.mp3");
song3 = audioread("synths.mp3");
song4 = audioread("drums.mp3");
melodyMatrix = [song1, song2, song3, song4];
tmpVector = ones(4,1);
melody = melodyMatrix * tmpVector;
basssize = size(melody, 1)/44100; %Вычисляем размер мелодии (basssize) в секундах, разделив количество строк в векторе мелодии (size(melody, 1)) на часоту дискретизации аудиофайлов (44100).
polozhitelnoe = melody.*(melody > 0);
otricatelnoe = melody (melody < 0);
fspl = size(polozhitelnoe,1)/basssize; %Вычисляет частоту сэмплирования положительных значений (fspl) путем деления количества строк в векторе положительных значений на размер мелодии basssize.
fsmin = size(otricatelnoe, 1)/basssize;%Вычисляет частоту сэмплирования отрицательных значений (fsmin) путем деления количества строк в векторе отрицательных значений на размер мелодии basssize.
% sound(otricatelnoe, fsmin);
sound (polozhitelnoe, fspl);
%Создаем индексы (ind1 и ind2), указывающие ячейки вектора мелодии, где значения превышают или меньше 0.5 соответственно.
ind1=melody>0.5;
ind2=melody<0.5;
%Умножаем вектор мелодии на соответствующие индексы, чтобы получить два новых вектора - ch1 и ch2. В ch1 сохраняются только значения мелодии, которые превышают 0.5, а в ch2 сохраняются только значения мелодии, которые меньше 0.5.
ch1=melody.* ind1;
ch2=melody.* ind2;
%Объединяем векторы ch1 и ch2 в матрицу ch1ch2, чтобы создать два канала с аудиоданными.
ch1ch2=[ch1, ch2];
% sound(ch1ch2,44100);