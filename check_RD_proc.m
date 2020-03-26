clear variables;close all
% toolboxes of otheres used by this repository
addpath([cd '\fx\'])
% Ingrid Angel (BSH) 01.03.2019 (Matlab 2018)

%% 0. Point the folder containing the DMQC Reference database
q1=input(['Is the latest version of the DMQC CTD-RDB (2019v01) locally available? '...
'yes (1) or no (0): ']);
if q1==1
   indir=input('Please provide the full path to the folder: ');
 else
   disp('The DMQC CTD-RDB (2019v01) will be downloaded (it takes a long time!)...')
   disp('Please provide the login data')
   login=input('Login: ');
   passw=input('Password: ');
   disp('Please provide the target folder ')
   tardir=input('Please provide the full path to the target folder: ');
   % info for download
   address='ftp.ifremer.fr';
   ftpdir='coriolis/CTD_for_DMQC/CTD_for_DMQC_2019V01/';
   fclue='CTD_for_DMQC*';
   extr=1;%extracts the tar.gz files
   download_RD(address,login,passw,ftpdir,fclue,tardir,extr)
end

%% 1. Extract data
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII%%
ref='CTD2019v01';
fclue='ctd_';
reg='Weddell Gyre';
wmo =sort([3600:3602 5600:5606 3700:3702 5700:5706]);
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII%%

outfile=extract_RD_wmolist(wmo,indir,reg,ref,fclue);
sortdates(outfile)
% 2a. plot data selected
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII%%
clrpl=[0 0 1];
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII%%

plot_wmoboxes(wmo,clrpl,1)
plot_str=['RD_' ref '_' strrep(reg,' ','_') '_'];
%eval(['export_fig -r300 ' plot_str '_zselbox.png'])

%% 3. Calculations: Simple diagnostics
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII%%
% grid parameters
step=2.5;% grid size in degrees
latlims=[-90 -25];
lonlims=[-180 185];
infile=[plot_str '.mat'];
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII%%

outfile=RD_simplediag(infile,step,latlims,lonlims);
load(infile)
load(outfile)
%% 4. Map Plots
%Set projection: Using a projection string (projstr)
% To create a projstr paste the m_proj(all) line of code in a
% text editor. Use the find and replace function like this
% find: '
% replace: ' '''' '
% and add a ' at the beginning and at the end (
% put all in brackets [])
% polar projection SOARC
%m_proj('stereographic','lat',-90,'long',0,'radius',65);

% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII%%
% projection settings
projstr=['m_proj(' '''' 'stereographic' '''' ',' '''' 'lat' '''' ',-90,' ...
    '''' 'long' '''' ',0,' '''' 'radius' '''' ',65);'];
%grid map settings
xt=[-70 30 150];
yt=[-75 -60 -45 -30];
% plot color-coded point maps
bath=[-9000 -2000 -900 0];
mksz=8;
% general fontsize
ftsz=12;
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII%%

% do projection
eval(projstr)

[X,Y]=m_ll2xy(LONG,LAT);% get projection positions

% Plot grid maps
plot_str=['RD_' ref '_' strrep(reg,' ','_') '_'];
% Grid map 1
ttl='Number of profiles per bin';
cblims=[0 100];
cblevels=20;
h = plot_mapgrid(unix,uniy,ofs,nprof,cblims,cblevels,xt,yt,ttl,ftsz);
rep_ytick(h,'100','>100')
eval(['export_fig -r300 ' plot_str '_agridmap1.png'])

% Grid map 2
ttl='Year of the latest profile per bin';
cblims=[1995 2019];
cblevels=numel(1995:2019)-1;
h = plot_mapgrid(unix,uniy,ofs,latest,cblims,cblevels,xt,yt,ttl,ftsz);
rep_ytick(h,'1995','<1995')
eval(['export_fig -r300 ' plot_str '_agridmap2.png'])

% plot color-coded point maps
% Point map 1
ttl='Profile positions - year is color-coded';
cblims=[1995 2019];
cblevels=numel(1995:2019)-1;
h = plot_mapclrpts(X,Y,YY,bath,mksz,cblims,cblevels,ttl,xt,yt,ftsz);
rep_ytick(h,'1995','<1995')
eval(['export_fig -r300 ' plot_str '_bpointmap1.png'])

% Point map 2
ttl='Profile positions - MRP is color-coded';
cblims=[500 4000];
cblevels=numel(500:100:4000)-1;
plot_mapclrpts(X,Y,MRP,bath,mksz,cblims,cblevels,ttl,xt,yt,ftsz);
eval(['export_fig -r300 ' plot_str '_bpointmap2.png'])

% Point map 3
ttl='Profile positions - MRP<900 is color-coded';
cblims=[0 1];
cblevels=2;
plot_mapclrpts(X,Y,shallow,bath,mksz,cblims,cblevels,ttl,xt,yt,ftsz);
colormap([0 0 1;1 0 0]);
eval(['export_fig -r300 ' plot_str '_bpointmap3.png'])

ttl='Profile positions - Presence of invalid samples color-coded';
cblims=[0 1];
cblevels=2;
plot_mapclrpts(X,Y,incp,bath,mksz,cblims,cblevels,ttl,xt,yt,ftsz);
colormap([0 0 1;1 0 0]);
eval(['export_fig -r300 ' plot_str '_bpointmap4.png'])

%% 5. Histogram plots
% Hist 1
% years
binedges=[1970 1995:2019];
bincent=1995:2019;
xl='Years';
yl='Number of profiles';
h=plot_hist(YY,binedges,bincent,0,xl,yl,ftsz);
rep_xtick(h,'1995','<=1995')
eval(['export_fig -r300 ' plot_str '_chist1.png'])

% Hist2
% months
binedges=0.5:12.5;
bincent=1:12;
xl='Months';
yl='Number of profiles';
plot_hist(MM,binedges,bincent,0,xl,yl,ftsz);
eval(['export_fig -r300 ' plot_str '_chist2.png'])

% Hist 3
% MRP
binedges=[0 900 1500 2000:1000:6000];
bincent=1:numel(binedges)-1;
xl='MRP intervals [db]';
yl='Number of profiles';
plot_hist(MRP,binedges,bincent,1,xl,yl,ftsz);
eval(['export_fig -r300 ' plot_str '_chist3.png'])
close all

%% Plot each box
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII%%
%m_proj('Albers','lon',lonlimp,'lat',latlimp)
projstr=['m_proj(' '''' 'Albers' '''' ',' '''' 'lon' '''' ',lonlimp,'...
    '''' 'lat' '''' ',latlimp)'];
plot_str=['RD_' ref '_'];
% IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII%%
%
% for i=1:numel(wmo)
%     box=num2str(wmo(i));
%     fn=[indir fclue box '.mat'];
%     plot_wmoboxprof(fn,ref,projstr)
%     eval(['export_fig -r300 ' plot_str fclue box '.png'])
%     close
% end
