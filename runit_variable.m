function runit_variable(var);
load /data/obs/obs/gridded/worldclim/worldclim lat lon
dirr='/data/obs/obs/gridded/terraclim/MAT/';


m=matfile('/data/obs/reanalysis/JRA/JRAmonthly19582015.mat');
[mlon,mlat]=meshgrid(m.lon,m.lat);
k=mlon(:,1:144);mlon(:,1:144)=mlon(:,145:288);mlon(:,145:288)=k;
mlat(:,289)=mlat(:,288);
mlon(:,289)=180;
mlon(:,1:144)=mlon(:,1:144)-360;

if var==1 % srad
load /data/obs/obs/gridded/worldclim/worldclim srad 
m=matfile('/home/abatz/srad_reanalysis.mat');
wa=m.data1;
k=wa(:,1:144,:,:);wa(:,1:144,:,:)=wa(:,145:288,:,:);wa(:,145:288,:,:)=k;
wa=wa-repmat(mean(wa(:,:,:,13:31+12),4),[1 1 1 60]);
wa(:,289,:,:)=wa(:,288,:,:);
srad=srad/86.4;
for yr=1:60
for mo=1:12
sraddata(:,:,mo)=interp2(mlon,mlat,wa(:,:,mo,yr),lon,lat)+srad(:,:,mo);
end
sraddata=single(sraddata);
f=find(sraddata<0);sraddata(f)=0;
save([dirr,'srad_',num2str(yr+1957)],'-v7.3','sraddata');
clear sraddata
yr
end

end

if var==2
load /data/obs/obs/gridded/worldclim/worldclim wind 
m=matfile('/home/abatz/ws_reanalysis.mat');
wa=m.data1;
k=wa(:,1:144,:,:);wa(:,1:144,:,:)=wa(:,145:288,:,:);wa(:,145:288,:,:)=k;
wa=wa-repmat(mean(wa(:,:,:,13:31+12),4),[1 1 1 60]);
wa(:,289,:,:)=wa(:,288,:,:);
for yr=1:60
for mo=1:12
winddata(:,:,mo)=interp2(mlon,mlat,wa(:,:,mo,yr),lon,lat)+wind(:,:,mo);
end
winddata=single(winddata);
f=find(winddata<0);winddata(f)=0;
save([dirr,'ws_',num2str(yr+1957)],'-v7.3','winddata');
clear winddata
yr
end

end

