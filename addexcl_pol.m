function pol=addexcl_pol(lonlims,latlims)
[Z,LONG,LAT]=m_etopo2([lonlims latlims]);
Z(Z>0)=NaN;
figure
pcolor(LONG(1:5:end,1:5:end),LAT(1:5:end,1:5:end),Z(1:5:end,1:5:end));shading flat
caxis([-4000 0])
colormap(parula(numel(-4000:500:0)))
colorbar
xlim([lonlims(1)-3 lonlims(2)+3])

tt=input('Name for the polygon '' name '': ');
sat=0;
while sat~=1
    disp('Click to define polygon points. Press Enter to finish.')
    [ex, ey]=finput;ex(end+1)=ex(1);ey(end+1)=ey(1);
    hold on
    plot(ex,ey,'linewidth',3)
    title(tt)
    sat=input('Are you satisfied with the polygon (yes: 1)? ');
end
pol.ex=ex;
pol.ey=ey;
