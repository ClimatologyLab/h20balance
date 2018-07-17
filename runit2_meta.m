load ../worldclim prec lon lat

dirr='/home/abatz/data/';%/data/obs/obs/gridded/worldclim/';
m=matfile('scru_pranom');
wa=m.ss;
m=matfile('ncru_pranom1');
mlat=m.lat;mlon=m.lon;
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
metadata(:,:,mo)=interp2(mlon,mlat,wa(:,:,mo,yr),lon,lat,'nearest');
end
save([dirr,'pptmeta_',num2str(yr+1957)],'-v7.3','metadata');
clear metadata
yr
end


m=matfile('scru_vapanom');
wa=m.ss;
wa(:,719,:,:)=wa(:,718,:,:);
wa(:,720,:,:)=wa(:,718,:,:);
wa(2:361,:,:,:)=wa;
wa(:,2:721,:,:)=wa;
wa(:,722,:,:)=wa(:,721,:,:);

for yr=1:58
for mo=1:12
metadata(:,:,mo)=interp2(mlon,mlat,wa(:,:,mo,yr),lon,lat,'nearest');
end
save([dirr,'vapmeta_',num2str(yr+1957)],'-v7.3','metadata');
clear metadata
yr
end

m=matfile('scru_txanom');
wa=m.ss;
wa(:,719,:,:)=wa(:,718,:,:);
wa(:,720,:,:)=wa(:,718,:,:);
wa(2:361,:,:,:)=wa;
wa(:,2:721,:,:)=wa;
wa(:,722,:,:)=wa(:,721,:,:);

for yr=1:58
for mo=1:12
metadata(:,:,mo)=interp2(mlon,mlat,wa(:,:,mo,yr),lon,lat,'nearest');
end
save([dirr,'tmaxmeta_',num2str(yr+1957)],'-v7.3','metadata');
clear metadata
yr
end

m=matfile('scru_tnanom');
wa=m.ss;
wa(:,719,:,:)=wa(:,718,:,:);
wa(:,720,:,:)=wa(:,718,:,:);
wa(2:361,:,:,:)=wa;
wa(:,2:721,:,:)=wa;
wa(:,722,:,:)=wa(:,721,:,:);

for yr=1:58
for mo=1:12
metadata(:,:,mo)=interp2(mlon,mlat,wa(:,:,mo,yr),lon,lat,'nearest');
end
save([dirr,'tminmeta_',num2str(yr+1957)],'-v7.3','metadata');
clear metadata
yr
end

