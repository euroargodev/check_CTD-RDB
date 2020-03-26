function outfile=RD_simplediag(infile,step,latlims,lonlims,vb,lonfrmt)

if nargin<6
   lonfrmt=180;
end
% infile='RD_CTD2019v01_Weddell-Gyre.mat';
eval(['load ' infile ' DATES YY DD MI MM LAT LONG QCLEVEL SOURCE PROF PRES'])

LONG=convertlon(LONG,lonfrmt);
% define grid
[unix,uniy,ofs]=set_grid(lonlims,latlims,step);

% get indices of profiles in each grid cell 
% indices, number of profiles, year of latest profile
[inds,nprof,latest]=prof_ingrid(unix,uniy,LONG,LAT,YY);

eval(['load ' infile ' TEMP SAL'])

% Consistency
%consider only samples with valid pixels
% check ranges
ft=find(TEMP<-2.5|TEMP>40);
fs=find(SAL<24|TEMP>41);
TEMP(ft)=NaN;SAL(fs)=NaN;
% Incomplete pairs
isn=isnan(SAL);% nans in sal
clear SAL
isn=isn+isnan(TEMP);% nans in temp
clear TEMP
isn=isn+isnan(PRES);% nans in pres

incpf=isn>0&isn<3;
incp=sum(incpf,1);
incpw=incp./sum(isn<3);

% MRP
% exclude incomplete samples
PRESC=PRES;PRESC(incpf)=NaN;
MRP=max(PRESC,[],1);
% MRP shallow flag
shallow=MRP<900;

% NMIP
% Check for columns containing more than one profile
[il,ic]=find((diff(PRES,[],1))<0);
NMIP=unique(ic);

outfile=['SD_' infile];
vars1= 'unix uniy ofs inds nprof latest incpf incp incpw ';
vars2= 'MRP shallow NMIP';
eval(['save ' outfile ' ' vars1 vars2 ]) 

if vb==1
    disp('')
    disp('Simple diagnostic output ')
    % out of range temperature
    disp('Number of out of range temperature values')
    disp(num2str(numel(ft)))
    % out of range salinity
    disp('Number of out of range salinity values')
    disp(num2str(numel(fs)))
    % number of incomplete PTS triplets
    disp('Number of incomplete PTS triplets')
    disp(num2str(numel(sum(incpf))))
    % number of profiles with incomplete triplets
    disp('Number of profiles with incomplete triplets values')
    disp(num2str(numel(find(incp==1))))
    % number of shallow profiles (MRP<900 db)
    disp('Number of shallow profiles (MRP<900 db)')
    disp(num2str(numel(find(shallow==1))))
    % number of profiles containing more than one cast or with
    % Non-monotonically increasing pressure
    disp(['Number of profiles containing more than one cast or with '...
        'non-monotonically increasing pressure'])
    disp(num2str(numel(NMIP)))
    disp('')
end
outfile2=strrep(['SD_' infile],'.mat','.txt');

fileID = fopen(outfile2, 'w');
fprintf(fileID,['Number of out of range temperature values' '\n']);
fprintf(fileID,[num2str(numel(ft)) '\n']);
% out of range salinity
fprintf(fileID,['Number of out of range salinity values' '\n']);
fprintf(fileID,[num2str(numel(fs)) '\n']);
% number of incomplete PTS triplets
fprintf(fileID,['Number of incomplete PTS triplets' '\n']);
fprintf(fileID,[num2str(numel(sum(incpf))) '\n']);
% number of profiles with incomplete triplets
fprintf(fileID,['Number of profiles with incomplete triplets values' '\n']);
fprintf(fileID,[num2str(numel(find(incp==1))) '\n']);
% number of shallow profiles (MRP<900 db)
fprintf(fileID,['Number of shallow profiles (MRP<900 db)'  '\n']);
fprintf(fileID,[num2str(numel(find(shallow==1))) '\n']);
% number of profiles containing more than one cast or with
% Non-monotonically increasing pressure
fprintf(fileID,['Number of profiles containing more than one cast or with '...
'non-monotonically increasing pressure'  '\n']);
fprintf(fileID,[num2str(numel(NMIP)) '\n']);
fclose(fileID);

