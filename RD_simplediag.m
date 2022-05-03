function outfile=RD_simplediag(infile,step,latlims,lonlims,MPRmin,vb,lonfrmt)

if nargin<7
   lonfrmt=180;
end
eval(['load ' infile ' DATES YY DD MI MM LAT LONG QCLEVEL SOURCE PROF PRES'])

LONG=convertlon(LONG,lonfrmt);
latlims(2)=latlims(2)+step;
lonlims(2)=lonlims(2)+step;
% define grid
[unx,uny,ofs]=set_grid(lonlims,latlims,step);

% get indices of profiles in each grid cell 
% indices, number of profiles, year of latest profile
[inds,nprof,latest]=prof_ingrid(unx,uny,LONG,LAT,YY);

eval(['load ' infile ' TEMP SAL'])

% Consistency
%consider only samples with valid pixels
% check ranges
ft=find(TEMP<-2.5|TEMP>40);
fs=find(SAL<0|SAL>41);
TEMP(ft)=NaN;SAL(fs)=NaN;
% Incomplete pairs
isn=isnan(SAL);% nans in sal
clear SAL
isn=isn+isnan(TEMP);% nans in temp
clear TEMP
isn=isn+isnan(PRES);% nans in pres

% Find incomplete triplets
incpf=isn>0&isn<3;
incp=sum(incpf,1);

% MRP
% exclude incomplete samples
PRESC=PRES;PRESC(incpf)=NaN;
MRP=max(PRESC,[],1);%MRP=max(PRES,[],1);
% MRP shallow flag
shallow=MRP<MPRmin;

% NMIP
% Check for columns containing more than one profile
[il,ic]=find((diff(PRES,[],1))<0);
NMIP=false(1,numel(LAT));
NMIP(unique(ic))=1;

outfile=['SD_' infile];
vars1= 'unx uny ofs inds nprof latest incpf incp ';
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
    disp(num2str(numel(find(incpf>0))))
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
     disp(num2str(numel(find(NMIP==1))))
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
fprintf(fileID,[num2str(numel(find(incp>0))) '\n']);
% number of shallow profiles (MRP<900 db)
fprintf(fileID,['Number of shallow profiles (MRP<' num2str(MPRmin) ' db)'  '\n']);
fprintf(fileID,[num2str(numel(find(shallow==1))) '\n']);
% number of profiles containing more than one cast or with
% Non-monotonically increasing pressure
fprintf(fileID,['Number of profiles containing more than one cast or with '...
'non-monotonically increasing pressure'  '\n']);
fprintf(fileID,[num2str(numel(find(NMIP==1))) '\n']);
fclose(fileID);