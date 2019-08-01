%This script is for the problem that the wells are not in the same order
%for the PFLOTRAN output and my own well coordinate system.
wellindex(1:82) = 0;
for i = 1:82
    for j = 1:82
       if(wellnamegroup_BC{i}(6:9) == labels{j}(1:4))
        wellindex(j) = i;
       end
    end
end