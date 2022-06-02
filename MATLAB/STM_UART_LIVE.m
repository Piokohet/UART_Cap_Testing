%
close all; clear all;

Fs = 49152; %Sampling frequency 48762 - 1000Hz, 49350 - 2000,02Hz, 49152 - 3000Hz for microphone
T = 1/Fs;   %Sampling period
L = 2048;   %length of signal

s = serialport("COM3",1843200);
configureTerminator(s,"CR");
fopen(s);


i = 1;
while(1)
    dataLive = read(s,2048,"uint8");
%     dataLive(i:1:20480) = str2double(fscanf(s));
    plot(dataLive);
    ylim([0 300]);
    xlim([0 2048]);
    pause(T);
    i = i+1;
end

%flushinput(s)
%instrfind()