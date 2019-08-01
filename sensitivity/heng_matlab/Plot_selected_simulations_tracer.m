nsim = 100;
for i = 1:16
    for j = 1:35
        wellnamegroup_76{j} = strrep(wellnamegroup_76{j},'2-0','2-');
        wellnamegroup_base{j} = strrep(wellnamegroup_base{j},'2-0','2-');
        for jj = 1:35
            if strcmp(wellnamegroup_76{j}(6:end),wellnamegroup_base{jj}(6:end))
                j9 = jj;
            end
        end
        %if strcmp(wellnamegroup{j}(6:end),wellnames_data{i})
        if strcmp(wellnamegroup_76{j}(6:end),wellnames_data{i})
            subplot(4,4,i);
            hold all;
            %plot(time_0{i},max((Br0{i}-mean(Br01{i}(end-10:end)))/100,0),'k*');
            plot(Time_base{76}(1,:),fluxavc2_base{76}(j9,:)/0.001,'-','LineWidth',2);
            for kk = 1:max(size(time_0{i}))
                if time_0{i}(kk)<192
                    Br0{i}(kk) = 0;
                end
            end
            %plot(time_0{i},Cl0{i}/100,'*');
%             h1 = plot(Time_76{1}(1,:),fluxavc3_76{1}(j,:)./0.001,'b-','LineWidth',2);
%             for k = 10:10:nsim
%                 plot(Time_76{k},fluxavc3_76{k}(j,:)./0.001,'b-','LineWidth',2);
%             end
                %h2 = plot(time_0{i},Br0{i}/100,'k*');
                 %plot(Time_76{7}(1,:),fluxavc3_76{31}(j,:)./0.001,'-','LineWidth',2);
                 plot(Time_76{7}(1,:),fluxavc2_76{7}(j,:)./0.001,'-','LineWidth',2);
                 plot(Time_76{31}(1,:),fluxavc2_76{31}(j,:)./0.001,'-','LineWidth',2);
                 plot(Time_76{65}(1,:),fluxavc2_76{65}(j,:)./0.001,'-','LineWidth',2);
                 %plot(time_0{i},max((F0{i}-mean(F01{i}(end-10:end)))/100,0),'k*');
             %    plot(time_0{i},max((Cl0{i}-mean(Cl01{i}(end-10:end)))/100,0),'k*');
                   plot(time_0{i},Br0{i}/100,'k*');
            %    set(gca,'fontsize',16)
            %    axis([0 1000 0 0.9]);
            xlim([0 1000]);
            ylim([0 1]);
            title(strrep(wellnamegroup{j},'_','-'));
            if i == 4
            %    legend([h1,h2,h3],{'BC simulations','Data','Base case'});
            %    legend([h1,h2],{'Permeability simulations','Data'});
                 legend('Base case','Simulation 7','Simulation 31','Simulation 65','Data');
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

%xlabel('Time (h)','fontsize',20);
%ylabel('Normalized concentration','fontsize',20);