close all
load('csm0.mat')
csm0=show;
load('csm4.mat')
csm4=show;
load('csm5.mat')
csm5=show;
load('csm6.mat')
csm6=show;
load('lqr0.mat')
lqr0=show;
load('lqr4.mat')
lqr4=show;
load('lqr5.mat')
lqr5=show;
load('lqr6.mat')
lqr6=show;
i=25000;
t=0.001;
%%
figure(1)

plot3(show(10,7:i),show(11,7:i),show(12,7:i),'--','linewidth',2);hold on
plot3(csm4(13,7:i),csm4(14,7:i),csm4(15,7:i),'linewidth',2);hold on
plot3(csm5(13,7:i),csm5(14,7:i),csm5(15,7:i),'linewidth',2);hold on
plot3(csm6(13,7:i),csm6(14,7:i),csm6(15,7:i),'linewidth',2);hold on
plot3(lqr4(13,7:i),lqr4(14,7:i),lqr4(15,7:i));hold on
plot3(lqr5(13,7:i),lqr5(14,7:i),lqr5(15,7:i));hold on
plot3(lqr6(13,7:i),lqr6(14,7:i),lqr6(15,7:i));grid on
set(gca,'ZLim',[-0.05 0.15]);
f3xysize=1.2;
set(gca,'XLim',[-f3xysize f3xysize]);
set(gca,'YLim',[-f3xysize f3xysize]);
xlabel('X/m')
ylabel('Y/m')
zlabel('Z/m')
legend('target trajectory','CSMC,18.9N/m^2','CSMC,40.0N/m^2','CSMC,72.9N/m^2',...
    'LQR,18.9N/m^2','LQR,40.0N/m^2','LQR,72.9N/m^2','Location','northoutside','NumColumns',2)

%%

ecsm0=show(10:12,7:i)-csm0(13:15,7:i);
ecsm4=show(10:12,7:i)-csm4(13:15,7:i);
ecsm5=show(10:12,7:i)-csm5(13:15,7:i);
ecsm6=show(10:12,7:i)-csm6(13:15,7:i);
elqr0=show(10:12,7:i)-lqr0(13:15,7:i);
elqr4=show(10:12,7:i)-lqr4(13:15,7:i);
elqr5=show(10:12,7:i)-lqr5(13:15,7:i);
elqr6=show(10:12,7:i)-lqr6(13:15,7:i);


Ecsm0=sqrt(ecsm0(1,:).^2+ecsm0(2,:).^2+ecsm0(3,:).^2);
Ecsm4=sqrt(ecsm4(1,:).^2+ecsm4(2,:).^2+ecsm4(3,:).^2);
Ecsm5=sqrt(ecsm5(1,:).^2+ecsm5(2,:).^2+ecsm5(3,:).^2);
Ecsm6=sqrt(ecsm6(1,:).^2+ecsm6(2,:).^2+ecsm6(3,:).^2);
Elqr0=sqrt(elqr0(1,:).^2+elqr0(2,:).^2+elqr0(3,:).^2);
Elqr4=sqrt(elqr4(1,:).^2+elqr4(2,:).^2+elqr4(3,:).^2);
Elqr5=sqrt(elqr5(1,:).^2+elqr5(2,:).^2+elqr5(3,:).^2);
Elqr6=sqrt(elqr6(1,:).^2+elqr6(2,:).^2+elqr6(3,:).^2);
figure(2)
plot(t*(7:i),Ecsm4,'linewidth',2);hold on
plot(t*(7:i),Ecsm5,'linewidth',2);hold on
plot(t*(7:i),Ecsm6,'linewidth',2);hold on
plot(t*(7:i),Elqr4,'linewidth',1);hold on
plot(t*(7:i),Elqr5,'linewidth',1);hold on
plot(t*(7:i),Elqr6,'linewidth',1);hold on
plot(t*(7:i),mean(Ecsm4)*ones(1,i-6),'--','linewidth',2);hold on
plot(t*(7:i),mean(Ecsm5)*ones(1,i-6),'--','linewidth',2);hold on
plot(t*(7:i),mean(Ecsm6)*ones(1,i-6),'--','linewidth',2);hold on
plot(t*(7:i),mean(Elqr4)*ones(1,i-6),'--');hold on
plot(t*(7:i),mean(Elqr5)*ones(1,i-6),'--');hold on
plot(t*(7:i),mean(Elqr6)*ones(1,i-6),'--');grid on
legend('Error curve of CSMC,18.9N/m^2','Error curve of CSMC,40.0N/m^2','Error curve of CSMC,72.9N/m^2',...
       'Error curve of LQR,18.9N/m^2','Error curve of LQR,40.0N/m^2','Error curve of LQR,72.9N/m^2',...
       'Average error of CSMC,18.9N/m^2','Average error of CSMC,40.0N/m^2','Average error of CSMC,72.9N/m^2',...
       'Average error of LQR,18.9N/m^2','Average error of LQR,40.0N/m^2','Average error of LQR,72.9N/m^2',...
       'Location','northoutside','NumColumns',2)
ylabel('error/m')
xlabel('t/s')
%%
figure(3)
subplot(2,3,1)
plot3(csm4(19,7:i),csm4(20,7:i),t*(7:i));grid on
xlabel('x_C/m')
ylabel('y_C/m')
zlabel('t/s')

subplot(2,3,2)
plot3(csm5(19,7:i),csm5(20,7:i),t*(7:i));grid on
xlabel('x_C/m')
ylabel('y_C/m')
zlabel('t/s')

subplot(2,3,3)
plot3(csm6(19,7:i),csm6(20,7:i),t*(7:i));grid on
xlabel('x_C/m')
ylabel('y_C/m')
zlabel('t/s')

subplot(2,3,4)
plot3(lqr4(19,7:i),lqr4(20,7:i),t*(7:i));grid on
xlabel('x_C/m')
ylabel('y_C/m')
zlabel('t/s')

subplot(2,3,5)
plot3(lqr5(19,7:i),lqr5(20,7:i),t*(7:i));grid on
xlabel('x_C/m')
ylabel('y_C/m')
zlabel('t/s')

subplot(2,3,6)
plot3(lqr6(19,7:i),lqr6(20,7:i),t*(7:i));grid on
xlabel('x_C/m')
ylabel('y_C/m')
zlabel('t/s')

figure(4)

plot3(show(10,7:i),show(11,7:i),show(12,7:i),'b','linewidth',0.5);hold on
plot3(csm0(13,7:i),csm0(14,7:i),csm0(15,7:i),'r','linewidth',1);hold on
plot3(lqr0(13,7:i),lqr0(14,7:i),lqr0(15,7:i),'--g','linewidth',2);grid on
legend('target trajectory',...
       'CMCC',...
       'LQR',...
       'Location','north','NumColumns',2)
xlabel('$X/m$', 'Interpreter', 'latex')
ylabel('$Y/m$', 'Interpreter', 'latex')
zlabel('$Z/m$', 'Interpreter', 'latex')

figure(5)
plot(t*(7:i),Ecsm0,'linewidth',2);hold on
plot(t*(7:i),Elqr0,'linewidth',1);grid on
legend('Error curve of CSMC',...
       'Error curve of LQR',...
       'Location','northoutside','NumColumns',2)
ylabel('$error/m$', 'Interpreter', 'latex')
xlabel('$t/s$', 'Interpreter', 'latex')
