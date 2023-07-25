clc
clear
close all
%% 参数初始化
%变量初始化
m_B=4;
m_C=1;
m_S=m_B+m_C;
L=0.5;
H=0.01;
t=0.001;
g=9.8;
%% 被控量初始化
ol=[0;0;0];
w_ol=[0;0;0];
pg=[0;0;0];
vg=[0;0;0];
pg_S=[0;0;0];
vg_S=[0;0;0];
ph=[0;0;0];
vh=[0;0;0];
ah=[0;0;0];
R_b=eye(3);
R_w=eye(3);
G=g*m_S;
F1=G/2;
F2=F1;
%% 控制参数
%位置控制
c_pxy=3.1;        c_pz=4.5;
k_pxy=c_pxy;        k_pz=c_pz;
D_pxy=0.13;        D_pz=0.4;
e_p=[0;0;0];
temp_e_p=e_p;
de_p=e_p;
s_p=e_p;
Fg_aim=[0;0;0];
%姿态控制
c_olxy=2.9;            c_olz=4;
k_olxy=c_olxy;         k_olz=c_olz;
F_olxy=0.4;            F_olz=2;
h_olxy=2.3;            h_olz=3;
beta_olxy=0.1;         beta_olz=0.1;
z_ol=[0;0;0];
temp_z_ol=z_ol;
dz_ol=z_ol;
rho_ol=z_ol;
ddol_aim=z_ol;
ol_aim=z_ol;temp_ol_aim1=z_ol;temp_ol_aim2=z_ol;
%滑块控制
sum_eyc=0;
elyc=0;
sum_edyc=0;
eldyc=0;
sum_exc=0;
elxc=0;
sum_edxc=0;
eldxc=0;
%% 迭代
time=25;
show=zeros(23,time/t);
flag_c=1;
flag_tracking=1;
for i=3:time/t
    %% 动力学模型
    speed=0.5;
    rsize=1;
    p_aim=[rsize*sin(0.5*speed*i*t);rsize*sin(speed*i*t);0.1];
    ddp_aim=flag_c*[-0.25*rsize*speed^2*sin(0.5*speed*i*t);-rsize*speed^2*sin(speed*i*t);0];
%     rsize=0.3;
%     p_aim=[0;rsize*sin(0.5*speed*i*t);rsize*sin(speed*i*t)+0.4];
%     ddp_aim=flag_c*[0;-0.25*rsize*speed^2*sin(0.5*speed*i*t);-rsize*speed^2*sin(speed*i*t)];
    [ol,w_ol,vg,pg,vg_S,pg_S,R_b,R_w,vh,ph,mu]=math_mod(i,m_B,m_C,L,H,t,F1,F2,ah,vh,ph,ol,w_ol,pg,vg);
    if flag_tracking==1
        %% 位置控制——滑模控制
        temp_e_p=e_p;
        e_p=pg_S-p_aim;
        de_p=(e_p-temp_e_p)/t;
        s_p(1:2,1)=c_pxy*e_p(1:2,1)+de_p(1:2,1);
        s_p(3,1)=c_pz*e_p(3,1)+de_p(3,1);
        Fg_aim(1:2,1)=m_S*(-c_pxy*de_p(1:2,1)+ddp_aim(1:2,1)-D_pxy*tanh(s_p(1:2,1)))-k_pxy*s_p(1:2,1);
        Fg_aim(3,1)=m_S*(-c_pz*de_p(3,1)+ddp_aim(3,1)-D_pz*tanh(s_p(3,1)))-k_pz*s_p(3,1);
        temp_ol_aim1=temp_ol_aim2;temp_ol_aim2=ol_aim;
        ol_aim=[atan((sin(ol(3,1))*Fg_aim(1,1)-cos(ol(3,1))*Fg_aim(2,1))/m_S/g);...
                atan((cos(ol(3,1))*Fg_aim(1,1)+sin(ol(3,1))*Fg_aim(2,1))/m_S/g);0];
        ol_limit=0.7;
        ol_aim(1,1)=k_limit(ol_aim(1,1),ol_limit);
        ol_aim(2,1)=k_limit(ol_aim(2,1),ol_limit);
        ddol_aim=flag_c*(ol_aim+temp_ol_aim1-2*temp_ol_aim2)/t/t;
    else 
        ol_aim=0.61*[sin(i*t+pi/3);sin(i*t);sin(i*t-pi/3)];
        ddol_aim=-0.61*[sin(i*t+pi/3);sin(i*t);sin(i*t-pi/3)];

