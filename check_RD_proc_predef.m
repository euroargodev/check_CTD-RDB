clear variables;close all
% folder with the wmo boxes
indir='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\ices2mat\baltic_fmi\';

% reference for the saving
ref='CTD4MarginalSeas';
disp('-@-@-')
% Please provide a vector with the number of the WMO boxes in your region of interest
q2=[1500:1502 1601 1602];
% Please provide a name for your region (to be used in file names): 
reg='Baltic';
wmo =sort(q2);

% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII%%
disp('c[]')
disp('---- working on data extraction ----')
outfile=extract_RD_wmolist(wmo,indir,reg,ref);
disp('---- sorting by date ----')
sortdates(outfile)
disp(['Data extraction is finished. Data is stored in ' outfile '.'])

% skiping EXCLUDING REGIONS

% 1a. Plot selected region
disp('*')
disp('Ploting the selected WMO boxes')
clrpl=[0 0 1];% plots in blue
plot_wmoboxes(wmo,clrpl,1)
plot_str=['RD_' ref '_' strrep(reg,' ','_') '_'];
eval(['export_fig -r300 ' plot_str '_zselbox.png'])

%% 2. Calculations: Simple diagnostics
disp('*')
disp('********* CALCULATING DIAGNOSTICS  *********')
% 2a. Grid parameters
%disp('*')
%disp('Some of the following summarizing plots bin the data into a grid.')
%disp('Three parameters define the grid, its latitude and longitude limits and a grid step.')
%disp('Please provide the parameters (if empty will run with the example region and/or step = 2)')
%disp('-@-@-')
%Longitude limits in degrees -180 to 180 [westernmost - to easternmost +] : ');
lonlims=[5 35];
latlims=[52 66];%('Latitude limits in degrees -90 to 90 [southernmost nothernmost] : ');
step=0.5;%input('Grid step in degrees (for both latitude and longitude): ');

%disp('c[]')
%disp('Diagnostics are being calculated and added to the diagnostics mat file')
infile=outfile;%or  name of the extracted mat file

outfile=RD_simplediag(infile,step,latlims,lonlims,1);% 1 sees plots
load(outfile)
load(infile)

%% 3. Map Plots
%disp('*')
%disp('********* PLOTING MAPS  *********')

% Set projection
%disp(['The following code will plot maps, it is necessary to provide a projection '...
%    'string for m_map'])

