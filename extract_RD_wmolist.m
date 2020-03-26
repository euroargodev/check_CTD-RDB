function outfile=extract_RD_wmolist(wmo,indir,reg,ref,fclue)
% Input
% wmo: Vector with the numbers of the WMO boxes to be extracted
% indir: Path to the RD .mat files
% reg: Name of the region (used to generate output file name)
% ref: Reference for the database (used to generate output file name)
% Example
% indir='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2186\Datenbanken\Downloaded\IFREMER\CTD_for_DMQC_2019V01\';
% name of the reference for the database
% ref='CTD2019v01';
% reg='Weddell Gyre';
% wmo =sort([3600:3602 5600:5606 3700:3702 5700:5706]);
outfile=['RD_' ref '_' strrep(reg,' ','-') '.mat'];
%  Ingrid Angel (BSH) 2019 (Matlab 2018)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Preallocate size of output matrix (max number of press levels x profiles )
% Get number of pressure levels and profiles in each box
nw=numel(wmo);
for i=1:nw %
    % load wmo box mat file as matobj
    infile=dir([indir fclue num2str(wmo(i)) '.mat']);
    if isempty(infile)==0
        matObj = matfile([indir infile(1).name]);
        % gets size of the pres variable
        info = whos(matObj,'pres');
        if isempty(info)==0
            s=info.size;
            % stores number of pres levels and profiles
            n(i,1) = s(2);
            clear matObj
        end
    else
        n(i,1) = 0;
        
    end
end

% Define dimensions
n2 = max(n(:,1)); % total number of profiles

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extracting vector variables (1 x n2)
disp('extracting vector variables')
tic
% Preallocate
DATES=nan(1,n2);LAT=nan(1,n2);
LONG=nan(1,n2);
QCLEVEL=cell(1,n2);
SOURCE=cell(1,n2);
PROF=nan(1,n2);

% Loop throug all boxes
for i=1:nw
   
    % Get the profile index in the original matfile
    if i==1
        i1=1;i2=n(i,1);
    else
        i1=sum(n(1:i-1,1))+1; i2=sum(n(1:i,1));
    end
    PROF(i1:i2)=1:n(i,1);
    % mat file name
    infile=[indir 'ctd_' num2str(wmo(i)) '.mat'];
    % if the file exists, reads and stores the data
    if isfile(infile)==1
        matObj = matfile(infile);
        DATES(i1:i2)=matObj.dates;
        LAT(i1:i2)=matObj.lat;
        LONG(i1:i2)=convertlon(matObj.long,180);% change long format to -180 to 180
        QCLEVEL(i1:i2)=matObj.qclevel;
        SOURCE(i1:i2)=matObj.source;
    end
    clear matObj
end
% get date vector from the RD date format
[YY,MM,DD,HH,MI,SS]=datesRD2vec(DATES); %#ok<*ASGLU>

% save first part of the file
disp('saving vector variables')
eval(['save ' outfile ' -v7.3 DATES LAT LONG QCLEVEL SOURCE PROF wmo indir YY MM DD MI'])
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extracting matrix variables (n1 x n2)
disp('extracting and appending matrix variables')
tic
var={'PRES','PTMP','SAL','TEMP'};
for j=1:numel(var)
    for i=1:nw
        % file
        infile=[indir 'ctd_' num2str(wmo(i)) '.mat'];
        if isfile(infile)==1
            tmp1=load(infile,lower(var{j}));
            eval(['tmp{1,i}=tmp1.' lower(var{j}) ';'])
            clear tmp1
        else
            tmp{1,i}=[];
        end
    end
    eval([var{j} '=cell2fillnan(tmp);'])
    clear tmp
    save(outfile,var{j},'-append');
    eval(['clear ' var{j}])
end
toc
