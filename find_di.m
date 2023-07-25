function [d]=find_di(r1,r2,h,miu,x,y,z)
d1=(4*h*x+2*r1*z-2*r2*z+3*h*miu*r1-3*h*miu*r2)/(6*h*miu*(r1-r2));
d2=(3^(1/2)*(6*h*y-2*3^(1/2)*h*x+2*3^(1/2)*r1*z-2*3^(1/2)*r2*z+3*3^(1/2)*h*miu*r1-3*3^(1/2)*h*miu*r2))/(18*h*miu*(r1-r2));
d3=-(2*h*x-2*r1*z+2*r2*z+2*3^(1/2)*h*y-3*h*miu*r1+3*h*miu*r2)/(6*h*miu*(r1-r2));
d=[d1;d2;d3];
end