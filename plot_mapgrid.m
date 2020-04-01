function h = plot_mapgrid(unix,uniy,ofs,tdistn,cblims,cblevels,xt,yt,ttl,ftsz,figsize)
if nargin<11
    figsize=[1          45        1920        1089];
end
figure('Color', 'w','Position', figsize);
set(gcf,'color','w')
% half point grid offset for pcolor(see m_map user guide)
hfpo=mean(diff(unix))/2;
m_pcolor(unix(1:end-1)+ofs-hfpo,uniy(1:end-1)+ofs+hfpo,tdistn)
caxis(cblims)
m_coast('patch',[.7 .7 .7],'edgecolor','k');
m_grid('xtick',xt,'ytick',yt,'XaxisLocation','bottom','tickdir','out');
colormap(parula(cblevels))
h=colorbar;
title(ttl)
set(findall(gcf,'-property','FontSize'),'FontSize',ftsz)
