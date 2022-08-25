% !!DO POMIAROW!!

% data(:,ityPomiar) = read(s,2048,'uint');
%dla 100Hz

Fs = 48780; %Sampling frequency 48762 - 1000Hz, 49350 - 2000,02Hz, 49152 - 3000Hz for microphone
T = 1/Fs;   %Sampling period
L = 2048;   %length of signal
Fw = 3000;   %czestotliwosc zadana wzbudnika 100HZ; 500; 1000;1500;2000;
Amp = 3.75;    %zmierzona amplituda
NoMes = 10; %liczba pomiarow

s = serialport("COM3",1843200);
configureTerminator(s,"CR");
fopen(s);
data = zeros(2048,NoMes);


for i=1:1:NoMes
data(:,i)= read(s,2048,'uint8');
pause(T);
end
fclose(s);
delete(s);