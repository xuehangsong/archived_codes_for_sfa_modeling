nsim = 100;
for i = 1:16
    for j = 1:82
        wellnamegroup{j} = strrep(wellnamegroup{j},'2-0','2-');
        wellnamegroup_m_76{j} = strrep(wellnamegroup_m_76{j},'2-0','2-');
        wellnamegroup_base{j} = strrep(wellnamegroup_base{j},'2-0','2-');
        wellnamegroup_76K{j} = strrep(wellnamegroup_76K{j},'2-0','2-');
        for jj = 1:35
            if strcmp(wellnamegroup_m_76{j}(6:end),wellnamegroup_base{jj}(6:end))
                j9 = jj;
            end
            if strcmp(wellnamegroup_m_76{j}(6:end),wellnamegroup_76K{jj}(6:end))
                j10 = jj;
            end
        end
        %if strcmp(wellnamegroup{j}(6:end),wellnames_data{i})
        if strcmp(wellnamegroup_m_76{j}(6:end),wellnames_data{i})
            subplot(4,4,i);
            hold all;
            %plot(time_0{i},max((Br0{i}-mean(Br01{i}(end-10:end)))/100,0),'k*');
            for kk = 1:max(size(time_0{i}))
                if time_0{i}(kk)<192
                    Br0{i}(kk) = 0;
                end
            end
            %plot(time_0{i},Cl0{i}/100,'*');
            h1 = plot(Time{1}(1,:),fluxavc2_m_76{1}(j,:)./0.001,'b-','LineWidth',2);
            %h1 = plot(Time_35{1}(1,:),fluxavc2_35{1}(j,:)./0.001,'b-','LineWidth',2);
            for k = 10:10:nsim
            %    plot(Time_76{k},fluxavc3_76{k}(j,:)./0.001,'b-','LineWidth',2);
                plot(Time{k},fluxavc2_m_76{k}(j,:)./0.001,'b-','LineWidth',2);
            end
            h3 = plot(Time_base{76}(1,:),fluxavc2_base{76}(j9,:)/0.001,'r-','LineWidth',1.5);
 %           h4 = plot(Time_base{1}(1,:),fluxavc2_base{1}(j9,:)/0.001,'k-','LineWidth',1.5);
            h4 = plot(Time_76K{1}(1,:),fluxavc2_76K{1}(j10,:)/0.001,'k-','LineWidth',1.5);
            h2 = plot(time_0{i},Br0{i}/100,'k*');
   
            %    h2 = plot(time_0{i},max((F0{i}-mean(F01{i}(end-10:end)))/100,0),'k*');
            %    h2 = plot(time_0{i},max((Cl0{i}-mean(Cl01{i}(end-10:end)))/100,0),'k*');
            %    set(gca,'fontsize',16)
            %    axis([0 1000 0 0.9]);

            xlim([0 1000]);
            ylim([0 1]);
            title(strrep(wellnamegroup{j},'_','-'));
            if i == 4
        %        legend([h1,h2,h3,h4],{'Material ID simulations permeability 76','Data','Base case permeability 76','Base case permeability 1'});
                legend([h1,h2,h3,h4],{'Material ID simulations permeability 76','Data','Base case permeability 76','Kriging case permeability 76'});
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

%xlabel('Time (h)','fontsize',20);
%ylabel('Normalized concentration','fontsize',20);