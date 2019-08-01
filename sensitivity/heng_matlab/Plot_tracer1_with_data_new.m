nsim = 1;
for i = 1:16
    for l = 1:10
        for k = 1:10
            for j = 1:82
                wellnamegroupt{l,k}{j} = strrep(wellnamegroupt{l,k}{j},'2-0','2-');
                %      wellnamegroup_76_old{j} = strrep(wellnamegroup_76_old{j},'2-0','2-');
                %         for jj = 1:82
                %             if strcmp(wellnamegroup_76_new{j}(6:end),wellnamegroup_76_old{jj}(6:end))
                %                 j9 = jj;
                %             end
                %         end
                %if strcmp(wellnamegroup{j}(6:end),wellnames_data{i})
                if strcmp(wellnamegroupt{l,k}{j}(6:end),wellnames_data{i})
                    subplot(4,4,i);
                    hold on;
                    %plot(time_0{i},max((Br0{i}-mean(Br01{i}(end-10:end)))/100,0),'k*');
                    for ii = 2:2:100
                        h2 = plot(Timet{l,k,ii}(1,:),fluxavc1t{l,k,ii}(j,:)/0.001,'b-','LineWidth',2);
                    end
                    %       plot(Time_base_old{1}(1,:),fluxavc1_base_old{1}(j9,:)/0.001,'-','LineWidth',2);
                    %             for kk = 1:max(size(time_0{i}))
                    %                 if time_0{i}(kk)<192
                    %                     Br0{i}(kk) = 0;
                    %                 end
                    %             end
                    %
                    h1 = plot(time_0{i},max((Cl0{i}-mean(Cl01{i}(end-10:end)))/100,0),'k.','markersize',15);
                    set(gca,'fontsize',16);
                    %             h1 = plot(Time_76{1}(1,:),fluxavc3_76{1}(j,:)./0.001,'b-','LineWidth',2);
                    %             for k = 10:10:nsim
                    %                 plot(Time_76{k},fluxavc3_76{k}(j,:)./0.001,'b-','LineWidth',2);
                    %             end
                    %h2 = plot(time_0{i},Br0{i}/100,'k*');
                    %plot(Time_76{7}(1,:),fluxavc3_76{31}(j,:)./0.001,'-','LineWidth',2);
                    %     plot(Time_76{7}(1,:),fluxavc2_76{7}(j,:)./0.001,'-','LineWidth',2);
                    %     plot(Time_76{31}(1,:),fluxavc2_76{31}(j,:)./0.001,'-','LineWidth',2);
                    %     plot(Time_76{65}(1,:),fluxavc2_76{65}(j,:)./0.001,'-','LineWidth',2);
                    %plot(time_0{i},max((F0{i}-mean(F01{i}(end-10:end)))/100,0),'k*');
                    %    plot(time_0{i},max((Cl0{i}-mean(Cl01{i}(end-10:end)))/100,0),'k*');
                    %       plot(time_0{i},Br0{i}/100,'k*');
                    %    set(gca,'fontsize',16)
                    %    axis([0 1000 0 0.9]);
                    xlim([0 190]);
                    ylim([0 1]);
                    title(strrep(wellnamegroupt{l,k}{j},'_',' '),'fontsize',16);
                    if i == 4
                        %    legend([h1,h2,h3],{'BC simulations','Data','Base case'});
                        %    legend([h1,h2],{'Permeability simulations','Data'});
                        legend([h1 h2],{'Observations','Simulations'});
                    end
                    if (i == 1)||(i == 5)||(i == 9)
                        ylabel('C/C_0','fontsize',20);
                    elseif (i == 14)||(i == 15)||(i == 16)
                        xlabel('Time (h)','fontsize',20);
                    elseif (i == 13)
                        xlabel('Time (h)','fontsize',20);
                        ylabel('C/C_0','fontsize',20);
                    end
                end
            end
        end
    end
end
%xlabel('Time (h)','fontsize',20);
%ylabel('Normalized concentration','fontsize',20);