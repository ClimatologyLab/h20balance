function [out]=neighborpaint(in,miss);
% use average of 8 eightboring pixels
out=in;
parfor i=1:length(miss)
 fill(i)=filldata(in,miss(i));
end
out(miss)=fill;
nanmean(out(miss))


