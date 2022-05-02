function h=plot_hist(vec,binedges,bincent,label,xl,yl,ftsz,figsize)
if nargin<8
    figsize=[19         295        1858         324];
end

nbin=numel(binedges)-1;
N=nan(1,nbin);
for i=1:nbin
    N(i)=numel(find(vec>=binedges(i)&vec<binedges(i+1)));
    if label==1
       Xlabel{i}=[num2str(binedges(i)) ' - ' num2str(binedges(i+1)-1)];
    end
end

figure('Color', 'w','position',figsize);
bar(bincent,N);
if label==1
    set(gca,'xtick',bincent,'xticklabel',Xlabel)
end
h=gca;
xlabel(xl);
ylabel(yl);
set(findall(gcf,'-property','FontSize'),'FontSize',ftsz)
grid on