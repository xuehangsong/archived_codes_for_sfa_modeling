for i = 1:2:9
    for j = 1:10
        for k = 1:484
            if i ~= 3
            if wellnamet{i,j}{k} ~=wellname{k}
                disp('false');
            end
            end
        end
    end
end