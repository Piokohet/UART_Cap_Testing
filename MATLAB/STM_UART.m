clear;
clc;
close all;

Fs = 49180.3; %Sampling frequency 48762 - 1000Hz, 49350 - 2000,02Hz, 49152 - 3000Hz for microphone, 49180,3Hz - from calculations
T = 1/Fs;   %Sampling period
L = 2048;   %length of signal

s = serialport("COM3",921600);
data = read(s,L,"uint8");
Y = fft(data);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;
w = window(@blackmanharris,L);
w = w';
df = w.*data;
figure(1);
plot(f,P1) 

title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

figure(2)
subplot(1,2,1)
plot(data)
subplot(1,2,2)
plot(df)


Y1 = fft(df);
P2f = abs(Y1/L);
P1f = P2f(1:L/2+1);
P1f(2:end-1) = 2*P1f(2:end-1);

ff = Fs*(0:(L/2))/L;
figure(3);
plot(ff,P1f); 


title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

