function ctdrdb_status_fromfile(infile,outfile,ref,q2,reg,lonlims,latlims,step,projstr,xt,yt,bath,mksz,ftsz,mrps,MPRmin)
wmo =sort(q2);
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
uplim= ceil(max(nprof(:))/10)*10;
cblims=[1 uplim];
cblevels=uplim/10;
h = plot_mapgrid(unx,uny,nprof,cblims,cblevels,xt,yt,ttl,ftsz);
%rep_ytick(h,'100','>100')
if q5==1
    eval(['saveas(gcf,' '''' plot_str '_agridmap1_PROFN.png' '''' ')'])
end

% Grid map 2
ttl='Year of the latest profile per bin';
cblims=[max(min(YY),1995) max(YY)+1];
cblevels=numel(cblims(1):cblims(2))-1;
h = plot_mapgrid(unx,uny,latest,cblims,cblevels,xt,yt,ttl,ftsz);
if q5==1
   eval(['saveas(gcf,' '''' plot_str '_agridmap2_LATEST.png' '''' ')'])
end

% plot color-coded point maps
% Point map 1
ttl='Profile positions - year is color-coded';
h = plot_mapclrpts(X,Y,YY,bath,mksz,cblims,cblevels,ttl,xt,yt,ftsz);
if q5==1
    eval(['saveas(gcf,' '''' plot_str '_bpointmap1_YEAR.png' '''' ')'])   
end

% Point map 2
ttl='Profile positions - MRP is color-coded';
cblims=[mrps(1) mrps(end)];
cblevels=numel(mrps)-1;
plot_mapclrpts(X,Y,MRP,bath,mksz,cblims,cblevels,ttl,xt,yt,ftsz);
if q5==1
   eval(['saveas(gcf,' '''' plot_str '_bpointmap2_MRP.png' '''' ')'])
end

%Point map 3
ttl='Profile positions - many profiles in one are color-coded';
cblims=[0 1];
cblevels=2;
plot_mapclrpts(X(NMIP==1),Y(NMIP==1),NMIP(NMIP==1),bath,mksz,cblims,cblevels,ttl,xt,yt,ftsz);
colormap([1 0 0]);
if q5==1
 eval(['saveas(gcf,' '''' plot_str '_bpointmap3_NMIP.png' '''' ')'])
end

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

binedges=min(YY)-0.5:max(YY)+0.5;
bincent=min(YY):max(YY);

xl='Years';
yl='Number of profiles';
h=plot_hist(YY,binedges,bincent,0,xl,yl,ftsz);
%rep_xtick(h,'1995','<=1995')
if q6==1
    eval(['saveas(gcf,' '''' plot_str '_chist1_year.png' '''' ')'])    
end
% Hist2
% months
binedges=0.5:12.5;
bincent=1:12;
xl='Months';
yl='Number of profiles';
plot_hist(MM,binedges,bincent,0,xl,yl,ftsz);
if q6==1
    eval(['saveas(gcf,' '''' plot_str '_chist2_month.png' '''' ')'])
end

% Hist 3
% MRP
%binedges=[0 900 1500 2000:1000:6000];
binedges=mrps;% 0:10:200;
bincent=mrps(2:end);
xl='MRP intervals [db]';
yl='Number of profiles';
plot_hist(MRP,binedges,bincent,1,xl,yl,ftsz);
if q6==1
   eval(['saveas(gcf,' '''' plot_str '_chist3_mrp.png' '''' ')'])
end