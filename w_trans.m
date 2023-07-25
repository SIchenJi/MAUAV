function [R_w]=w_trans(ol_x,ol_y)
%% 欧拉角到三轴角
R_w=[1 0 -sin(ol_y);0 cos(ol_x) sin(ol_x)*cos(ol_y);0 -sin(ol_x) cos(ol_x)*cos(ol_y)];
end