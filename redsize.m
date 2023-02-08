function redsize(filename)
load(filename)
clear ptemp
temp=single(temp);
sal=single(sal);
pres=single(pres);
eval(['save ' filename ' -v7.3'])

