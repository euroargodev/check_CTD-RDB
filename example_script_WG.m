addpath(genpath('\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\imab\'))
addpath '\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CTD-RDB-DMQC\check_RD\fx\OCEANS'
addpath '\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\matlab_toolboxes\m_map'

% INDIR is the folder where the wmo boxes mat files are stored
indir='H:\Datenbanken\Downloaded\IFREMER\CTD_for_DMQC_2021V02\';
%indir='X:\Public\bm2286\CTD_for_DMQC_2021V02_pluspangeanabos_900db\';
%indir='X:\Public\bm2286\CTD_for_DMQC_2021V02_pangeanabos900db_pangeanabosudashices700db\';

% REF is a string that describes the reference database being analised
ref='CTD_for_DMQC_2021V02';
% Q2 is the vector with the number of the WMO boxes in your region of interest
q2=[3600:3602 5600:5606 3700:3702 5700:5706];
% REF is the name of the region (to be used in file names):
reg='WeddellGyre';
% Grid parameters
% Some of the following summarizing plots bin the data into a grid
% Three parameters define the grid, its latitude and longitude limits and a grid step
% LONLIMS is a 1 x 2 vector with the longitude limits in degrees -180 to 180 [westernmost - to easternmost +]
% LATLIMS is a 1 x 2 vector with the latitude data in degrees -90 to 90 [southernmost nothernmost] : '); latlims=[52 66];%('Latitude limits in
% STEP is the Grid step in degrees (for both latitude and longitude)
latlims=[-80 -60];
lonlims=[-70 30];
step=5;
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
projstr=['m_proj(' '''' 'Albers' '''' ',' '''' 'lon' '''' ',lonlims,'...
     '''' 'lat' '''' ',latlims)'];
% Grid ticks
% XT are positions of the x-axis (longitude) ticks as a vector
xt=10*round(lonlims(1)/10):20:10*round(lonlims(2)/10);
   
% YT are the positions of the y-axis (latitude) ticks as a vector
yt=10*round(latlims(1)/10):10:10*round(latlims(2)/10);

% BATH is a vector with the bathymetry contours (m) to be plotted, default = [-9000 -2000 -900 0]: ');
bath=[-9000 -3000 -2000 -900 -700 ];

% MKSZ is the marker size for the plots
mksz=8;
% FTSY is the general fontsize for the plots
ftsz=12;

% MRPS is a vector with the bins for the Maximum recorded pressure
% histogram
mrps=500:500:4000;

%MPR min is the minimum accepted maximum recorded pressure
MPRmin=0;

ctdrdb_status(indir,ref,q2,reg,lonlims,latlims,step,projstr,xt,yt,bath,mksz,ftsz,mrps,MPRmin)
%plot_eachbox(indir,reg,wmo,1)
