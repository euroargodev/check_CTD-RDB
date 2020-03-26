function plot_wmoboxes(sel_boxes,clr,pl,figsize)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot_wmoboxes(sel_boxes)
% The CTD reference database is organized following the World
% Metereological Organization (WMO) 10°x^10° boxes. This scripts plots a
% map of the entire globe with all boxes where the wmo boxes provided
% in sel_boxes list appear highlighted with another color.
%
% INPUT
% * sel_boxes is a vector with a list of box number
%    ex. sel_boxes=[1600 1601 1700 1701 7600 7601 7700 7701 7602 7702...
%                   7802 7800 7801 1800 1801 1802 1702];
% if is empty just plots the WMO grid
% clr is a vector with the color
% pl is 0 for no ploting, 1 for ploting in a new figure and 2 for ploting
% on top of the gcf.
% Author: Ingrid M. Angel-Benavides
%         BSH - MOCCA/EA-Rise (Euro-Argo)
%        (ingrid.angel@bsh.de)
% Last update: 20.10.2019
% HINT

% % For ploting more than one region use
% % List of region names
% reg{1}='Weddell Gyre';
% reg{2}='Ross Gyre';
% % wmo number
% wmo{1}=sort([3600:3602 5600:5606 3700:3702 5700:5706]);
% wmo{2}=sort([5607:5617 3615:3617 5707:5717 3715:3717 5814:5817 3816:3817]);
% nw=numel(wmo);
% clr=lines(nw);
% for i=1:nw
%     if i==1
%         plot_wmoboxes(wmo{i},clr(i,:),1)
%     else
%         plot_wmoboxes(wmo{i},clr(i,:),2)
%     end
% end
% makelegend(clr,reg)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin==0
    sel_boxes=[];
    clr=[0 0 0];
    pl=1;
    figsize=[1          45        1920        1089];
elseif nargin <4
    figsize=[1          45        1920        1089];a
end

if isfile('wmogrid.mat')==0
    % wmo grid
    lon=-179.9:0.1:179.9;
    lat=fliplr(-90:0.1:90);
    [lon,lat]=meshgrid(lon,lat);
    lat(end,:)=[];lon(end,:)=[];
    wmo=reshape(pos2wmo(lat(:),lon(:)),size(lon));
    
    [w,~,~]=unique(wmo);
    for i=1:numel(w)
        [i1,i2]=find(wmo==w(i));
        [lon_pts(i,:),lat_pts(i,:)]=corners([min(lon(i1,min(i2):max(i2))) max(lon(i1,min(i2):max(i2)))],[min(lat(min(i1):max(i1),i2)) max(lat(min(i1):max(i1),i2))]);
        lon_ctr(i,:)=median(median(lon(i1,min(i2):max(i2))));
        lat_ctr(i,:)=median(median(lat(min(i1):max(i1),i2)));
    end
    wmogrid.lat_ctr=lat_ctr;
    wmogrid.lon_ctr=lon_ctr;
    wmogrid.lat_pts=lat_pts;
    wmogrid.lon_pts=lon_pts;
    
    % projection
    %m_proj('miller','lon',[-180 180],'lat',[-90 90])
    wmogrid.projstr=['m_proj(' '''' 'miller' '''' ','...
        '''' 'lon' '''' ',[-180 180],'...
        '''' 'lat' '''' ',[-90 90]);'];
    wmogrid.w=w;
    save wmogrid.mat wmogrid
else
    load wmogrid.mat
end
eval(wmogrid.projstr)

if pl==1
    
    if isfile('wmoboxesall.fig')==0
        
        
        figure('color','white','position',figsize);
        m_coast('patch',[.8 .8 .8]);
        
        for i=1:numel(wmogrid.w)
            hold on
            m_plot(wmogrid.lon_pts(i,:),wmogrid.lat_pts(i,:),'color','k')%cm(:,:,i));
            h=m_text(wmogrid.lon_ctr(i,:),wmogrid.lat_ctr(i,:),num2str(wmogrid.w(i)),'fontsize',6);
            h.HorizontalAlignment='center';
            %pause
        end
        m_grid('linestyle','none','box','on');
        savefig('wmoboxesall.fig');
    else
        openfig('wmoboxesall.fig');
    end
elseif pl==2
    hold on
end

if pl>0
    if isempty(sel_boxes)==0
        for i=1:numel(sel_boxes)
            f=find(wmogrid.w==sel_boxes(i));
            hold on
            m_plot(wmogrid.lon_pts(f,:),wmogrid.lat_pts(f,:),'color',clr,'linewidth',1.5)
            h=m_text(wmogrid.lon_ctr(f,:),wmogrid.lat_ctr(f,:),num2str(wmogrid.w(f)),'fontsize',6);
            h.HorizontalAlignment='center';h.FontWeight='bold';
        end
    end
end
