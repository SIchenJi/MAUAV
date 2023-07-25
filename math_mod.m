function [Ol,W_ol,Vg,Pg,Vg_S,Pg_S,R_B,R_w,Vh,Ph,mu]=math_mod(i,m_B,m_C,L,H,t,F1,F2,ah,vh,ph,ol,w_ol,pg,vg)
%旋转矩阵，机体到惯性
R_b=vec_trans(ol(1,1),ol(2,1),ol(3,1));
%角速度变换，欧拉到三轴
R_w=w_trans(ol(1,1),ol(2,1));
wb=R_w*w_ol;
%机体坐标合外力
m_S=m_B+m_C;
mu=m_C/m_S;
F=R_b'*[0;0;-9.8*m_S]+[0;0;F1+F2];
Fx=F(1,1);
Fy=F(2,1);
Fz=F(3,1);
%机体坐标速度位置
vb=R_b'*vg;
%滑块速度
Vh=vh+ah*t;
%滑块位置
Ph=ph+(Vh+vh)/2*t;
ph_max=L/6;
if (abs(Ph(1,1))>ph_max)
    Vh(1,1)=0;
    Ph(1,1)=sign(Ph(1,1))*ph_max;
end
if (abs(Ph(2,1))>ph_max)
    Vh(2,1)=0;
    Ph(2,1)=sign(Ph(2,1))*ph_max;
end
%质心
rc=mu*Ph;
%力矩,旋翼扭矩系数k
k=0.5;
Mb=cross(-rc,[0;0;F1+F2])+k*[0;0;F1-F2];
%惯性矩阵
[I,dI]=inet_mom(m_B,m_C,L,H,Ph,Vh,mu);
%% 角加速度
awb=angle_acc(wb(1,1),wb(2,1),wb(3,1),Mb(1,1),Mb(2,1),Mb(3,1),...
    I(1,1),I(2,2),I(3,3),-I(1,2),-I(1,3),-I(2,3),dI(1,1),dI(2,2),dI(3,3),-dI(1,2),-dI(1,3),-dI(2,3));
%%%%%%%%%%%%%%
% awb=awb+[0;1.0*sin(2*i*t);0];
%%%%%%%%%%%%%%
%% 线加速度
[accb]=line_acc(mu,m_S,Fx,Fy,Fz,vb(1,1),vb(2,1),vb(3,1),wb(1,1),wb(2,1),wb(3,1),awb(1,1),awb(2,1),awb(3,1),ah,Vh,Ph);
%% 角速度，欧拉
Wb=wb+awb*t;
W_ol=R_w\Wb;
Ol=ol+(w_ol+W_ol)/2*t;
R_B=vec_trans(Ol(1,1),Ol(2,1),Ol(3,1));
%% 线速度，坐标
Vb=vb+accb*t;
Vg=R_b*Vb;
%%%%%%%%%%
% Vg=Vg+[0.5*sign(1.5*sin(2*i*t))*t;0;0];
% Vg=Vg+[0.729*sin(1*i*t)*t;0;0];%6级阵风0.729；5级风0.4；4级风0.189
% Vg=Vg+[0.74*t;0;0];
%%%%%%%%%%
Vg_S=Vg+mu*R_b*(Vh+cross(Wb,Ph));
Pg=pg+(vg+Vg)/2*t;
Pg_S=Pg+mu*R_b*Ph;
end