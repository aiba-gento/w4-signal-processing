close all
clear
clc
a = 1;
omega = 2*pi;
N = 1024;
t = linspace(0,10,N);
x = exp(-a*t).*sin(omega*t);
figure(1)
plot(t,x);
axis([0 10 -1.2 1.2])
xlabel('t'); ylabel('x(t)');