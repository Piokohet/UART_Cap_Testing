clc;
m1 = 5;
m2 = 5;
k1= 1500;
k2 = 1500;
m = [m1 0; 0 m2];
k = [(k1 + k2) -k2; -k2 k2];
eigsort(k,m);
function [u,wn]=eigsort(k,m)
Omega=sqrt(eig(k,m));
[vtem,~]=eig(k,m);
[wn,isort]=sort(Omega);
il=length(wn);
for i=1:il
v(:,i)=vtem(:,isort(i));
end
disp("The natural frequencies are (rad/sec)")
wn
disp("\nThe eigenvectors of the system are")
v
disp("Ratios of eigenvectors are:\n")
A1_A2_1 = v(1,1)/v(2,1)
A1_A2_2 = v(1,2)/v(2,2)
figure(1)
plot([0,1,2,3], [0,A1_A2_1,1,0],'b-s', 'LineWidth',2, 'MarkerSize',10);
hold on;
plot([0,1,2,3], [0,-A1_A2_2,-1,0],'r-s', 'LineWidth',2, 'MarkerSize',10);
hold off; ylabel('Eigen Vector Ratio'); xlabel('Mass Number'); xticks([1 2]);
legend('Mode 1', 'Mode 2')
end