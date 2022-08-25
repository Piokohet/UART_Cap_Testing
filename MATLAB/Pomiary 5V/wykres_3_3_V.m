f = pomiar(:,1);
wzbudnik = pomiar(:,2);
czujnik = pomiar(:,3);

subplot(211)
plot(f,wzbudnik)
yyaxis right
plot(f,czujnik)
yyaxis left
legend({'wzbudnik','czujnik'})
subplot(2,1,2)
plot(f,czujnik./wzbudnik)
title('charakterystyka statyczna czujnika przyspieszen')