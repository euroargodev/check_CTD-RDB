addpath(genpath('H:\CodeProjects\imab\'))
addpath 'H:\CodeProjects\CTD-RDB-DMQC\check_RD\fx\OCEANS'
addpath 'H:\CodeProjects\CodeProjects\matlab_toolboxes\m_map'

% INDIR is the folder where the wmo boxes mat files are stored
%indir='\\win.bsh.de\root$\Standard\Hamburg\Homes\Homes00\bm2286\CodeProjects\ices2mat\baltic_fmi\';
indir = 'H:\CodeProjects\baltic_ctdrb\baltic\A2\';
% REF is a string that describes the reference database being analised
ref='CTD4MarginalSeas';
% Q2 is the vector with the number of the WMO boxes in your region of interest
q2=[1500:1502 1601 1602];
% REF is the name of the region (to be used in file names):
reg='Baltic2022';
% Grid parameters
% Some of the following summarizing plots bin the data into a grid
% Three parameters define the grid, its latitude and longitude limits and a grid step
% LONLIMS is a 1 x 2 vector with the longitude limits in degrees -180 to 180 [westernmost - to easternmost +]
% LATLIMS is a 1 x 2 vector with the latitude data in degrees -90 to 90 [southernmost nothernmost] : '); latlims=[52 66];%('Latitude limits in
% STEP is the Grid step in degrees (for both latitude and longitude)
lonlims=[5 35];
latlims=[52 66];
step=0.5;
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
projstr='m_proj(''mercator'',''lon'',lonlims,''lat'',latlims)';

% Grid ticks
% XT are positions of the x-axis (longitude) ticks as a vector
xt=lonlims(1):5:lonlims(2);
% YT are the positions of the y-axis (latitude) ticks as a vector
yt=latlims(1):5:latlims(2);

% BATH is a vector with the bathymetry contours (m) to be plotted, default = [-9000 -2000 -900 0]: ');
bath=-100:20:0;

% MKSZ is the marker size for the plots
mksz=8;
% FTSY is the general fontsize for the plots
ftsz=12;

% MRPS is a vector with the bins for the Maximum recorded pressure
% histogram
mrps=0:20:200;

%MPR min is the minimum accepted maximum recorded pressure
MPRmin=0;

ctdrdb_status(indir,ref,q2,reg,lonlims,latlims,step,projstr,xt,yt,bath,mksz,ftsz,mrps,MPRmin)