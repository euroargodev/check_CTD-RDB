function h = plot_mapclrpts(X,Y,YY,bath,mksz,cblims,cblevels,ttl,xt,yt,ftsz)
if nargin<11
    figsize=[1          45        1920        1089];
end
figure('Color', 'w','Position', figsize);
m_etopo2('contour', bath,'color','k');
m_coast('patch',[.7 .7 .7],'edgecolor','k');
% plot
scatter(X,Y,mksz,YY,'filled')
% format
caxis(cblims)
colormap(parula(cblevels))
h=colorbar;
m_grid('xtick',xt,'ytick',yt,'XaxisLocation','bottom','tickdir','out','linest','-');
title(ttl)
set(findall(gcf,'-property','FontSize'),'FontSize',ftsz)