%         ol_aim=0.61*[sin(i*t+pi/3);sin(i*t);0];
%         ddol_aim=-0.61*[sin(i*t+pi/3);sin(i*t);0];
% 
%         ol_aim=0.61*tanh([sin(0.5*i*t);sin(0.5*i*t+pi/2);0]);
%         ddol_aim=0*[sin(i*t+pi/3);sin(i*t);sin(i*t-pi/3)];

%         ol_aim=1*[0;sin(i*t);0];
%         ddol_aim=1*[0;-sin(i*t);0];

%         ol_aim=1*([0;1;0]);
%         ddol_aim=0*([0;1;0]);
    end
    %% 姿态控制——反步滑膜控制
    temp_z_ol=z_ol;
    z_ol=ol-ol_aim;
    dz_ol=(z_ol-temp_z_ol)/t;
    rho_ol(1:2,1)=dz_ol(1:2,1)+(c_olxy+k_olxy)*z_ol(1:2,1);
    rho_ol(3,1)=dz_ol(3,1)+(c_olz+k_olz)*z_ol(3,1);
    LM_aim=0.0834*(-(c_olxy+k_olxy)*dz_ol(1:2,1)-F_olxy*tanh(rho_ol(1:2,1))+ddol_aim(1:2,1)-h_olxy*(rho_ol(1:2,1)+beta_olxy*tanh(rho_ol(1:2,1))));
    N_aim=0.5*0.1667*(-(c_olz+k_olz)*dz_ol(3,1)-F_olz*tanh(rho_ol(3,1))+ddol_aim(3,1)-h_olz*(rho_ol(3,1)+beta_olz*tanh(rho_ol(3,1))));
    F1=(Fg_aim(3,1)+G)*sec(ol(1,1))*sec(ol(2,1))/2+N_aim;
    F2=(Fg_aim(3,1)+G)*sec(ol(1,1))*sec(ol(2,1))/2-N_aim;
%     F1=(Fg_aim(3,1)+G)/2+N_aim;
%     F2=(Fg_aim(3,1)+G)/2-N_aim;
    rc_aim(1,1)=k_limit(LM_aim(2,1)/mu/(F1+F2),0.25);
    rc_aim(2,1)=k_limit(-LM_aim(1,1)/mu/(F1+F2),0.25);
    %rc
    krp=[6;0;1.5];krv=[6.3;0;0.01];
    %x
    [sum_exc,elxc,dxc_aim]=pid_loc(t,rc_aim(1,1),ph(1,1),sum_exc,elxc,krp);
    [sum_edxc,eldxc,ah(1,1)]=pid_loc(t,dxc_aim,vh(1,1),sum_edxc,eldxc,krv);
    %y
    [sum_eyc,elyc,dyc_aim]=pid_loc(t,rc_aim(2,1),ph(2,1),sum_eyc,elyc,krp);
    [sum_edyc,eldyc,ah(2,1)]=pid_loc(t,dyc_aim,vh(2,1),sum_edyc,eldyc,krv);
    %% 
    fprintf('秒,%f,位置,%f,%f,%f,姿态,%f,%f,%f,力1,%f,力2,%f\n',i*t,pg_S(1),pg_S(2),pg_S(3),ol(1),ol(2),ol(3),F1,F2)
    show(:,i)=[ol_aim;ol;ol_aim-ol;p_aim;pg_S;p_aim-pg_S;ph;norm(vh);norm(ah)];
    if abs(ol(1,1))>pi/2.25 || abs(ol(2,1))>pi/2.25
        break;
    end
