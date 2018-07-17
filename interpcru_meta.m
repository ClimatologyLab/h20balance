function interpcru(var);

switch var
case 1, stn=ncread('/data/obs/obs/gridded/cru/cru_ts4.00.1901.2015.pre.dat.nc','stn');
case 2, stn=ncread('/data/obs/obs/gridded/cru/cru_ts4.00.1901.2015.vap.dat.nc','stn');
case 3, stn=ncread('/data/obs/obs/gridded/cru/cru_ts4.00.1901.2015.tmp.dat.nc','stn');
case 4, stn=ncread('/data/obs/obs/gridded/cru/cru_ts4.00.1901.2015.tmn.dat.nc','stn');
end

stn=reshape(permute(stn,[2 1 3]),360,720,12,1380/12);
stn=stn(:,:,:,58:115);
f=find(stn==-999);stn(f)=0;

mm=matfile('/root/WORLDCLIM/fillcru');
fillo=mm.fill;
f=find(fillo==1);


for j=1:58
for i=1:12
sbad=find(stn(:,:,i,j)==0);
sbad=intersect(sbad,f);ll=find(stn(:,:,i,j)==0);
sa=double(stn(:,:,i,j));sa(ll)=NaN;
ss2=neighborpaint(sa,sbad);
ff=find(isnan(ss2)==1);ss2(ff)=0;
ss(:,:,i,j)=int8(ss2);
end;
end


switch var,
case 1, save scru_pranom -v7.3 ss
case 2, save scru_vapanom -v7.3 ss
case 3, save scru_txanom -v7.3 ss
case 4, save scru_tnanom -v7.3 ss
end
end
