wellh(1:82) = 0;
for i = 1:484
    if wellname{i}(end) == '1'
        for j = 1:82
            if wellname{i}(6:9) == labels{j}(1:4)
                wellh(j) = i;
            end
        end
    end
end
for i = 1:484
    if wellname{i}(end) == '2'
        for j = 1:82
            if wellname{i}(6:9) == labels{j}(1:4)
                wellh(j) = i;
            end
        end
    end
end

% for i = 1:484
%     for j = 1:82
%         if wellname{i}(6:9) == labels{j}(1:4)
%             index(i) = j;
%         end
%     end
% end
% for i = 1:82
%     max_index = 0;
%     for j = 1:484
%         if (index(j) == i) && (str2num(wellname{j}(end))>max_index)
%             max_index = str2num(wellname{j}(end));
%             wellh(i) = j;
%         end
%     end
% end
            