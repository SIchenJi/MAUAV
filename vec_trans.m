function [R_b]=vec_trans(ol_x,ol_y,ol_z)
%% 机体到惯性
Rx=[1 0 0;0 cos(ol_x) -sin(ol_x);0 sin(ol_x) cos(ol_x)];
Ry=[cos(ol_y) 0 sin(ol_y);0 1 0;-sin(ol_y) 0 cos(ol_y)];
Rz=[cos(ol_z) -sin(ol_z) 0;sin(ol_z) cos(ol_z) 0;0 0 1];
R_b=(Rz*Ry)*Rx;
end