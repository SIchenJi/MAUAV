function [Sum_e,El,u]=pid_loc(t,aim,vel,sum_e,el,k)
e=aim-vel;
Sum_e=sum_e+e*t;
% [e]=k_limit(e,plimit);
% [Sum_e]=k_limit(Sum_e,ilimit);
u=[e,Sum_e,(e-el)/t]*k;
El=e;
end