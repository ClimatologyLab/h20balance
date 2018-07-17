load ../worldclimsoil2;
soillast(1,:)=soilt(:);
snowlast(1,:)=0*soillast;
soilt=single(soilt);
chunk=1044384;
dirr='/data/obs/obs/gridded/terraclim/MAT/';
ordir=pwd;
 cd /home/abatz/CALCULATIONS/
for yr=1:1
 load([dirr,'tmax_',num2str(yr+1957)]);
 load([dirr,'tmin_',num2str(yr+1957)]);
 tmean=tmaxdata/2+tmindata/2;
 clear tmaxdata tmindata
 load([dirr,'pet_',num2str(yr+1957)]);
% petdata=permute(reshape(petdata',12,4320,8640),[2 3 1]);
 load([dirr,'ppt_',num2str(yr+1957)]);
 f=find(~isnan(tmean(:,:,1))==1);
 tmean=shiftdim(tmean,2);
 pptdata=shiftdim(pptdata,2);
 petdata=shiftdim(petdata,2);
 tmean=tmean(:,f);
 pptdata=pptdata(:,f);
 petdata=single(petdata(:,f));

% carry forward soil and snow from previous december
MF=1-runsnow(tmean+273.15,1);
petdata=petdata.*MF; 
clear MF
 parfor i=1:12
 [AET(i).data,DEF(i).data,RO(i).data,SNOW(i).data,SOIL(i).data]=simplehydromodelsnow_gridr_tax(tmean(:,1+chunk*(i-1):chunk*i)',pptdata(:,1+chunk*(i-1):chunk*i)',petdata(:,1+chunk*(i-1):chunk*i)',soilt(f(1+chunk*(i-1):chunk*i)),soillast(f(1+chunk*(i-1):chunk*i))',snowlast(f(1+chunk*(i-1):chunk*i))');

% [AET(i).data,DEF(i).data,RO(i).data,SNOW(i).data,SOIL(i).data]=simplehydromodelsnow_gridr(tmean(:,1+chunk*(i-1):chunk*i)',pptdata(:,1+chunk*(i-1):chunk*i)',petdata(:,1+chunk*(i-1):chunk*i)',soilt(f(1+chunk*(i-1):chunk*i)),soillast(f(1+chunk*(i-1):chunk*i))',snowlast(f(1+chunk*(i-1):chunk*i))');
 end
 last4=chunk*12+1:chunk*12+4;
 [aaet,ddef,rro,snoww,soill]=simplehydromodelsnow_gridr_tax(tmean(:,last4)',pptdata(:,last4)',petdata(:,last4)',soilt(f(last4)),soillast(f(last4))',snowlast(f(last4))');
% [aaet,ddef,rro,snoww,soill]=simplehydromodelsnow_gridr(tmean(:,last4)',pptdata(:,last4)',petdata(:,last4)',soilt(f(last4)),soillast(f(last4))',snowlast(f(last4))');
 
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
 runoffdata(:,f(last4))=rro';
 snowdata(:,f(last4))=snoww';
 soildata(:,f(last4))=soill';

soillast=soildata(12,:);
snowlast=snowdata(12,:);

aetdata=shiftdim(aetdata,1);
defdata=shiftdim(defdata,1);
runoffdata=shiftdim(runoffdata,1);
snowdata=shiftdim(snowdata,1);
soildata=shiftdim(soildata,1);
clear *data*
yr
end
