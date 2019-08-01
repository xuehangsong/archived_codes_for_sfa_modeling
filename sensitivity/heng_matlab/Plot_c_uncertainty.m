for i = 1:4
    for j = 1:4
        subplot(4,4,j + (i-1)*4)
        hold all;
        for k = 1:5:100
            plot(timec(1:1003),fluxavc2t{i,j,k}(30,1:1003)/0.001,'b');
        end
        if j == 1 && i == 2
            ylabel('Normalized tracer 2 concentration','fontsize',16);
        end
        if i == 4 && j == 2
            xlabel('Time (hour)','fontsize',16);
        end
        legend(sprintf('Scenario %d Model %d',i,j));
    end
end
% for k= 1:1003
%     for i = 1:4
%         for j = 1:4      
%             for l = 1:100
%                 fluxavc1t_2_15(i,j,k,l) = fluxavc1t{i,j,l}(12,k);
%                 fluxavc2t_2_15(i,j,k,l) = fluxavc2t{i,j,l}(12,k);
%             end
%             fluxavc1t_2_15_mean(i,j,k) = mean(fluxavc1t_2_15(i,j,k,:));
%             fluxavc2t_2_15_mean(i,j,k) = mean(fluxavc2t_2_15(i,j,k,:));
%         end
%         fluxavc1t_2_15_mean_m(i,k) = mean(fluxavc1t_2_15_mean(i,:,k));
%         fluxavc2t_2_15_mean_m(i,k) = mean(fluxavc2t_2_15_mean(i,:,k));
%     end
%         fluxavc1t_2_15_mean_m_s(k) = mean(fluxavc1t_2_15_mean_m(:,k));
%         fluxavc2t_2_15_mean_m_s(k) = mean(fluxavc2t_2_15_mean_m(:,k));
% end
% m = 0;
% for i = 1:4
%     for j = 1:4
%         m = m + 1;
%         hold all;
%         ftemp(1:1003) = fluxavc1t_2_15_mean(i,j,1:1003)/0.001;
%         if i == 1
%             plot(timec(1:1003),ftemp(1:1003),'b','LineWidth',2);
%         elseif i == 2
%             plot(timec(1:1003),ftemp(1:1003),'r','LineWidth',2);
%         elseif i == 3
%             plot(timec(1:1003),ftemp(1:1003),'g','LineWidth',2);
%         elseif i == 4
%             plot(timec(1:1003),ftemp(1:1003),'k','LineWidth',2);
%         end
%         legendInfo{m} = sprintf('Scenario %d Model %d',i,j);
%     end
% end
% legend(legendInfo);
% xlabel('Time (hour)','fontsize',16);
% ylabel('Normalized tracer 1 concentration','fontsize',16);
% ftemp1(1:1003) = fluxavc1t_2_15_mean_m(1,1:1003)/0.001;
% ftemp2(1:1003) = fluxavc1t_2_15_mean_m(2,1:1003)/0.001;
% ftemp3(1:1003) = fluxavc1t_2_15_mean_m(3,1:1003)/0.001;
% ftemp4(1:1003) = fluxavc1t_2_15_mean_m(4,1:1003)/0.001;
% ftemp5(1:1003) = fluxavc1t_2_15_mean_m_s(1:1003)/0.001;
% hold all;
% plot(timec(1:1003),ftemp1(1:1003),'LineWidth',2);
% plot(timec(1:1003),ftemp2(1:1003),'LineWidth',2);
% plot(timec(1:1003),ftemp3(1:1003),'LineWidth',2);
% plot(timec(1:1003),ftemp4(1:1003),'LineWidth',2);
% plot(timec(1:1003),ftemp5(1:1003),'LineWidth',2);
% xlabel('Time (hour)','fontsize',16);
% ylabel('Normalized tracer 1 concentration','fontsize',16);
% legend('Model averaging under scenario 1','Model averaging under scenario 2','Model averaging under scenario 3','Model averaging under scenario 4','Scenario averaging');