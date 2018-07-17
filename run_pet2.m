dirr='/data/obs/obs/gridded/terraclim/MAT/';
dirr2='/data/obs/obs/gridded/terraclim/MAT/';
%dirr2='/home/abatz/data/';
load /data/obs/obs/gridded/worldclim/worldclim lat lon
load /data/obs/obs/gridded/worldclim/worldelev el
P=1013.25*((293-0.0065*el)/293).^5.26;
ordir=pwd;

yy=[59:60];
for yyr=1:length(yy)
 yr=yy(yyr);
 load([dirr2,'vap_',num2str(yr+1957)]);
 load([dirr2,'tmax_',num2str(yr+1957)]);
 load([dirr2,'tmin_',num2str(yr+1957)]);
f=find(tmaxdata<tmindata);tmaxdata(f)=tmindata(f);
 cd /home/abatz/CALCULATIONS/
 vpn=calcVP(tmindata+273.15,repmat(P,[1 1 12]));
 vpx=calcVP(tmaxdata+273.15,repmat(P,[1 1 12]));
 vpn=vpn/1000;vpx=vpx/1000;
 vpd=vpn/2+vpx/2-vapdata;
 ff=find(vpd<0);vpd(ff)=0;
 clear vap vpx vpn clear vapdata
 load([dirr,'srad_',num2str(yr+1957)]);
 load([dirr,'ws_',num2str(yr+1957)]);
 tmaxdata=shiftdim(tmaxdata,2);
 tmindata=shiftdim(tmindata,2);
 winddata=shiftdim(winddata,2);
 sraddata=shiftdim(sraddata,2);
ft=find(isnan(sraddata));sraddata(ft)=0;
ft=find(isinf(sraddata));sraddata(ft)=0;
 vpd=shiftdim(vpd,2);
 petdata=NaN*ones(12,4320,8640);
 f=find(~isnan(tmaxdata(1,:))==1);
 vpd=vpd(:,f);
 tmaxdata=tmaxdata(:,f);
 tmindata=tmindata(:,f);
 sraddata=sraddata(:,f);
 winddata=winddata(:,f);
 tt=find(isnan(sraddata)==1);
 sraddata(tt)=0;
 [ET]=monthlyPETvpd(sraddata', tmaxdata',tmindata', winddata',lat(f)',el(f)',0.23,vpd');
 tmean=tmaxdata/2+tmindata/2;
 clear tmaxdata tmindata
MF=1-runsnow(tmean+273.15,1);
ET=ET.*MF';
 petdata(:,f)=ET';petdata=shiftdim(petdata,1);
petdata=single(petdata);
 save([dirr2,'pet_',num2str(yr+1957)],'-v7.3','petdata');
 clear *data ET
 yr
end

