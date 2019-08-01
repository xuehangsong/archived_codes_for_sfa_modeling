
M_weight_OK = 1/3;
M_weight_EP = 1/3;
M_weight_CS = 1/24;
S_weight_OK = 1/3;
S_weight_CS = 2/27;
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
                mean_h_M(ii,i,j) = 0;
                mean_h2_M(ii,i,j) = 0;
                var_h_M(ii,i,j) = 0;
                mean_var_M(ii,i,j) = 0;
                for jj = 1:8
                    mean_h_M(ii,i,j) = mean_h_M(ii,i,j) + M_weight_CS*mean_h(ii,jj,i,j);
                    mean_h2_M(ii,i,j) = mean_h2_M(ii,i,j) + M_weight_CS*(mean_h(ii,jj,i,j)^2);
                    mean_var_M(ii,i,j) = mean_var_M(ii,i,j) + M_weight_CS*var_h(ii,jj,i,j);
                end
                for jj = 9:10
                    mean_h_M(ii,i,j) = mean_h_M(ii,i,j) + M_weight_OK*mean_h(ii,jj,i,j);
                    mean_h2_M(ii,i,j) = mean_h2_M(ii,i,j) + M_weight_OK*(mean_h(ii,jj,i,j)^2);
                    mean_var_M(ii,i,j) = mean_var_M(ii,i,j) + M_weight_OK*var_h(ii,jj,i,j);
                end
 %               mean_h_M(ii,i,j) = mean(mean_h(ii,:,i,j));
 %               mean_h2_M(ii,i,j) = mean(mean_h2(ii,:,i,j));
 %               var_h_M(ii,i,j) = var(mean_h(ii,:,i,j));
                var_h_M(ii,i,j) = mean_h2_M(ii,i,j) - mean_h_M(ii,i,j).^2;
 %               mean_var_M(ii,i,j) = mean(var_h(ii,:,i,j));
            end
            mean_h_S(i,j) = 0;
            mean_h2_S(i,j) = 0;
            Var_T_h(i,j) = 0;
            Var_M_h(i,j) = 0;
            for jj = 1:9
                mean_h_S(i,j) = mean_h_S(i,j) + S_weight_CS*mean_h_M(jj,i,j);
                mean_h2_S(i,j) = mean_h2_S(i,j) + S_weight_CS*(mean_h_M(jj,i,j)^2);
                Var_T_h(i,j) = Var_T_h(i,j) + S_weight_CS*(mean_var_M(jj,i,j));
                Var_M_h(i,j) = Var_M_h(i,j) + S_weight_CS*(var_h_M(jj,i,j));
            end
            mean_h_S(i,j) = mean_h_S(i,j) + S_weight_OK*mean_h_M(10,i,j);
            mean_h2_S(i,j) = mean_h2_S(i,j) + S_weight_OK*(mean_h_M(10,i,j)^2);
            Var_T_h(i,j) = Var_T_h(i,j) + S_weight_OK*(mean_var_M(10,i,j));
            Var_M_h(i,j) = Var_M_h(i,j) + S_weight_OK*(var_h_M(10,i,j));
%            mean_h_S(i,j) = mean(mean_h_M(:,i,j));
%            mean_h2_S(i,j) = mean(mean_h_M(:,i,j).^2);
%            Var_S_h(i,j) = var(mean_h_M(:,i,j));
            Var_S_h(i,j) = mean_h2_S(i,j) - mean_h_S(i,j).^2;
%            Var_M_h(i,j) = mean(var_h_M(:,i,j));
%            Var_T_h(i,j) = mean(mean_var_M(:,i,j));
            if (Var_S_h(i,j) < 0 )
                Var_S_h(i,j) = 0;
            end
            if (Var_M_h(i,j) < 0 )
                Var_M_h(i,j) = 0;
            end
            if (Var_T_h(i,j) < 0 )
                Var_T_h(i,j) = 0;
            end
            S_S_new(i,j,tt) = Var_S_h(i,j)/(Var_S_h(i,j)+Var_M_h(i,j)+Var_T_h(i,j));
            S_M_new(i,j,tt) = Var_M_h(i,j)/(Var_S_h(i,j)+Var_M_h(i,j)+Var_T_h(i,j));
            S_T_new(i,j,tt) = Var_T_h(i,j)/(Var_S_h(i,j)+Var_M_h(i,j)+Var_T_h(i,j));
        end
    end
end
