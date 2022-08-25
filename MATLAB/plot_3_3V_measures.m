clear all; clc; close all;

load("MATLAB\3_3V_measures.mat");
V1_3_3 = ((Amp_pom_1/2+128)*3.3)/255; %%przeliczenie na volt pierwszej serii pomiarow
a1_3_3 = (V1_3_3-1.65)/0.027;         %%przeliczenie na g pierwszej serii pomiarow, czułość dla VDD 3.3V = 26mV
V2_3_3 = ((Amp_pom_2/2+128)*3.3)/255; %%przeliczenie na volt drugiej serii pomiarow
a2_3_3 = (V2_3_3-1.65)/0.027;         %%przeliczenie na g drugiej serii pomiarow, czułość dla VDD 3.3V = 26mV
ApAw1 = Amp_pom_1./Amp_wz_1;          %%charakterystyka statyczna czujnika dla pierwszej serii pomiarow [8bit/g]
ApAw2 = Amp_pom_2./Amp_wz_2;          %%charakterystyka statyczna czujnika dla drugiej serii pomiarow [8bit/g]
a1aw1 = a1_3_3./Amp_wz_1;             %%charakterystyka statyczna czujnika dla pierwszej serii pomiarow [g/g]
a2aw2 = a2_3_3./Amp_wz_2;             %%charakterystyka statyczna czujnika dla drugiej serii pomiarow [g/g]


figure(1);
subplot(2,1,1);
plot(F_1,Amp_pom_1,'o',F_1,Amp_wz_1,'o');
grid on;
title({'odczytane pomiary, zasilanie VDD = 3.3V';'1 seria'});
xlabel('częstotliwość [Hz]');
ylabel('amplituda drgań');
legend('amplituda zmierzona [0-255]','amplituda zadana [g]');
subplot(2,1,2);
plot(F_1,Amp_pom_2,'o',F_2,Amp_wz_2,'o');
title("2 seria")
grid on;
xlabel('częstotliwość [Hz]');
ylabel('amplituda drgań');
legend('amplituda zmierzona [0-255]','amplituda zadana [g]');
saveas(gcf,'fig1.png');

figure(2);
subplot(2,1,1);
plot(F_1,a1_3_3,'o',F_1,Amp_wz_1,'o');
grid on;
title({'Amplituda drgań w zależności od częstotliwości, zasilanie VDD = 3.3V';'1 seria'});
xlabel('częstotliwość [Hz]');
ylabel('amplituda drgań [g]');
legend('amplituda przeliczona z akcelerometru','amplituda zadana');
subplot(2,1,2);
plot(F_2,a2_3_3,'o',F_2,Amp_wz_2,'o');
grid on;
title({'2 seria'});
xlabel('częstotliwość [Hz]');
ylabel('amplituda drgań [g]');
legend('amplituda przeliczona z akcelerometru','amplituda zadana');
saveas(gcf,'fig2.png');

figure(3);
subplot(2,1,1);
plot(F_1,ApAw1,'o');
grid on;
title({'charakterystyka statyczna czujnika, zasilanie VDD = 3.3V';'1 seria'});
xlabel('częstotliwość [Hz]');
ylabel('amplituda zmierzona/amplituda zadana [8-bit/g]');
hold on;
subplot(2,1,2);
plot(F_2,ApAw2,'o');
grid on;
title({'2 seria'});
xlabel('częstotliwość [Hz]');
ylabel('amplituda zmierzona/amplituda zadana [8-bit/g]');
saveas(gcf,'fig3.png');

figure(4);
subplot(2,1,1);
plot(F_1,a1aw1,'o');
grid on;
title({'charakterystyka statyczna czujnika, zasilanie VDD = 3.3V';'1 seria'});
xlabel('częstotliwość [Hz]');
ylabel('A zmierzona/A zadana');
hold on;
subplot(2,1,2);
plot(F_2,a2aw2,'o');
grid on;
title({'2 seria'});
xlabel('częstotliwość [Hz]');
ylabel('A zmierzona/A zadana');
saveas(gcf,'fig4.png');

