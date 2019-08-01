
%h_total(:,:,:,2,:,:) = h;
for tt = 1:4
    
    for ii = 1:10
        for jj = 1:10
            for i = 1:120
                for j = 1:120
                    mean_h(ii,jj,i,j) = mean(h_total(ii,jj,:,tt,i,j));
                    mean_h2(ii,jj,i,j) = mean(h_total(ii,jj,:,tt,i,j).^2);
                    var_h(ii,jj,i,j) = var(h_total(ii,jj,:,tt,i,j));
                    %     var_h(ii,jj,i,j) = mean_h2(ii,jj,i,j) - mean_h(ii,jj,i,j)^2;
                end
            end
        end
    end
    for i = 1:120
        for j = 1:120
            for ii = 1:10
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
            S_S(i,j,tt) = Var_S_h(i,j)/(Var_S_h(i,j)+Var_M_h(i,j)+Var_T_h(i,j));
            S_M(i,j,tt) = Var_M_h(i,j)/(Var_S_h(i,j)+Var_M_h(i,j)+Var_T_h(i,j));
            S_T(i,j,tt) = Var_T_h(i,j)/(Var_S_h(i,j)+Var_M_h(i,j)+Var_T_h(i,j));
        end
    end
end
