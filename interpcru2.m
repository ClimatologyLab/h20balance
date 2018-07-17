function interpcru(var);

switch var
case 1, n=ncread('/data/obs/obs/gridded/cru/cru_ts4.00.1901.2015.pre.dat.nc','pre');load scru_pranom
case 2, n=ncread('/data/obs/obs/gridded/cru/cru_ts4.00.1901.2015.vap.dat.nc','vap');load scru_vapanom
case 3, n=ncread('/data/obs/obs/gridded/cru/cru_ts4.00.1901.2015.tmx.dat.nc','tmx');load scru_txanom
case 4, n=ncread('/data/obs/obs/gridded/cru/cru_ts4.00.1901.2015.tmn.dat.nc','tmn');load scru_tnanom
end
n=reshape(permute(n,[2 1 3]),360,720,12,1380/12);
n=n(:,:,:,58:115);


lon=ncread('/data/obs/obs/gridded/cru/cru_ts4.00.1901.2015.tmn.dat.nc','lon');
lat=ncread('/data/obs/obs/gridded/cru/cru_ts4.00.1901.2015.tmn.dat.nc','lat');
nmean=mean(n(:,:,:,13:43),4);
if var==1
ff=find(nmean==0);
nmean(ff)=5;
end
if var<=2
n=n./repmat(nmean,[1 1 1 58]);
else
n=n-repmat(nmean,[1 1 1 58]);
end

mm=matfile('/root/WORLDCLIM/fillcru');
fillo=mm.fill;
fa=find(fillo==1);
f=find(fillo==0);
nn(:,:,f)=NaN;


for j=1:58
for i=1:12
sbad=find(ss(:,:,i,j)>0 & isnan(n(:,:,i,j)));
sbad=intersect(sbad,fa);
sa=double(n(:,:,i,j));
ss2=neighborpaint(sa,sbad);
newdata(:,:,i,j)=ss2;
end;
toc
end
[lon,lat]=meshgrid(lon,lat);
newdata=shiftdim(newdata,2);
ss=shiftdim(ss,2);

m=matfile('/data/obs/reanalysis/JRAmonthly19582015.mat');
mlat=m.lat;mlon=m.lon;
[mlon,mlat]=meshgrid(mlon,mlat);
switch var,
case 1, temp=m.pptmonth;
case 2, temp=m.spfmonth;
case 3, temp=m.tempmonth;
case 4, temp=m.tempmonth;
end

if var<=2
tm=nanmean(temp(:,:,:,13:43),4);
t1=find(tm<=0);tm(t1)=1e-5;
temp=temp./repmat(tm,[1 1 1 58]);
else
temp=temp-repmat(mean(temp(:,:,:,13:43),4),[1 1 1 58]);
end

% CRU has -180 to 180, so shift accordingly JRA

k=temp(:,1:144,:,:);temp(:,1:144,:,:)=temp(:,145:288,:,:);temp(:,145:288,:,:)=k;
k=mlon(:,1:144);mlon(:,1:144)=mlon(:,145:288);mlon(:,145:288)=k;
mlon(:,1:144)=mlon(:,1:144)-360;
mlon(:,289)=mlon(:,288)+1.25;
mlat(:,289)=mlat(:,288);
temp(:,289,:,:)=temp(:,288,:,:);

% interpolate JRA anomalies to CRU

for i=1:58
for j=1:12
o=interp2(mlon,mlat,temp(:,:,j,i),lon,lat);
%nn(j,i,f)=o(f);
ff=find(ss(j,i,:,:)==0);
newdata(j,i,ff)=o(ff);
end;
end

if var==1
ff=find(newdata(:)>20);
newdata(ff)=20;
end

nn=newdata;
switch var,
case 1, save ncru_pranom1 -v7.3 nn lon lat
case 2, save ncru_vapanom1 -v7.3 nn lon lat
case 3, save ncru_txanom1 -v7.3 nn lon lat
case 4, save ncru_tnanom1 -v7.3 nn lon lat
end
end
