close all
clear
clc
a = 2;
b = 0.1;
N = 1024;
t = linspace(0,10,N);
x = b.^(a*abs(t));
figure(1)
plot(t,x);
axis([0 10 -1.2 1.2])
xlabel('t'); ylabel('x(t)');