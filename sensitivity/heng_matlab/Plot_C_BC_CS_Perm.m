nsim = 100;
for i = 1:4
    for j = 1:35
        %wellnamegroup_76{j} = strrep(wellnamegroup_76{j},'2-0','2-');
        wellnamegroup{j} = strrep(wellnamegroup{j},'2-0','2-');
        wellnamegroup_base{j} = strrep(wellnamegroup_base{j},'2-0','2-');
        for jj = 1:35
            if strcmp(wellnamegroup{j}(6:end),wellnamegroup_base{jj}(6:end))
                j9 = jj;
            end
        end
        %if strcmp(wellnamegroup{j}(6:end),wellnames_data{i})
        if strcmp(wellnamegroup{j}(6:end),wellnames_data{i})
            subplot(3,4,i);
            hold all;
            %plot(time_0{i},max((Br0{i}-mean(Br01{i}(end-10:end)))/100,0),'k*');
            for kk = 1:max(size(time_0{i}))
                if time_0{i}(kk)<192
                    Br0{i}(kk) = 0;
                end
            end
            %plot(time_0{i},Cl0{i}/100,'*');
            %h1 = plot(Time_76{1}(1,:),fluxavc3_76{1}(j,:)./0.001,'b-','LineWidth',2);
            h1 = plot(Time{1}(1,:),fluxavc2{1}(j,:)./0.001,'b-','LineWidth',2);
            for k = 10:10:nsim
                %    plot(Time_76{k},fluxavc3_76{k}(j,:)./0.001,'b-','LineWidth',2);
                plot(Time{k},fluxavc2{k}(j,:)./0.001,'b-','LineWidth',2);
            end
            %           h3 = plot(Time_base{35}(1,:),fluxavc2_base{35}(j9,:)/0.001,'r-','LineWidth',1.5);
            %           h4 = plot(Time_base{1}(1,:),fluxavc2_base{1}(j9,:)/0.001,'k-','LineWidth',1.5);
            h2 = plot(time_0{i},Br0{i}/100,'k*');
            xlim([0 1000]);
            ylim([0 1]);
            title(strrep(wellnamegroup{j},'_','-'));
            if i == 4
                legend([h1,h2],{'Material ID simulation results','Data'});
                %    legend([h1,h2],{'Permeability simulations','Data'});
            end
            if (i == 1)||(i == 5)||(i == 9)
                ylabel('Normalized concentration');
            elseif (i == 14)||(i == 15)||(i == 16)
                xlabel('Time (h)');
            elseif (i == 13)
                xlabel('Time (h)');
                ylabel('Normalized concentration');
            end
        end
    end
end

for i = 1:4
    for j = 1:35
        %wellnamegroup_76{j} = strrep(wellnamegroup_76{j},'2-0','2-');
        wellnamegroup{j} = strrep(wellnamegroup{j},'2-0','2-');
        wellnamegroup_base{j} = strrep(wellnamegroup_base{j},'2-0','2-');
        for jj = 1:35
            if strcmp(wellnamegroup{j}(6:end),wellnamegroup_base{jj}(6:end))
                j9 = jj;
            end
        end
        %if strcmp(wellnamegroup{j}(6:end),wellnames_data{i})
        if strcmp(wellnamegroup{j}(6:end),wellnames_data{i})
            subplot(3,4,i+4);
            hold all;
            %plot(time_0{i},max((Br0{i}-mean(Br01{i}(end-10:end)))/100,0),'k*');
            for kk = 1:max(size(time_0{i}))
                if time_0{i}(kk)<192
                    Br0{i}(kk) = 0;
                end
            end
            %plot(time_0{i},Cl0{i}/100,'*');
            %h1 = plot(Time_76{1}(1,:),fluxavc3_76{1}(j,:)./0.001,'b-','LineWidth',2);
            h1 = plot(Time{1}(1,:),fluxavc2_BC{1}(j,:)./0.001,'b-','LineWidth',2);
            for k = 10:10:nsim
                %    plot(Time_76{k},fluxavc3_76{k}(j,:)./0.001,'b-','LineWidth',2);
                plot(Time{k},fluxavc2_BC{k}(j,:)./0.001,'b-','LineWidth',2);
            end
            %           h3 = plot(Time_base{35}(1,:),fluxavc2_base{35}(j9,:)/0.001,'r-','LineWidth',1.5);
            %           h4 = plot(Time_base{1}(1,:),fluxavc2_base{1}(j9,:)/0.001,'k-','LineWidth',1.5);
            h2 = plot(time_0{i},Br0{i}/100,'k*');
            xlim([0 1000]);
            ylim([0 1]);
            title(strrep(wellnamegroup{j},'_','-'));
            if i == 4
                legend([h1,h2],{'Boundary condition simulation results','Data'});
                %    legend([h1,h2],{'Permeability simulations','Data'});
            end
            if (i == 1)||(i == 5)||(i == 9)
                ylabel('Normalized concentration');
            elseif (i == 14)||(i == 15)||(i == 16)
                xlabel('Time (h)');
            elseif (i == 13)
                xlabel('Time (h)');
                ylabel('Normalized concentration');
            end
        end
    end
