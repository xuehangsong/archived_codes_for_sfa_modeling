x = [1 2 3 10];
y = [1 2 9 10];
mi = 0;
for ii = x
    mi = mi + 1;
    mj = 0;
    for jj = y
        mj = mj + 1; 
        for i = 1:max(size(wellname))
            for j = 1:mtx
                mean_h(mi,mj,i,j) = mean(Head_t(ii,jj,:,i,j));
                mean_h2(mi,mj,i,j) = mean(Head_t(ii,jj,:,i,j).^2);
                var_h(mi,mj,i,j) = var(Head_t(ii,jj,:,i,j));
                %     var_h(ii,jj,i,j) = mean_h2(ii,jj,i,j) - mean_h(ii,jj,i,j)^2;
            end
        end
    end
end
for i = 1:max(size(wellname))
    for j = 1:mtx
        for ii = 1:4
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