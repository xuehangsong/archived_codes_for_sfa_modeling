S = 10;
M = 10;
mtx = 10;
nsim = 100;
for ii = 1:S
    for jj = 1:M
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

% for ii = 1:S
%     for jj = 1:M
%         mt = 0;
%         for i = 2:20:max(size(timec))-10
%             mt = mt + 1;
%             for k = 1:max(size(wellnamegroup))
%                 for j = 1:nsim-1
% %                   indext = find(time{ii,jj,j}==timec(i));
%                     %                    if j < 18
% %                     if ((max(size(fluxavc1t{ii,jj,j}(:,indext)))< max(size(wellnamegroup))) && k >(max(size(fluxavc1t{ii,jj,j}(:,indext)))))
% %                         disp(ii);disp(jj);disp(k);
% %                         fluxavc1_t(ii,jj,j,k,mt) = 1000*fluxavc1t{ii,jj-1,j}(k,indext);
% %                         %                        fluxavc2_t(ii,jj,j,k,mt) = 1000*fluxavc2t{ii,jj,j}(k,indext);
% %                     else
% %                         fluxavc1_t(ii,jj,j,k,mt) = 1000*fluxavc1t{ii,jj,j}(k,indext);
% %                         %                       fluxavc2_t(ii,jj,j,k,mt) = 1000*fluxavc2t{ii,jj,j+1}(k,indext);
% %                     end
% %                     if ii == 5 && jj == 7 && j == 16
% %                         fluxavc1_t(ii,jj,j,k,mt) = fluxavc1t{ii,jj,j-1}(k,indext);
% %                     end
%                     %                   fluxavc3_t(ii,jj,j,k,i) = fluxavc3t{ii,jj,j}(k,indext);
%                     if fluxavc1_t(ii,jj,j,k,mt) > 0.05
%                         cbreak1(k,mt) = 1;
%                     else
%                         cbreak1(k,mt) = 0;
%                     end
%                     %                     if fluxavc2_t(ii,jj,j,k,mt) > 0.05
%                     %                         cbreak2(k,mt) = 1;
%                     %                     else
%                     %                         cbreak2(k,mt) = 0;
%                     %                     end
%                 end
%             end
%         end
%         mtx = mt;
%     end
% end

for ii = 1:S
    for jj = 1:M
        for i = 1:max(size(wellnamegroup))
            for j = 1:mt
                mean_c1(ii,jj,i,j) = mean(fluxavc1_t(ii,jj,:,i,j));
                mean_c12(ii,jj,i,j) = mean(fluxavc1_t(ii,jj,:,i,j).^2);
                %               var_c1(ii,jj,i,j) = mean_c12(ii,jj,i,j) - mean_c1(ii,jj,i,j)^2;
                var_c1(ii,jj,i,j) = var(fluxavc1_t(ii,jj,:,i,j));
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
for i = 1:max(size(wellnamegroup))
    for j = 1:mt
        for ii = 1:S
            mean_c1_M(ii,i,j) = mean(mean_c1(ii,:,i,j));
            mean_c12_M(ii,i,j) = mean(mean_c12(ii,:,i,j));
            var_c1_M(ii,i,j) = var(mean_c1(ii,:,i,j));
            var_c1_M_1(ii,i,j) = mean_c12_M(ii,i,j) - mean_c1_M(ii,i,j).^2;
            mean_var_c1_M(ii,i,j) = mean(var_c1(ii,:,i,j));
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
        S_S_c1(i,j) = Var_S_c1(i,j)/(Var_S_c1(i,j)+Var_M_c1(i,j)+Var_T_c1(i,j));
        S_M_c1(i,j) = Var_M_c1(i,j)/(Var_S_c1(i,j)+Var_M_c1(i,j)+Var_T_c1(i,j));
        S_T_c1(i,j) = Var_T_c1(i,j)/(Var_S_c1(i,j)+Var_M_c1(i,j)+Var_T_c1(i,j));
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