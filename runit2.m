load /data/obs/obs/gridded/worldclim/worldclim prec lon lat

dirr='/home/abatz/data/';%/data/obs/obs/gridded/worldclim/';
m=matfile('ncru_pranom1');
mlat=m.lat;mlon=m.lon;
wa=shiftdim(m.nn(:,1:58,:,:),2);
wa(:,719,:,:)=wa(:,718,:,:);
wa(:,720,:,:)=wa(:,718,:,:);
wa(2:361,:,:,:)=wa;
wa(:,2:721,:,:)=wa;
wa(:,722,:,:)=wa(:,721,:,:);
mlon(2:361,:)=mlon;
mlat(2:361,:)=mlat;
mlat(1,:)=-89.75-.5;
mlat(:,2:721)=mlat;mlat(:,722)=mlat(:,721);
mlon(:,2:721)=mlon;mlon(:,722)=mlon(:,721)+0.5;
mlon(:,1)=mlon(:,1)-0.5;;
for yr=1:58
for mo=1:12
pptdata(:,:,mo)=interp2(mlon,mlat,wa(:,:,mo,yr),lon,lat).*prec(:,:,mo);
end
pptdata=single(pptdata);
save([dirr,'ppt_',num2str(yr+1957)],'-v7.3','pptdata');
clear pptdata
yr
end



m=matfile('ncru_vapanom1');
wa=shiftdim(m.nn(:,1:58,:,:),2);
wa(:,719,:,:)=wa(:,718,:,:);
wa(:,720,:,:)=wa(:,718,:,:);
wa(2:361,:,:,:)=wa;
wa(:,2:721,:,:)=wa;
wa(:,722,:,:)=wa(:,721,:,:);

load /data/obs/obs/gridded/worldclim/worldclim vapr

for yr=1:58
for mo=1:12
vapdata(:,:,mo)=interp2(mlon,mlat,wa(:,:,mo,yr),lon,lat).*vapr(:,:,mo);
end
vapdata=single(vapdata);
save([dirr,'vap_',num2str(yr+1957)],'-v7.3','vapdata');
clear vapdata
yr
end


clear;
runit2_tmaxtmin
