for i = 1:max(size(wellname))
    wellname{i} = strrep(wellname{i},'_','-');
end
plot(timec,S_M(1,:));
title(wellname{1});
