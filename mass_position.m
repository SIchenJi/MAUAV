function [ph_ALL]=mass_position(d1,d2,d3,r1,r2,h)
p1=[(r1-r2)*d1+r2;0;h*d1-h/2];
p2=[-1/2*((r1-r2)*d2+r2);sqrt(3)/2*((r1-r2)*d2+r2);h*d2-h/2];
p3=[-1/2*((r1-r2)*d3+r2);-sqrt(3)/2*((r1-r2)*d3+r2);h*d3-h/2];
ph_ALL=[p1(1:2,:);p2(1:2,:);p3(1:2,:)];
end