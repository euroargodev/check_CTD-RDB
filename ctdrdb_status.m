function ctdrdb_status(indir,ref,q2,reg,lonlims,latlims,step,projstr,xt,yt,bath,mksz,ftsz,mrps)

% INDIR is the folder where the wmo boxes mat files are stored
% indir='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\ices2mat\baltic_fmi\';
% REF is a string that describes the reference database being analised 
% ref='CTD4MarginalSeas';
% Q2 is the vector with the number of the WMO boxes in your region of interest
% q2=[1500:1502 1601 1602];
% REF is the name of the region (to be used in file names): 
% reg='Baltic';
% Grid parameters
% Some of the following summarizing plots bin the data into a grid
% Three parameters define the grid, its latitude and longitude limits and a grid step
% LONLIMS is a 1 x 2 vector with the longitude limits in degrees -180 to 180 [westernmost - to easternmost +]
% LATLIMS is a 1 x 2 vector with the latitude data in degrees -90 to 90 [southernmost nothernmost] : '); latlims=[52 66];%('Latitude limits in
% STEP is the Grid step in degrees (for both latitude and longitude)
% lonlims=[5 35];
% latlims=[52 66];
% step=0.5;
% Projection
% PROJSTR is the projection string used for the maps
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
% or
% projstr='m_proj(''mercator'',''lon'',lonlims,''lat'',latlims)';

% Grid ticks
% XT are positions of the x-axis (longitude) ticks as a vector
% xt=lonlims(1):5:lonlims(2);
% YT are the positions of the y-axis (latitude) ticks as a vector
% yt=latlims(1):5:latlims(2);

% BATH is a vector with the bathymetry contours (m) to be plotted, default = [-9000 -2000 -900 0]: ');
% bath=[-100:20:0];

% MKSZ is the marker size for the plots
% mksz=8;
% FTSY is the general fontsize for the plots
% ftsz=12;

% MRPS is a vector with the bins for the Maximum recorded pressure
% histogram
% mrps=0:10:200;

%%
disp('c[]')
disp('---- working on data extraction ----')
wmo =sort(q2);
outfile=extract_RD_wmolist(wmo,indir,reg,ref);
disp('---- sorting by date ----')
sortdates(outfile)
disp(['Data extraction is finished. Data is stored in ' outfile '.'])

% 1. Plot selected region
disp('*')
disp('Ploting the selected WMO boxes')
clrpl=[0 0 1];% plots in blue
plot_wmoboxes(wmo,clrpl,1)
plot_str=['RD_' ref '_' strrep(reg,' ','_') '_'];
eval(['saveas(gcf,' '''' plot_str '_zselbox.png' '''' ')'])

% 2. Calculations: Simple diagnostics
disp('*')
disp('********* CALCULATING DIAGNOSTICS  *********')
disp('c[]')
disp('Diagnostics are being calculated and added to the diagnostics mat file')
infile=outfile;%or  name of the extracted mat file

outfile=RD_simplediag(infile,step,latlims,lonlims,1);% 1 sees plots
load(outfile)
load(infile)

%% 3. Map Plots
disp('*')
disp('********* PLOTING MAPS  *********')

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
    eval(['saveas(gcf,' '''' plot_str '_agridmap1.png' '''' ')'])
end

% Grid map 2
ttl='Year of the latest profile per bin';
cblims=[min(YY) max(YY)];
cblevels=numel(cblims(1):cblims(2))-1;
h = plot_mapgrid(unix,uniy,latest,cblims,cblevels,xt,yt,ttl,ftsz);
if q5==1
   eval(['saveas(gcf,' '''' plot_str '_agridmap2.png' '''' ')'])
end

% plot color-coded point maps
% Point map 1
ttl='Profile positions - year is color-coded';
h = plot_mapclrpts(X,Y,YY,bath,mksz,cblims,cblevels,ttl,xt,yt,ftsz);
if q5==1
    eval(['saveas(gcf,' '''' plot_str '_bpointmap1.png' '''' ')'])   
end

% Point map 2
ttl='Profile positions - MRP is color-coded';
cblims=[mrps(1) mrps(end)];
cblevels=numel(mrps)-1;
plot_mapclrpts(X,Y,MRP,bath,mksz,cblims,cblevels,ttl,xt,yt,ftsz);
if q5==1
   eval(['saveas(gcf,' '''' plot_str '_bpointmap2.png' '''' ')'])
end

% Point map 3
% ttl='Profile positions - MRP<900 is color-coded';
% cblims=[0 1];
% cblevels=2;
% plot_mapclrpts(X,Y,shallow,bath,mksz,cblims,cblevels,ttl,xt,yt,ftsz);
% colormap([0 0 1;1 0 0]);
% if q5==1
%     eval(['export_fig -r300 ' plot_str '_bpointmap3.png'])
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
cblims=[min(YY) max(YY)];
cblevels=numel(cblims(1):cblims(2))-1;

binedges=min(YY):max(YY);
bincent=min(YY)+0.5:1:max(YY);

xl='Years';
yl='Number of profiles';
h=plot_hist(YY,binedges,bincent,0,xl,yl,ftsz);
%rep_xtick(h,'1995','<=1995')
if q6==1
    eval(['saveas(gcf,' '''' plot_str '_chist1.png' '''' ')'])    
end
% Hist2
% months
binedges=0.5:12.5;
bincent=1:12;
xl='Months';
yl='Number of profiles';
plot_hist(MM,binedges,bincent,0,xl,yl,ftsz);
if q6==1
    eval(['saveas(gcf,' '''' plot_str '_chist2.png' '''' ')'])
end

% Hist 3
% MRP
%binedges=[0 900 1500 2000:1000:6000];
binedges=mrps;% 0:10:200;
bincent=1:numel(binedges)-1;
xl='MRP intervals [db]';
yl='Number of profiles';
plot_hist(MRP,binedges,bincent,1,xl,yl,ftsz);
if q6==1
   eval(['saveas(gcf,' '''' plot_str '_chist3.png' '''' ')'])
end
