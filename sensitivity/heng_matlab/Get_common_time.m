nsim = 100;
S = 10;
M = 10;
nsimx = 1:nsim;
%nsimx(18) = [];
for ii = 1:10
    for jj = 1:M
        mi = 0;
        for i = nsimx
            mi = mi + 1;
            time{ii,jj,mi} = Timet{ii,jj,i}(1,:);
            if ii == 7 && jj == 10 && i == 96
                time{ii,jj,mi} = Timet{ii,jj,i-1}(1,:);
            end
        end
    end
end
for ii = 1:10
    for jj = 1:M
        for i = 1:nsim-1
            if (i == 1)&&(ii ==  1)&&(jj == 1)
                timec = intersect(time{ii,jj,i},time{ii,jj,i+1});
%                 if max(size(timec))<190
%                     disp(ii);
%                     disp(jj)
%                     disp(i);
%                     break;
%                 end
            else
                timec = intersect(time{ii,jj,i},timec);
                if max(size(timec))<190
                    disp(ii);
                    disp(jj)
                    disp(i);
                    break;
                end
            end
        end
    end
end