end
%%
% figure(1)
% subplot(2,2,[1,2])
% plot((7:i)*t,show(2,7:i),'y','linewidth',2);hold on
% plot((7:i)*t,show(5,7:i),'-.r');hold on
% plot((7:i)*t,show(8,7:i),'b','linewidth',2);grid on
% legend('$\theta_d$','$\theta$','$e_\theta$','Interpreter', 'latex')
% ylabel('$\alpha/rad$','Interpreter', 'latex')
% xlabel('$t/s$','Interpreter', 'latex')
% subplot(2,2,3)
% plot((7:i)*t,-show(19,7:i));hold on
% grid on
% ylabel('$y_C/m$','Interpreter', 'latex')
% xlabel('$t/s$','Interpreter', 'latex')
% ylim([-0.05 0.05])
% subplot(2,2,4)
% plot((7:i)*t,-show(19,7:i));hold on
% grid on
% 
% ylim([-1e-3 2e-3])
% xlim([1.75 2.4])
figure(1)
subplot(3,1,1)
plot((7:i)*t,show(1,7:i),'y','linewidth',2);hold on
plot((7:i)*t,show(4,7:i),'-.r');hold on
plot((7:i)*t,show(7,7:i),'b','linewidth',2);grid on
legend('$\phi_d$','$\phi$','$e_\phi$','Interpreter', 'latex')
xlabel('$t/s$','Interpreter', 'latex')
ylabel('$\alpha/rad$','Interpreter', 'latex')
subplot(3,1,2)
plot((7:i)*t,show(2,7:i),'y','linewidth',2);hold on
plot((7:i)*t,show(5,7:i),'-.r');hold on
plot((7:i)*t,show(8,7:i),'b','linewidth',2);grid on
legend('$\theta_d$','$\theta$','$e_\theta$','Interpreter', 'latex')
xlabel('$t/s$','Interpreter', 'latex')
ylabel('$\alpha/rad$','Interpreter', 'latex')
subplot(3,1,3)
plot((7:i)*t,show(3,7:i),'y','linewidth',2);hold on
plot((7:i)*t,show(6,7:i),'-.r');hold on
plot((7:i)*t,show(9,7:i),'b','linewidth',2);grid on
legend('$\psi_d$','$\psi$','$e_\psi$','Interpreter', 'latex')
xlabel('$t/s$','Interpreter', 'latex')
ylabel('$\alpha/rad$','Interpreter', 'latex')

figure(2)
subplot(3,1,1)
plot((7:i)*t,show(10,7:i),'y','linewidth',2);hold on
plot((7:i)*t,show(13,7:i),'-.r');hold on
plot((7:i)*t,show(16,7:i),'b','linewidth',2);grid on
legend('X_d','X','e_X')
xlabel('t/s')
ylabel('X/m')
subplot(3,1,2)
plot((7:i)*t,show(11,7:i),'y','linewidth',2);hold on
plot((7:i)*t,show(14,7:i),'-.r');hold on
plot((7:i)*t,show(17,7:i),'b','linewidth',2);grid on
legend('Y_d','Y','e_Y')
xlabel('t/s')
ylabel('Y/m')
subplot(3,1,3)
plot((7:i)*t,show(12,7:i),'y','linewidth',2);hold on
plot((7:i)*t,show(15,7:i),'-.r');hold on
plot((7:i)*t,show(18,7:i),'b','linewidth',2);grid on
legend('Z_d','Z','e_Z')
xlabel('t/s')
ylabel('Z/m')

figure(3)
plot3(show(10,7:i),show(11,7:i),show(12,7:i),'y','linewidth',2);hold on
plot3(show(13,7:i),show(14,7:i),show(15,7:i));grid on
set(gca,'ZLim',[-0.05 0.15]);
f3xysize=1.2;
set(gca,'XLim',[-f3xysize f3xysize]);
set(gca,'YLim',[-f3xysize f3xysize]);
xlabel('X/m')
ylabel('Y/m')
zlabel('Z/m')
legend('P_d','P','Location','northwest')

figure(4)
subplot(1,2,1)
plot3(show(19,7:i),show(20,7:i),(7:i)*t,'--');hold on
plot3(show(19,2700:i),show(20,2700:i),(2700:i)*t);
grid on
xlabel('$x_C/m$','Interpreter', 'latex')
ylabel('$y_C/m$','Interpreter', 'latex')
zlabel('$t/s$','Interpreter', 'latex')
subplot(1,2,2)
plot(show(19,7:i),show(20,7:i),'--');hold on
plot(show(19,2700:i),show(20,2700:i))
grid on
xlim([-5e-3,7e-3])
ylim([-10e-3,8e-3])
xlabel('$x_C/m$','Interpreter', 'latex')
ylabel('$y_C/m$','Interpreter', 'latex')
legend('Aperiodic','Periodic')



