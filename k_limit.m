function [out]=k_limit(in,vel)
if in>vel
    in=vel;
end
if in<-vel
    in=-vel;
end
out=in;
end