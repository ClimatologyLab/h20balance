load /data/obs/obs/gridded/worldclim/worldclim lat lon
load /data/obs/obs/gridded/worldclim/worldclimtmaxtmin tmaxa

%dirr='/data/obs/obs/gridded/worldclim/';
dirr='/home/abatz/data/';
m=matfile('ncru_txanom1');
wa=shiftdim(m.nn(:,1:58,:,:),2);
wa(:,719,:,:)=wa(:,718,:,:);
wa(:,720,:,:)=wa(:,718,:,:);
wa(2:361,:,:,:)=wa;
wa(:,2:721,:,:)=wa;
wa(:,722,:,:)=wa(:,721,:,:);
mlat=m.lat;mlon=m.lon;
mlon(2:361,:)=mlon;
mlat(2:361,:)=mlat;
mlat(1,:)=-89.75-.5;
mlat(:,2:721)=mlat;mlat(:,722)=mlat(:,721);
mlon(:,2:721)=mlon;mlon(:,722)=mlon(:,721)+0.5;
mlon(:,1)=mlon(:,1)-0.5;;
for yr=1:58
for mo=1:12
tmaxdata(:,:,mo)=interp2(mlon,mlat,wa(:,:,mo,yr),lon,lat)+tmaxa(:,:,mo);
end
tmaxdata=single(tmaxdata);
save([dirr,'tmaxa_',num2str(yr+1957)],'-v7.3','tmaxdata');
clear tmaxdata
yr
end

clear tmax*

load /data/obs/obs/gridded/worldclim/worldclimtmaxtmin tmina        

m=matfile('ncru_tnanom1');
wa=shiftdim(m.nn(:,1:58,:,:),2);
wa(:,719,:,:)=wa(:,718,:,:);
wa(:,720,:,:)=wa(:,718,:,:);
wa(2:361,:,:,:)=wa;
wa(:,2:721,:,:)=wa;
wa(:,722,:,:)=wa(:,721,:,:);
mlat=m.lat;mlon=m.lon;
mlon(2:361,:)=mlon;
mlat(2:361,:)=mlat;
mlat(1,:)=-89.75-.5;
mlat(:,2:721)=mlat;mlat(:,722)=mlat(:,721);
mlon(:,2:721)=mlon;mlon(:,722)=mlon(:,721)+0.5;
mlon(:,1)=mlon(:,1)-0.5;;
for yr=1:58
for mo=1:12
tmindata(:,:,mo)=interp2(mlon,mlat,wa(:,:,mo,yr),lon,lat)+tmina(:,:,mo);
end
tmindata=single(tmindata);

% must check tmax>tmin
load([dirr,'tmaxa_',num2str(yr+1957)]);
f=find(tmaxdata+.5<tmindata);
tmindata(f)=tmaxdata(f)-.5;
save([dirr,'tmina_',num2str(yr+1957)],'-v7.3','tmindata');
clear tmindata tmaxdata
yr
end

clear

cd /root/WORLDCLIM/CLEANCODE/
run_pet2
