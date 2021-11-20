v=0.5;
T=0.1;
L=2.5;

rtheta=zeros(30001,4);
ry=zeros(30001,4);
rx=zeros(30001,4);
ru=zeros(30001,4);

kpt=0.05;
kit=0.000;
kdt=0;

kpy=0.005;
kiy=0.0000;
kdy=0;

    theta=zeros(10001,1);y=zeros(10001,1);x=zeros(10001,1);u=zeros(10001,1);
    theta(1)=0; %%initial value
    y(1)=0;
    x(1)=0;

    theta(2)=-10*pi/180; %%initial value
    y(2)=10;
    x(2)=20;
    et=zeros(10001,1);
    ey=zeros(10001,1);
    for k=2:10000
        %pid
        et(k)=-theta(k);ey(k)=-y(k);
        det=et(k)-et(k-1);dey=ey(k)-ey(k-1);
        iet=0; iey=0;
        for i=1:k
            iet=iet+et(i);
            iey=iet+ey(i);
        end
        u(k)=kpt*et(k)+kit*iet+kdt*det+kpy*ey(k)+kiy*iey+kdy*dey;
        %pid
        if u(k)>=30*pi/180
            u(k)=30*pi/180;
        end
        if u(k)<=-30*pi/180
            u(k)=-30*pi/180;
        end
        %dynamic formula
        theta(k+1)=theta(k)+v*T*tan(u(k))/L;
        x(k+1)=x(k)+v*T*cos(theta(k));
        y(k+1)=y(k)+v*T*sin(theta(k));
        %dynamic formula
    end
t=10001
tt = 1:1:t;
figure(1);
plot(tt,u(1:1:t),'LineWidth',1.5);
ylabel('u(t)','Fontname','Times New Roman')
xlabel('t','Fontname','Times New Roman')
title('Profile of input u(t) vs. time t',...
    'Fontname','Times New Roman')

figure(2);
plot(tt,theta(1:1:t),'LineWidth',1.5);
ylabel('theta(t)','Fontname','Times New Roman')
xlabel('t','Fontname','Times New Roman')
title('Profile of output theta(t) vs. time t',...
    'Fontname','Times New Roman')

figure(3);
plot(tt,y(1:1:t),'LineWidth',1.5);
ylabel('y(t)','Fontname','Times New Roman')
xlabel('t','Fontname','Times New Roman')
title('Profile of output y(t) vs. time t',...
    'Fontname','Times New Roman')
