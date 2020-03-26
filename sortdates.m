function sortdates(ffp)
% with sorted dates newer profiles are plot on top of the older
matObj = matfile(ffp);
info = whos(matObj);
[tmp,I] = sort(matObj.DATES);

%numel(info)
for i=1:numel(info)
    if info(i).size(1)==numel(tmp) || info(i).size(2)==numel(tmp)
        %info(i).name 
        eval([info(i).name '=matObj.' info(i).name ';'])
        eval([info(i).name '=' info(i).name '(:,I);'])
        eval(['save ' ffp ' -append ' info(i).name ])
        eval(['clear ' info(i).name])
    end
end