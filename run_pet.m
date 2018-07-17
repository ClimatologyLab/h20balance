chunk=1044384;
dirr='/data/obs/obs/gridded/worldclim/';
load /data/obs/obs/gridded/worldclim/worldclim lat lon
load /data/obs/obs/gridded/worldclim/worldelev el
P=1013.25*((293-0.0065*el)/293).^5.26;
ordir=pwd;

yy=[2:29];
for yyr=1:length(yy)
 yr=yy(yyr);
 load([dirr,'vap_',num2str(yr+1957)]);
 load([dirr,'tmax_',num2str(yr+1957)]);
 load([dirr,'tmin_',num2str(yr+1957)]);
f=find(tmaxdata<tmindata);tmaxdata(f)=tmindata(f);
 cd /home/abatz/CALCULATIONS/
 vpn=calcVP(tmindata+273.15,repmat(P,[1 1 12]));
 vpx=calcVP(tmaxdata+273.15,repmat(P,[1 1 12]));
 vpn=vpn/1000;vpx=vpx/1000;
 vpd=vpn/2+vpx/2-vapdata;
 ff=find(vpd<0);vpd(ff)=0;
 clear vap vpx vpn clear vapdata
 load([dirr,'srada_',num2str(yr+1957)]);
 load([dirr,'windaaa_',num2str(yr+1957)]);
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
 parfor ii=1:12
 [ET(ii).data]=monthlyPETvpd(sraddata(:,1+chunk*(ii-1):chunk*ii)'/86.4, tmaxdata(:,1+chunk*(ii-1):chunk*ii)',tmindata(:,1+chunk*(ii-1):chunk*ii)', winddata(:,1+chunk*(ii-1):chunk*ii)',lat(f(1+chunk*(ii-1):chunk*ii))',el(f(1+chunk*(ii-1):chunk*ii))',0.23,vpd(:,1+chunk*(ii-1):chunk*ii)');
 end
 last4=chunk*12+1:chunk*12+4;
 eet=monthlyPETvpd(sraddata(:,last4)'/86.4, tmaxdata(:,last4)',tmindata(:,last4)', winddata(:,last4)',lat(f(last4))',el(f(last4))',0.23,vpd(:,last4)');
 for ii=1:12
 petdata(:,f(1+chunk*(ii-1):chunk*ii))=ET(ii).data';
 end
 petdata(:,f(last4))=eet';
 petdata=shiftdim(petdata,1);
 save([dirr,'pet_',num2str(yr+1957)],'-v7.3','petdata');
 clear *data ET
 yr
end



 parfor i=1:12
 [AET(i).data,DEF(i).data,RO(i).data,SNOW(i).data,SOIL(i).data]=simplehydromodelsnow_gridr(tmean(:,1+chunk*(i-1):chunk*i)',pptdata(:,1+chunk*(i-1):chunk*i)',petdata(:,1+chunk*(i-1):chunk*i)',soilt(f(1+chunk*(i-1):chunk*i)),soillast(f(1+chunk*(i-1):chunk*i))',snowlast(f(1+chunk*(i-1):chunk*i))');
 end
 last4=chunk*12+1:chunk*12+4;
 [aaet,ddef,rro,snoww,soill]=simplehydromodelsnow_gridr(tmean(:,last4)',pptdata(:,last4)',petdata(:,last4)',soilt(f(last4)),soillast(f(last4))',snowlast(f(last4))');

 clear petdata tmean pptdata
 aetdata=single(NaN*ones(12,4320,8640));defdata=aetdata;runoffdata=aetdata;snowdata=aetdata;soildata=aetdata;
 for i=1:12
   aetdata(:,f(1+chunk*(i-1):chunk*i))=AET(i).data';
   defdata(:,f(1+chunk*(i-1):chunk*i))=DEF(i).data';
   runoffdata(:,f(1+chunk*(i-1):chunk*i))=RO(i).data';
   snowdata(:,f(1+chunk*(i-1):chunk*i))=SNOW(i).data';
   soildata(:,f(1+chunk*(i-1):chunk*i))=SOIL(i).data';
 end

clear AET DEF RO SNOW SOIL

 aetdata(:,f(last4))=aaet';
 defdata(:,f(last4))=ddef';

