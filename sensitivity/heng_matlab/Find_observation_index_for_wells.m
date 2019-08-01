well_num = max(size(wellnamegroup));
well_obs_num = max(size(wellname));
for i = 1:well_num
    m = 0;
    for j = 1:well_obs_num
        if strmatch(wellnamegroup{i},wellname{j})
            m = m + 1;
            obs_index{i}(m) = j;
        end
    end
end