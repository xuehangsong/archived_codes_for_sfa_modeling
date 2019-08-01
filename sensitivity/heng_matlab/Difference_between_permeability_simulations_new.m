nsim = 100;
for i = 1:16
    for j = 1:35
        wellnamegroup_base_new{j} = strrep(wellnamegroup_base_new{j},'2-0','2-');
        %         wellnamegroup_9_base{j} = strrep(wellnamegroup_9_base{j},'2-0','2-');
        %         for jj = 1:35
        %             if strcmp(wellnamegroup{j}(6:end),wellnamegroup_9_base{jj}(6:end))
        %                 j9 = jj;
        %             end
        %         end
        if strcmp(wellnamegroup_base_new{j}(6:end),wellnames_data{i})
            for kk = 1:max(size(time_0{i}))
                if time_0{i}(kk)<192
                    Br0{i}(kk) = 0;
                end
            end
            Br_revise{i} = max(Br0{i}/100,0);
            Cl_revise{i} = max((Cl0{i}-mean(Cl01{i}(end-10:end)))/100,0);
            F_revise{i} = max((F0{i}-mean(F01{i}(end-10:end)))/100,0);
            for k = 1:nsim
                fluxavc1_interp{k,i} = interp1(Time_base_new{k}(j,2:end),fluxavc1_base_new{k}(j,2:end),time_0{i}(find(time_0{i}>=1):find(time_0{i}>=192)-1));
%                fluxavc2_interp{k,i} = interp1(Time_base{k}(j,2:end),fluxavc2_base{k}(j,2:end),time_0{i}(find(time_0{i}>=1):find(time_0{i}>=1000)-1));
%                fluxavc3_interp{k,i} = interp1(Time_base{k}(j,2:end),fluxavc3_base{k}(j,2:end),time_0{i}(find(time_0{i}>=1):find(time_0{i}>=1000)-1));
                distance_1t(k,i) = sum(abs(fluxavc1_interp{k,i}-Cl_revise{i}(find(time_0{i}>=1):find(time_0{i}>=192)-1)));
%                distance_2t(k,i) = sum(abs(fluxavc2_interp{k,i}-Br_revise{i}(find(time_0{i}>=1):find(time_0{i}>=1000)-1)));
%                distance_3t(k,i) = sum(abs(fluxavc3_interp{k,i}-F_revise{i}(find(time_0{i}>=1):find(time_0{i}>=1000)-1)));
            end
        end
    end
end
for i = 1:nsim
    distance_1(i) = sum(distance_1t(i,:));
%    distance_2(i) = sum(distance_2t(i,:));
%    distance_3(i) = sum(distance_3t(i,:));
%    distance_12(i) = distance_1(i) + distance_2(i);
end
