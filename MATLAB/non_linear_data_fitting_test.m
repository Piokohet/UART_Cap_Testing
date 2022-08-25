clear all; close all; clc;

Datax = ...
  [13,02
11,97
11,26
10,57
9,9
9,25
8,66
8,15
7,65
7,29
6,9
6,56
6,22
6,04
5,85
5,57
5,41
5,19
5,08
4,85
4,75
4,65
4,52
4,4
4,25
4,3
4,2
4,16
4,68
4
];

t = F_1(:,1);
y = a1aw1(:,1);
% axis([0 2 -0.5 6])
% hold on
plot(t,y,'ro')
title('Data points')

F = @(x,xdata)x(1)*exp(-x(2)*xdata) + x(3)*exp(x(4)*xdata);
x0 = [1 1 1 1];
[x,resnorm,~,exitflag,output] = lsqcurvefit(F,x0,t,y)

hold on
plot(t,F(x,t))
hold off

Fsumsquares = @(x)sum((F(x,t) - y).^2);
opts = optimoptions('fminunc','Algorithm','quasi-newton');
[xunc,ressquared,eflag,outputu] = fminunc(Fsumsquares,x0,opts)

fprintf(['There were %d iterations using fminunc,' ...
    ' and %d using lsqcurvefit.\n'], ...
    outputu.iterations,output.iterations)

fprintf(['There were %d function evaluations using fminunc,' ...
    ' and %d using lsqcurvefit.'], ...
    outputu.funcCount,output.funcCount)

x0bad = [5 1 1 0];
[xbad,resnormbad,~,exitflagbad,outputbad] = lsqcurvefit(F,x0bad,t,y)

hold on
plot(t,F(xbad,t),'g')
legend('Data','Global fit','Bad local fit','Location','NE')
hold off