end

for i = 1:4
    for j = 1:35
        %wellnamegroup_76{j} = strrep(wellnamegroup_76{j},'2-0','2-');
        wellnamegroup{j} = strrep(wellnamegroup{j},'2-0','2-');
        wellnamegroup_base{j} = strrep(wellnamegroup_base{j},'2-0','2-');
        for jj = 1:35
            if strcmp(wellnamegroup{j}(6:end),wellnamegroup_base{jj}(6:end))
                j9 = jj;
            end
        end
        %if strcmp(wellnamegroup{j}(6:end),wellnames_data{i})
        if strcmp(wellnamegroup{j}(6:end),wellnames_data{i})
            subplot(3,4,i+8);
            hold all;
            %plot(time_0{i},max((Br0{i}-mean(Br01{i}(end-10:end)))/100,0),'k*');
            for kk = 1:max(size(time_0{i}))
                if time_0{i}(kk)<192
                    Br0{i}(kk) = 0;
                end
            end
            %plot(time_0{i},Cl0{i}/100,'*');
            %h1 = plot(Time_76{1}(1,:),fluxavc3_76{1}(j,:)./0.001,'b-','LineWidth',2);
%             if i == 4
%                 h1 = plot(Time{1}(1,:),0.5*(fluxavc2_BC{1}(j,:)./0.001 + fluxavc2{1}(j,:)./0.001),'b-','LineWidth',2);
%                 for k = 10:10:nsim
%                 %    plot(Time_76{k},fluxavc3_76{k}(j,:)./0.001,'b-','LineWidth',2);
%                     plot(Time{k},0.5*(fluxavc2_BC{k}(j,:)./0.001+ fluxavc2{1}(j,:)./0.001),'b-','LineWidth',2);
%                 end
%             else
            h1 = plot(Time{1}(1,:),fluxavc2_perm{1}(j,:)./0.001,'b-','LineWidth',2);
            for k = 10:10:nsim
                %    plot(Time_76{k},fluxavc3_76{k}(j,:)./0.001,'b-','LineWidth',2);
                plot(Time{k},fluxavc2_perm{k}(j,:)./0.001,'b-','LineWidth',2);
            end
            %end
            %           h3 = plot(Time_base{35}(1,:),fluxavc2_base{35}(j9,:)/0.001,'r-','LineWidth',1.5);
            %           h4 = plot(Time_base{1}(1,:),fluxavc2_base{1}(j9,:)/0.001,'k-','LineWidth',1.5);
            h2 = plot(time_0{i},Br0{i}/100,'k*');
            xlim([0 1000]);
            ylim([0 1]);
            title(strrep(wellnamegroup{j},'_','-'));
            if i == 4
                legend([h1,h2],{'Permeability field simulation results','Data'});
                %    legend([h1,h2],{'Permeability simulations','Data'});
            end
            if (i+8 == 10)||(i+8 == 11)||(i+8 == 12)
                xlabel('Time (h)');
            elseif (i+8 == 9)
                xlabel('Time (h)');
                ylabel('Normalized concentration');
            end
        end
    end
end