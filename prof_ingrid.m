function [inds,nprof,latest]=prof_ingrid(unix,uniy,LONG,LAT,YY)
inds=cell(numel(uniy)-1,numel(unix)-1);
nprof=nan(numel(uniy)-1,numel(unix)-1);
for i=1:numel(unix)-1
    for j=1:numel(uniy)-1
        inds{j,i}=find(LONG>unix(i)&LONG<=unix(i+1)&LAT>uniy(j)&LAT<=uniy(j+1));
        if numel(inds{j,i})>0
            nprof(j,i)=numel(inds{j,i});
        else
            nprof(j,i)=NaN;
        end
    end
end
latest=nan(numel(uniy)-1,numel(unix)-1);
for i=1:numel(unix)-1
    for j=1:numel(uniy)-1
        if numel(inds{j,i})>0
            latest(j,i)=max(YY(inds{j,i}));
        else
            latest(j,i)=NaN;
        end
    end
end
