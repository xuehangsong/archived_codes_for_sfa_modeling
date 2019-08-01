
%S and M are reversed because of the reading order of the hdf5 data.
mx = 120;
my = 120;
M = 10;
S = 10;
for tt = 1:4
for ii = 1:S
    for jj = 1:M
        for i = 1:mx
            for j = 1:my
                mean_c1(ii,jj,i,j) = mean(tracer_total(tt,ii,jj,:,i,j));
                mean_c12(ii,jj,i,j) = mean(tracer_total(tt,ii,jj,:,i,j).^2);
                %               var_c1(ii,jj,i,j) = mean_c12(ii,jj,i,j) - mean_c1(ii,jj,i,j)^2;
                var_c1(ii,jj,i,j) = var(tracer_total(tt,ii,jj,:,i,j));
                %                mean_c2(ii,jj,i,j) = mean(fluxavc2_t(ii,jj,:,i,j));
                %                mean_c22(ii,jj,i,j) = mean(fluxavc2_t(ii,jj,:,i,j).^2);
                %                var_c2(ii,jj,i,j) = mean_c22(ii,jj,i,j) - mean_c2(ii,jj,i,j)^2;
                %                var_c2(ii,jj,i,j) = var(fluxavc2_t(ii,jj,:,i,j));
                %                mean_c3(ii,jj,i,j) = mean(fluxavc3_t(ii,jj,:,i,j));
                %                mean_c32(ii,jj,i,j) = mean(fluxavc3_t(ii,jj,:,i,j).^2);
                %                var_c3(ii,jj,i,j) = mean_c32(ii,jj,i,j) - mean_c3(ii,jj,i,j)^2;
                %                var_c3(ii,jj,i,j) = var(fluxavc3_t(ii,jj,:,i,j));
            end
        end
    end
end
for i = 1:mx
    for j = 1:my
        for ii = 1:S
            mean_c1_M(ii,i,j) = mean(mean_c1(:,ii,i,j));
            mean_c12_M(ii,i,j) = mean(mean_c12(:,ii,i,j));
            var_c1_M(ii,i,j) = var(mean_c1(:,ii,i,j));
            var_c1_M_1(ii,i,j) = mean_c12_M(ii,i,j) - mean_c1_M(ii,i,j).^2;
            mean_var_c1_M(ii,i,j) = mean(var_c1(:,ii,i,j));
            %             mean_c2_M(ii,i,j) = mean(mean_c2(ii,:,i,j));
            %             mean_c22_M(ii,i,j) = mean(mean_c22(ii,:,i,j));
            %             var_c2_M(ii,i,j) = var(mean_c2(ii,:,i,j));
            %             var_c2_M_1(ii,i,j) = mean_c22_M(ii,i,j) - mean_c2_M(ii,i,j).^2;
            %             mean_var_c2_M(ii,i,j) = mean(var_c2(ii,:,i,j));
            %            mean_c3_M(ii,i,j) = mean(mean_c3(ii,:,i,j));
            %            mean_c32_M(ii,i,j) = mean(mean_c32(ii,:,i,j));
            %            var_c3_M(ii,i,j) = mean_c32_M(ii,i,j) - mean_c3_M(ii,i,j).^2;
            %            mean_var_c3_M(ii,i,j) = mean(var_c3(ii,:,i,j));
        end
        mean_c1_S(i,j) = mean(mean_c1_M(:,i,j));
        mean_c12_S(i,j) = mean(mean_c1_M(:,i,j).^2);
        Var_S_c1(i,j) = var(mean_c1_M(:,i,j));
        Var_S_c1_1(i,j) = mean_c12_S(i,j) - mean_c1_S(i,j).^2;
        Var_M_c1(i,j) = mean(var_c1_M(:,i,j));
        Var_T_c1(i,j) = mean(mean_var_c1_M(:,i,j));
        S_S_c1(i,j,tt) = Var_S_c1(i,j)/(Var_S_c1(i,j)+Var_M_c1(i,j)+Var_T_c1(i,j));
        S_M_c1(i,j,tt) = Var_M_c1(i,j)/(Var_S_c1(i,j)+Var_M_c1(i,j)+Var_T_c1(i,j));
        S_T_c1(i,j,tt) = Var_T_c1(i,j)/(Var_S_c1(i,j)+Var_M_c1(i,j)+Var_T_c1(i,j));
        %         mean_c2_S(i,j) = mean(mean_c2_M(:,i,j));
        %         mean_c22_S(i,j) = mean(mean_c2_M(:,i,j).^2);
        %         Var_S_c2(i,j) = var(mean_c2_M(:,i,j));
        %         Var_S_c2_1(i,j) = mean_c22_S(i,j) - mean_c2_S(i,j).^2;
        %         Var_M_c2(i,j) = mean(var_c2_M(:,i,j));
        %         Var_T_c2(i,j) = mean(mean_var_c2_M(:,i,j));
        %         S_S_c2(i,j) = Var_S_c2(i,j)/(Var_S_c2(i,j)+Var_M_c2(i,j)+Var_T_c2(i,j));
        %         S_M_c2(i,j) = Var_M_c2(i,j)/(Var_S_c2(i,j)+Var_M_c2(i,j)+Var_T_c2(i,j));
        %         S_T_c2(i,j) = Var_T_c2(i,j)/(Var_S_c2(i,j)+Var_M_c2(i,j)+Var_T_c2(i,j));
        %         mean_c3_S(i,j) = mean(mean_c3_M(:,i,j));
        %         mean_c32_S(i,j) = mean(mean_c3_M(:,i,j).^2);
        %         Var_S_c3(i,j) = mean_c32_S(i,j) - mean_c3_S(i,j).^2;
        %         Var_M_c3(i,j) = mean(var_c3_M(:,i,j));
        %         Var_T_c3(i,j) = mean(mean_var_c1_M(:,i,j));
        %         S_S_c3(i,j) = Var_S_c3(i,j)/(Var_S_c3(i,j)+Var_M_c3(i,j)+Var_T_c3(i,j));
        %         S_M_c3(i,j) = Var_M_c3(i,j)/(Var_S_c3(i,j)+Var_M_c3(i,j)+Var_T_c3(i,j));
        %         S_T_c3(i,j) = Var_T_c3(i,j)/(Var_S_c3(i,j)+Var_M_c3(i,j)+Var_T_c3(i,j));
    end
end
end
