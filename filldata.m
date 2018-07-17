function [out]=filldata(data,index);
x=ceil(index/360);
y=mod(index,360);if y==0 y=360;end

if x==1
 xrange=[1:2 720];
end
if x==720 xrange=[1 719:720];end
if x>1 & x<720 xrange=x-1:x+1;end

if y==1 yrange=1:2;end
if y==360 yrange=359:360;end
if y>1 & y<360 yrange=y-1:y+1;end

data=data(yrange,xrange);
out=nanmean(data(:));

