load /data/obs/obs/gridded/terraclim/MAT/lonlatel
cd /home/abatz/CALCULATIONS/
 for i=59:60
load(['/data/obs/obs/gridded/terraclim/MAT/tmax_',num2str(i+1957)]);
load(['/data/obs/obs/gridded/terraclim/MAT/tmin_',num2str(i+1957)]);
load(['/data/obs/obs/gridded/terraclim/MAT/vap_',num2str(i+1957)]); 
vsat=calcVP_tmaxtmin(tmaxdata,tmindata,el);
vpddata=vsat-vapdata;f=find(vpddata<0);vpddata(f)=0;                                  
save(['/data/obs/obs/gridded/terraclim/MAT/vpd_',num2str(i+1957)],'-v7.3','vpddata');
end
