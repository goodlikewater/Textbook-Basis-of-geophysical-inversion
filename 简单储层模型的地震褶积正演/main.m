clear all
n=5000;
dx=50;
dt=0.002;
nl=3;
m=80;
v0=[1000 1500 2000 2500];
v1=[1000 1500 1300 2500];
v2=[1000 1500 2000 2500];
h(1,1)=800;
h(2,1)=1200;
h(3,1)=1800; %该模型为各层平行，无倾角
xmax=(m/2+1)*dx;
ymax=n*dt; %坐标范围
p=2; %图像中显示数字

%以下部分为子波采样
a0=200;f=20;nw=60;b=30; %子波参数
tt=0:dt:(nw-1)*dt;
wb=a0*sin(2*pi*f*tt).*exp(-b*tt); %视速度
hva0=h(3,:).*v0(1:nl);
hvb0=h(3,:)./v0(1:nl);
hva1=h(3,:).*v1(1:nl);
hvb1=h(3,:)./v1(1:nl);
hva2=h(3,:).*v2(1:nl);
hvb2=h(3,:)./v2(1:nl);

for i=2:nl
    hva0(i)=hva0(i)+hva0(i-1);
    hvb0(i)=hvb0(i)+hvb0(i-1);
    hva1(i)=hva1(i)+hva1(i-1);
    hvb1(i)=hvb1(i)+hvb1(i-1);
    hva2(i)=hva2(i)+hva2(i-1);
    hvb2(i)=hvb2(i)+hvb2(i-1);
end

hva0=sqrt(hva0./hvb0);
hva1=sqrt(hva1./hvb1);
hva2=sqrt(hva2./hvb2);
hva0(1)=v0(1);
hva1(1)=v1(1);
hva2(1)=v2(1);

for i=1:nl %设定反射面深度
    for j=2:m
        h(i,j)=h(i,j-1);
    end
end

mk=round(m/2); %炮检距

for i=1:nl %反射系数
    r0(i)=3*(v0(i+1)-v0(i))/(v0(i+1)+v0(i));
    r1(i)=3*(v1(i+1)-v1(i))/(v1(i+1)+v1(i));
    r2(i)=3*(v2(i+1)-v2(i))/(v2(i+1)+v2(i));
end
x=zeros(n,m);b=pi/180; % 划分网隔

for i=1:nl %一次反射波
    for j=1:80
        if j<=30
            z=2*h(i,j)/hva0(i);
            t=round(z/dt);
            x(t,j)=x(t,j)+r0(i);
        elseif j>30 && j<=50
            z=2*h(i,j)/hva1(i);
            t=round(z/dt);
            x(t,j)=x(t,j)+r1(i);
        else
            z=2*h(i,j)/hva2(i);
            t=round(z/dt);
            x(t,j)=x(t,j)+r2(i);
        end
    end
end

figure(1); %褶积处理及道集成像
record=zeros(n+nw-1,m);
xx=(0:(n+nw-2))*dt;
for i=1:m
    record(:,i)=conv(x(:,i),wb)+(i-mk)*dx;
    plot(record(:,i),xx,'b');
    hold on;
end
axis([-xmax,xmax,0,ymax ]);axis ij;
ylabel('时间/s');
xlabel('距离/m');