% To create a projection string paste the entire m_proj line of code in a
% text editor. Use the find and replace function like this
% find: '
% replace: ''
% and add a ' at the beginning and at the end (
% put all in brackets [])
% Ex. polar projection SOARC
% m_proj('stereographic','lat',-90,'long',0,'radius',65);
% becomes
% projstr=['m_proj(' '''' 'stereographic' '''' ',' '''' 'lat' '''' ',-90,' ...
%    '''' 'long' '''' ',0,' '''' 'radius' '''' ',65);'];
projstr='m_proj(''mercator'',''lon'',lonlims,''lat'',latlims)';
%disp(' To create a projection string paste the entire m_proj line of code')
%disp(['(ex. ' 'm_proj(''stereographic'',''lat'',-90,''long'',0,''radius'',65))']);
%disp(' in a text editor. Use the find and replace function like this')
%disp(' find: '' '); disp(' replace: '''' ')
%disp(' and add a '' at the beginning and at the end, then put all in brackets []')

%disp('*')
%disp('---- map and plot settings ----')

% projstring
%disp('-@-@-')
%projstr=input('Please provide the projection string: ');
% Grid ticks
xt=lonlims(1):5:lonlims(2);%(%'Provide the positions of the x-axis (longitude) ticks as a vector: ');
yt=latlims(1):5:latlims(2);%input(%'Provide the positions of the y-axis (latitude) ticks as a vector: ');

% Bathymetry contours
%bath=input('Provide a vector with the bathymetry contours (m) to be plotted, default = [-9000 -2000 -900 0]: ');
bath=[-100:20:0];

% marker size
mksz=8;
% general fontsize
ftsz=12;

disp('-@-@-')
q5=1;%input('Want to save the map plots (png)? - Uses export_fig - yes(1) no (0): ');

% do projection
eval(projstr)

[X,Y]=m_ll2xy(LONG,LAT);% get projection positions

% Plot grid maps
disp('c[]')
disp('---- ploting maps ----')
plot_str=['RD_' ref '_' strrep(reg,' ','_') '_'];
% Grid map 1
ttl='Number of profiles per bin';
cblims=[0 100];
cblevels=20;
h = plot_mapgrid(unix,uniy,nprof,cblims,cblevels,xt,yt,ttl,ftsz);
%rep_ytick(h,'100','>100')
if q5==1
    eval(['export_fig -r300 ' plot_str '_agridmap1.png'])
end

% Grid map 2
ttl='Year of the latest profile per bin';
cblims=[1995 2019];
cblevels=numel(1995:2019)-1;
h = plot_mapgrid(unix,uniy,latest,cblims,cblevels,xt,yt,ttl,ftsz);
rep_ytick(h,'1995','<1995')
if q5==1
    eval(['export_fig -r300 ' plot_str '_agridmap2.png'])
end

% plot color-coded point maps
% Point map 1
ttl='Profile positions - year is color-coded';
cblims=[1995 2019];
cblevels=numel(1995:2019)-1;
h = plot_mapclrpts(X,Y,YY,bath,mksz,cblims,cblevels,ttl,xt,yt,ftsz);
rep_ytick(h,'1995','<1995')
if q5==1
    eval(['export_fig -r300 ' plot_str '_bpointmap1.png'])
end

% Point map 2
ttl='Profile positions - MRP is color-coded';
cblims=[500 4000];
cblevels=numel(500:100:4000)-1;
plot_mapclrpts(X,Y,MRP,bath,mksz,cblims,cblevels,ttl,xt,yt,ftsz);
if q5==1
    eval(['export_fig -r300 ' plot_str '_bpointmap2.png'])
end

% Point map 3
ttl='Profile positions - MRP<900 is color-coded';
cblims=[0 1];
cblevels=2;
plot_mapclrpts(X,Y,shallow,bath,mksz,cblims,cblevels,ttl,xt,yt,ftsz);
colormap([0 0 1;1 0 0]);
if q5==1
    eval(['export_fig -r300 ' plot_str '_bpointmap3.png'])
end

% ttl='Profile positions - Presence of invalid samples color-coded';
% cblims=[0 1];
% cblevels=2;
% plot_mapclrpts(X,Y,incp,bath,mksz,cblims,cblevels,ttl,xt,yt,ftsz);
% colormap([0 0 1;1 0 0]);
% if q5==1
%     eval(['export_fig -r300 ' plot_str '_bpointmap4.png'])
% end

%% 5. Histogram plots
%disp('*')
%disp('********* PLOTING HISTOGRAMS  *********')
%disp('The following code will plot histograms ')
%disp('-@-@-')
q6=1;%input('Want to save the histogram plots (png)? - Uses export_fig - yes(1) no (0): ');


%disp('c[]')
disp('---- ploting histograms ----')
% Hist 1
% years
binedges=1999:2022;
bincent=1999.5:1:2022;

xl='Years';
yl='Number of profiles';
h=plot_hist(YY,binedges,bincent,0,xl,yl,ftsz);
%rep_xtick(h,'1995','<=1995')
if q6==1
    eval(['export_fig -r300 ' plot_str '_chist1.png'])
end

% Hist2
% months
binedges=0.5:12.5;
bincent=1:12;
xl='Months';
yl='Number of profiles';
plot_hist(MM,binedges,bincent,0,xl,yl,ftsz);
if q6==1
    eval(['export_fig -r300 ' plot_str '_chist2.png'])
end

% Hist 3
% MRP
%binedges=[0 900 1500 2000:1000:6000];
binedges=0:10:200;
bincent=1:numel(binedges)-1;
xl='MRP intervals [db]';
yl='Number of profiles';
plot_hist(MRP,binedges,bincent,1,xl,yl,ftsz);
if q6==1
    eval(['export_fig -r300 ' plot_str '_chist3.png'])
end

%% Plot each box
% disp('*')
% disp('********* PLOT DATA INSIDE EACH WMO BOX*********')
% disp('The following code will plot the content of each selected WMO box  ')
% disp('-@-@-')
% q6=input('Want to skip viewing and save the WMO boxes plots (png)? - Uses export_fig - yes(1) no (0): ');
% 
% 
% projstr=['m_proj(' '''' 'Albers' '''' ',' '''' 'lon' '''' ',lonlimp,'...
%     '''' 'lat' '''' ',latlimp)'];
% plot_str=['RD_' ref '_'];
% 
% disp('c[]')
% disp('---- ploting WMO boxes content ----')
% nout=cell(numel(wmo),1);
% for i=1:numel(wmo)
%     box=num2str(wmo(i));
%     disp(['.... box ' box ' (' num2str(i) ' of ' num2str(numel(wmo)) ')'])
%     fn=[indir 'ctd_' box '.mat'];
%     if exist(fn,'file') ==2
%         if q6==1
%             nout{i}=plot_wmoboxprof(fn,ref,projstr,'off');
%             eval(['export_fig -r300 ' plot_str 'ctd_' box '.png'])
%             close
%         else
%             nout{i}=plot_wmoboxprof(fn,ref,projstr,'on');
%         end
%     else
%         disp('- this box does not exist - there are no profiles')
%     end
% end
% disp('*')
% disp('********* THE END *********')
% disp('*')
