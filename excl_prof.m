function excl_prof(filein,fileout,excl)
% excludes all profiles in a mat file (FILEIN) according to the provided list of
% indices (EXCL) and saves it in another mat file (FILEOUT)

% vector variables
eval(['load ' filein ' DATES LAT LONG QCLEVEL SOURCE PROF wmo indir YY MM DD MI'])
DATES(excl)=[];
LAT(excl)=[];
LONG(excl)=[];
QCLEVEL(excl)=[];
SOURCE(excl)=[];
PROF(excl)=[];
YY(excl)=[];
MM(excl)=[];
DD(excl)=[];
MI(excl)=[];

% matrix variables
eval(['load ' filein ' PRES PTMP SAL TEMP'])
PRES(:,excl)=[];
SAL(:,excl)=[];
PTMP(:,excl)=[];
TEMP(:,excl)=[];

eval(['save ' fileout '  DATES LAT LONG QCLEVEL SOURCE PROF YY MM DD MI PRES PTMP SAL TEMP wmo indir'])
