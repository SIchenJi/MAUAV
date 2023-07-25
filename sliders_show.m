close all

d_all=zeros(3,size(show,2));
ph_all=zeros(6,size(show,2));
for i=1:size(show,2)
d_all(:,i)=find_di(0.25,0.01,0.01,1/3,show(19,i),show(20,i),0);
ph_all(:,i)=mass_position(d_all(1,i),d_all(2,i),d_all(3,i),0.25,0.01,0.01);
end
for n=1:361
    theta=n/180*pi;
    band_x(n)=0.25*cos(theta);
    band_y(n)=0.25*sin(theta);
end

figure(1)
plot3(show(19,7:i),show(20,7:i),(7:i)*t);hold on
plot3(ph_all(1,7:i),ph_all(2,7:i),(7:i)*t);hold on
plot3(ph_all(3,7:i),ph_all(4,7:i),(7:i)*t);hold on
plot3(ph_all(5,7:i),ph_all(6,7:i),(7:i)*t);grid on
xlabel('x_C/m')
ylabel('y_C/m')
zlabel('t/s')

%%
figure(2)
load('d_csmc0.mat')
d_csmc0=d_all;
load('d_lqr0.mat')
d_lqr0=d_all;
subplot(3,1,1)
plot((7:i)*t,0.25*d_csmc0(1,7:i),'linewidth',2);hold on
plot((7:i)*t,0.25*d_lqr0(1,7:i));grid on
legend('CSMC','LQR')
ylabel('$p_1/m$', 'Interpreter', 'latex')
xlabel('$t/s$', 'Interpreter', 'latex')
subplot(3,1,2)
plot((7:i)*t,0.25*d_csmc0(2,7:i),'linewidth',2);hold on
plot((7:i)*t,0.25*d_lqr0(2,7:i));grid on
legend('CSMC','LQR')
ylabel('$p_2/m$', 'Interpreter', 'latex')
xlabel('$t/s$', 'Interpreter', 'latex')
subplot(3,1,3)
plot((7:i)*t,0.25*d_csmc0(3,7:i),'linewidth',2);hold on
plot((7:i)*t,0.25*d_lqr0(3,7:i));grid on
legend('CSMC','LQR')
ylabel('$p_3/m$', 'Interpreter', 'latex')
xlabel('$t/s$', 'Interpreter', 'latex')
%%
figure(3)
xlabel('X轴');
ylabel('Y轴');
box on;
axis manual
axis equal;
axis([-0.27,0.27,-0.27,0.27]);
pause(0.001);
mass_cent=line(NaN,NaN,'marker','o','linesty','none','erasemode','none','color','r');
mass_track=line(NaN,NaN,'marker','none','linesty','-','erasemode','none','color','0.7 0.3 0.3');
hp1=line(NaN,NaN,'marker','o','erasemode','none','color','b');
hp2=line(NaN,NaN,'marker','o','erasemode','none','color','b');
hp3=line(NaN,NaN,'marker','o','erasemode','none','color','b');
hp1_track=line(NaN,NaN,'marker','none','linesty','-','erasemode','none','color','[0.3 0.3 0.7]');
hp2_track=line(NaN,NaN,'marker','none','linesty','-','erasemode','none','color','[0.3 0.3 0.7]');
hp3_track=line(NaN,NaN,'marker','none','linesty','-','erasemode','none','color','[0.3 0.3 0.7]');
band=line(NaN,NaN,'marker','none','linesty','--','erasemode','none','color','1 0 1');

for i=1:100:size(show,2)
    set(band,'xdata',band_x,'ydata',band_y);
    set(mass_track,'xdata',show(19,1:i),'ydata',show(20,1:i));
    set(mass_cent,'xdata',show(19,i),'ydata',show(20,i));
    set(hp1_track,'xdata',ph_all(1,1:i),'ydata',ph_all(2,1:i));
    set(hp2_track,'xdata',ph_all(3,1:i),'ydata',ph_all(4,1:i));
    set(hp3_track,'xdata',ph_all(5,1:i),'ydata',ph_all(6,1:i));
    set(hp1,'xdata',ph_all(1,i),'ydata',ph_all(2,i));
    set(hp2,'xdata',ph_all(3,i),'ydata',ph_all(4,i));
    set(hp3,'xdata',ph_all(5,i),'ydata',ph_all(6,i));
 
    pause(0.001);
    frame=getframe(gcf);
    imind=frame2im(frame);
    [imind,cm] = rgb2ind(imind,256);
    if i==1
         imwrite(imind,cm,'test.gif','gif', 'Loopcount',inf,'DelayTime',1e-4);
    else
         imwrite(imind,cm,'test.gif','gif','WriteMode','append','DelayTime',1e-4);
    end
end
