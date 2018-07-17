load /data/obs/obs/gridded/worldclim/worldclim lat lon
dirr='/data/obs/obs/gridded/terraclim/MAT/';
m=matfile('/data/obs/reanalysis/JRAmonthly19582015.mat');
[mlon,mlat]=meshgrid(m.lon,m.lat);
k=mlon(:,1:144);mlon(:,1:144)=mlon(:,145:288);mlon(:,145:288)=k;
mlat(:,289)=mlat(:,288);
mlon(:,289)=180;
mlon(:,1:144)=mlon(:,1:144)-360;

isgood=0;

if isgood

load /data/obs/obs/gridded/worldclim/worldclim srad 
wa=m.sradmonth;
k=wa(:,1:144,:,:);wa(:,1:144,:,:)=wa(:,145:288,:,:);wa(:,145:288,:,:)=k;
wa=wa-repmat(mean(wa(:,:,:,13:31+12),4),[1 1 1 60]);
wa(:,289,:,:)=wa(:,288,:,:);
srad=srad/86.4;
for yr=59:60
for mo=1:12
sraddata(:,:,mo)=interp2(mlon,mlat,wa(:,:,mo,yr),lon,lat)+srad(:,:,mo);
end
sraddata=single(sraddata);
f=find(sraddata<0);sraddata(f)=0;
save([dirr,'srada_',num2str(yr+1957)],'-v7.3','sraddata');
clear sraddata
yr
end


load /data/obs/obs/gridded/worldclim/worldclim wind
wa=m.wsmonth;
k=wa(:,1:144,:,:);wa(:,1:144,:,:)=wa(:,145:288,:,:);wa(:,145:288,:,:)=k;
wa=wa-repmat(mean(wa(:,:,:,13:31+12),4),[1 1 1 60]);
wa(:,289,:,:)=wa(:,288,:,:);
for yr=59:60
for mo=1:12
winddata(:,:,mo)=interp2(mlon,mlat,wa(:,:,mo,yr),lon,lat)+wind(:,:,mo);
end
f=find(winddata<0);winddata(f)=0;
winddata=single(winddata);
save([dirr,'windaaa_',num2str(yr+1957)],'-v7.3','winddata');
clear winddata
yr
end
end

load /data/obs/obs/gridded/worldclim/worldclim prec
wa=m.pptmonth;
k=wa(:,1:144,:,:);wa(:,1:144,:,:)=wa(:,145:288,:,:);wa(:,145:288,:,:)=k;
wa=wa./repmat(mean(wa(:,:,:,13:31+12),4),[1 1 1 60]);
wa(:,289,:,:)=wa(:,288,:,:);
ff=find(isnan(wa)==1);wa(ff)=0;
oo=find(wa>10);wa(oo)=10;
for yr=59:60
for mo=1:12
pptdata(:,:,mo)=interp2(mlon,mlat,wa(:,:,mo,yr),lon,lat).*prec(:,:,mo);
end
f=find(pptdata<0);pptdata(f)=0;
pptdata=single(pptdata);
save([dirr,'ppt2_',num2str(yr+1957)],'-v7.3','pptdata');
clear pptdata
yr
end

load /data/obs/obs/gridded/worldclim/worldclim vapr
wa=m.spfmonth;
k=wa(:,1:144,:,:);wa(:,1:144,:,:)=wa(:,145:288,:,:);wa(:,145:288,:,:)=k;
wa=wa./repmat(mean(wa(:,:,:,13:31+12),4),[1 1 1 60]);
wa(:,289,:,:)=wa(:,288,:,:);
for yr=59:60
for mo=1:12
vapdata(:,:,mo)=interp2(mlon,mlat,wa(:,:,mo,yr),lon,lat).*vapr(:,:,mo);
end
f=find(vapdata<0);vapdata(f)=0;
vapdata=single(vapdata);
save([dirr,'vap_',num2str(yr+1957)],'-v7.3','vapdata');
clear vapdata
yr
end

load /data/obs/obs/gridded/worldclim/worldclimtmaxtmin tmaxa tmina
wa=m.tempmonth;
k=wa(:,1:144,:,:);wa(:,1:144,:,:)=wa(:,145:288,:,:);wa(:,145:288,:,:)=k;
wa=wa-repmat(mean(wa(:,:,:,13:31+12),4),[1 1 1 60]);
wa(:,289,:,:)=wa(:,288,:,:);
for yr=59:60
for mo=1:12
tmaxdata(:,:,mo)=interp2(mlon,mlat,wa(:,:,mo,yr),lon,lat)+tmaxa(:,:,mo);
tmindata(:,:,mo)=interp2(mlon,mlat,wa(:,:,mo,yr),lon,lat)+tmina(:,:,mo);
end
tmaxdata=single(tmaxdata);
tmindata=single(tmindata);
save([dirr,'tmax_',num2str(yr+1957)],'-v7.3','tmaxdata');
save([dirr,'tmin_',num2str(yr+1957)],'-v7.3','tmindata');
clear tmaxdata tmindata
yr
end

