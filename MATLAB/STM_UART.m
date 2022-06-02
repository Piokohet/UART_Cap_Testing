clear;
clc;
close all;

Fs = 49152; %Sampling frequency 48762 - 1000Hz, 49350 - 2000,02Hz, 49152 - 3000Hz for microphone
T = 1/Fs;   %Sampling period
L = 2048;   %length of signal

s = serialport("COM3",1843200);
data = read(s,2048,"uint8");
Y = fft(data);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

