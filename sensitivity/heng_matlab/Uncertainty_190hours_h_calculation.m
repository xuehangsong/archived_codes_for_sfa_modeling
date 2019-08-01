% for ii = 1:10
%     for jj = 1:10
%         mt = 0;
%         for i = 2:5:max(size(timec))
%             mt = mt + 1;
%             for k = 1:max(size(wellname))
%                 for j = 1:nsim
%                     indext = find(time{ii,jj,j}==timec(i));
%                     %                    if j < 18
% %                     if ((max(size(Headt{ii,jj,j}(:,indext)))< max(size(wellname))) && k >(max(size(Headt{ii,jj,j}(:,indext)))))
% %                         disp(ii);disp(jj);disp(k);
% %                         Head_t(ii,jj,j,k,mt) = Headt{ii,jj-1,j}(k,indext);
% %                     else
%                         Head_t(ii,jj,j,k,mt) = Headt{ii,jj,j}(k,indext);
% %                    end
%                    if ii == 7 && jj == 10 && j == 96
%                        Head_t(ii,jj,j,k,mt) = Headt{ii,jj,j-1}(k,indext);
%                    end
%                     %                    else
%                     %                         Head_t(ii,jj,j,k,mt) = Headt{ii,jj,j+1}(k,indext);
%                 end
%             end
%         end
%             mtx = mt;
%     end
% end
disp('Done with h data transform');
mtx = 39;
for ii = 1:10
    for jj = 1:10
        for i = 1:max(size(wellname))
            for j = 1:mtx
                mean_h(ii,jj,i,j) = mean(Head_t(ii,jj,:,i,j));
                mean_h2(ii,jj,i,j) = mean(Head_t(ii,jj,:,i,j).^2);
                var_h(ii,jj,i,j) = var(Head_t(ii,jj,:,i,j));
                %     var_h(ii,jj,i,j) = mean_h2(ii,jj,i,j) - mean_h(ii,jj,i,j)^2;
            end
        end
    end
end
for i = 1:max(size(wellname))
    for j = 1:mtx
        for ii = 1:S
            mean_h_M(ii,i,j) = mean(mean_h(ii,:,i,j));
            mean_h2_M(ii,i,j) = mean(mean_h2(ii,:,i,j));
            var_h_M(ii,i,j) = var(mean_h(ii,:,i,j));
            %var_h_M(ii,i,j) = mean_h2_M(ii,i,j) - mean_h_M(ii,i,j).^2;
            mean_var_M(ii,i,j) = mean(var_h(ii,:,i,j));
        end
        mean_h_S(i,j) = mean(mean_h_M(:,i,j));
        mean_h2_S(i,j) = mean(mean_h_M(:,i,j).^2);
        Var_S_h(i,j) = var(mean_h_M(:,i,j));
        %        Var_S_h(i,j) = mean_h2_S(i,j) - mean_h_S(i,j).^2;
        Var_M_h(i,j) = mean(var_h_M(:,i,j));
        Var_T_h(i,j) = mean(mean_var_M(:,i,j));
        if (Var_S_h(i,j) < 0 )
            Var_S_h(i,j) = 0;
        end
        if (Var_M_h(i,j) < 0 )
            Var_M_h(i,j) = 0;
        end
        if (Var_T_h(i,j) < 0 )
            Var_T_h(i,j) = 0;
        end
        S_S(i,j) = Var_S_h(i,j)/(Var_S_h(i,j)+Var_M_h(i,j)+Var_T_h(i,j));
        S_M(i,j) = Var_M_h(i,j)/(Var_S_h(i,j)+Var_M_h(i,j)+Var_T_h(i,j));
        S_T(i,j) = Var_T_h(i,j)/(Var_S_h(i,j)+Var_M_h(i,j)+Var_T_h(i,j));
    end
end
disp('Done with h');