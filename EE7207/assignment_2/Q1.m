clc,clear;
fis = readfis('Q1_y.fis');
v = 0.5;
L = 2.5;
T = 0.1;
y_diff = [];
u_diff = [];
theta_diff = [];

theta = -140;
theta = deg2rad(theta);% 用弧度
x = 10;
y = -30 ;
t = 3000;

% u_value = evalfis(fis,[y,theta]);
% y = y + v*T*sind(theta);
% theta = theta + v*T*tand(u_value)/L;
% x = x + x*T*cosd(theta);
% y_diff = [y_diff,y];
% u_diff = [u_diff,u_value];
% theta_diff = [theta_diff,theta];

for i=1:t


    u_value = deg2rad(evalfis(fis,[ y,rad2deg(theta)]));
    
    theta = theta + v*T*tan(u_value)/L;
    x = x + x*T*cos(theta);
    y = y + v*T*sin(theta);
    y_diff = [y_diff,y];
    u_diff = [u_diff,u_value];
    theta_diff = [theta_diff,theta];
end

tt = 1:1:t;
figure(1);
plot(tt,u_diff(1:1:t),'LineWidth',1.5);
ylabel('u(t)','Fontname','Times New Roman')
xlabel('t','Fontname','Times New Roman')
title('Profile of input u(t) vs. time t',...
    'Fontname','Times New Roman')

figure(2);
plot(tt,theta_diff(1:1:t),'LineWidth',1.5);
ylabel('theta(t)','Fontname','Times New Roman')
xlabel('t','Fontname','Times New Roman')
title('Profile of output theta(t) vs. time t',...
    'Fontname','Times New Roman')

figure(3);
plot(tt,y_diff(1:1:t),'LineWidth',1.5);
ylabel('y(t)','Fontname','Times New Roman')
xlabel('t','Fontname','Times New Roman')
title('Profile of output y(t) vs. time t',...
    'Fontname','Times New Roman')