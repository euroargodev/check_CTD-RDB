function nout=plot_wmoboxprof(fn,ref,projstr,vis,lonlimp,latlimp,figsize)
if nargin<7
    figsize=[1    6  863  635];
end
% The original version of this function was provided by Jan Even Nilsen
% I did some modifications but I am not sure which ones

% ref= reference string for the RD
% it calls the toolbox OCEAN
% (https://github.com/dcherian/tools/tree/master/oceanography/OCEANS)
% for the TS diagram
% fn='ctd_1600.mat';
% ref='CTD2019v01';
% projstr=['m_proj(' '''' 'Albers' '''' ',' '''' 'lon' '''' ',lonlimp,'...
%     '''' 'lat' '''' ',latlimp)'];

% Get wmo number from file
wmosq=str2num(fn(end-7:end-4));
lim=wmosquare(wmosq);
%set projection
if nargin<5
    lonlimp=lim(1:2)+[-1 1];
    f=find(abs(lonlimp)>180);if isempty(f)==0; lonlimp(f)=lim(f);end
    latlimp=lim(3:4)+[-1 1];
    f=find(abs(latlimp)>90);if isempty(f)==0; latlimp(f)=lim(f+2);end
end
eval(projstr)


% Load data
load(fn);
load(fn,'temp');
% Convert long format
long=convertlon(long,180);

% Calculate WMO number
wmoc=pos2wmo(lat,long);
% Check if there are positions outside the wmo box
nout=find(wmoc~= wmosq);
if numel(nout)>0
    disp(['In box ' num2str(wmosq)])
    disp(['There are ',num2str(numel(nout)),'-positions outside the WMO-square ',int2str(wmosq),' !'])
end

% Figure
figure('color','white','position',figsize,'visible',vis)
% sort by date
[ans,IA]=sort(dates);

% Map
subplot 221;
title({[ref,' - in WMO-square ',int2str(wmosq)],'Time is color-coded'});
m_grid; m_coast('patch',[.8 .8 .8]);
m_elev('contour','color',[.7 .7 .7]);
% wmo box line
[lo,la]=corners(lim(1:2),lim(3:4));
hw=m_line(lo,la,'color','b');
% profile plots
dd=datesRD2vec(dates);
hp=m_scatter(long(IA),lat(IA),30,dd(IA));
set(hp,'marker','.');
caxis([1995 2020]);colorbar
axis square
%hl=legend([hw hp(1)],'WMO-square','Reference data','location','northwestoutside');

% find color for each plot
v=dd;v(dd<=1994)=1995;
map= parula;minv = 1995;maxv = max(v(:));
ncol = size(map,1);
s = round(1+(ncol-1)*(v-minv)/(maxv-minv));
rgb_image = squeeze(ind2rgb(s,map));

% TS-diagram:
subplot 222
tsdiagrm(mima(sal),mima(temp),0);
hTS=line(sal(:,IA),temp(:,IA),'marker','.','linestyle','none');
set(hTS,{'color'},num2cell(rgb_image(IA,:),2));
title({['n = ' num2str(numel(dates))],...
    [num2str(numel(nout)),' profiles outside the box']});

% Profiles:
% Temperature
subplot 223
hT=line(pres(:,IA),temp(:,IA));
view([90 90]);grid;set(gca,'yaxislocation','right');
set(hT,{'color'},num2cell(rgb_image(IA,:),2));
xlabel Pressure; ylabel Temperature
% Salinity
subplot 224
hS=plot(pres(:,IA),sal(:,IA));
view([90 90]);grid;set(gca,'yaxislocation','right');
set(hS,{'color'},num2cell(rgb_image(IA,:),2));
xlabel Pressure; ylabel Salinity
