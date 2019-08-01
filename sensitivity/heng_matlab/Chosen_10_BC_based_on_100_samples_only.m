nsim = 100;
t = 191;
init = 170;
istart = 170;
% clearvars BC_cs X1 BC_var_small dif_BC;
% for i = istart:init + t
%     BC_cs(:,:,i-169) = load(sprintf('C:\\Users\\daih524\\Desktop\\2015_Spring\\Data_for_Test_Case\\BC_Data_From_Chen\\4heng\\BC_CS\\BC%d.txt',i));
% end
% BC_cs(:,1:2,:) = [];
% hold all;
% 
% for i = 1:480
%     for j = 1:190
%         var_BC(i,j) = std(BC_cs(i,:,j));
%     end
% end
% ncom = 10e4;
% X1(1:ncom,1:9) = 0;
% BC_var_small(1:480,1:190) = 0;
% dif_BC(1:ncom) = 0;
% for i = 1:ncom
%     disp(i);
%    X1(i,:) = randperm(100,9);
%  %   for j = 1:480
%         for k = 1:190
%             BC_var_small(:,k) = std(BC_cs(:,X1(i,:),k),0,2);
%         end
%  %   end
%  dif_BC(i) = sum(sum(abs(BC_var_small(:,:) - var_BC(:,:))));
% end
% 
% BC_m = find(dif_BC == min(dif_BC));



for k = 1:190
    BC_var_small(:,k) = std(BC_cs(:,X1(BC_m,:),k),0,2);
end
subplot(2,2,1);
hold all;
%plot(1:120,var_BC(1:120,5),'LineWidth',3);
%plot(1:120,var_BC(1:120,10),'LineWidth',3);
% plot(1:120,var_BC(1:120,15),'LineWidth',3);
% plot(1:120,var_BC(1:120,20),'LineWidth',3);
% plot(1:120,var_BC(1:120,30),'LineWidth',3);
%plot(1:120,var_BC(1:120,50),'LineWidth',3);
plot(1:120,var_BC(1:120,100),'LineWidth',3);
plot(1:120,BC_var_small(1:120,100),'LineWidth',3);
%plot(1:120,var_BC(1:120,150),'LineWidth',3);
title('South BC at 100th hour','fontsize',16);
set(gca,'fontsize',16);
xlabel('X(m)','FontSize',18);
ylabel('Standard deviation of hydraulic head (m)','FontSize',18);
%legend('100 realizations','9 selected realizations' );

subplot(2,2,2);
hold all;
%plot(1:120,var_BC(1:120,5),'LineWidth',3);
%plot(1:120,var_BC(1:120,10),'LineWidth',3);
% plot(1:120,var_BC(1:120,15),'LineWidth',3);
% plot(1:120,var_BC(1:120,20),'LineWidth',3);
% plot(1:120,var_BC(1:120,30),'LineWidth',3);
%plot(1:120,var_BC(1:120,50),'LineWidth',3);
plot(1:120,var_BC(121:240,100),'LineWidth',3);
plot(1:120,BC_var_small(121:240,100),'LineWidth',3);
%plot(1:120,var_BC(1:120,150),'LineWidth',3);
title('North BC at 100th hour','fontsize',16);
set(gca,'fontsize',16);
xlabel('X(m)','FontSize',18);
%ylabel('Standard deviation of hydraulic head (m)','FontSize',18);
legend('100 realizations','9 selected realizations' );

subplot(2,2,3);
hold all;
%plot(1:120,var_BC(1:120,5),'LineWidth',3);
%plot(1:120,var_BC(1:120,10),'LineWidth',3);
% plot(1:120,var_BC(1:120,15),'LineWidth',3);
% plot(1:120,var_BC(1:120,20),'LineWidth',3);
% plot(1:120,var_BC(1:120,30),'LineWidth',3);
%plot(1:120,var_BC(1:120,50),'LineWidth',3);
plot(1:120,var_BC(241:360,100),'LineWidth',3);
plot(1:120,BC_var_small(241:360,100),'LineWidth',3);
%plot(1:120,var_BC(1:120,150),'LineWidth',3);
title('West BC at 100th hour','fontsize',16);
set(gca,'fontsize',16);
xlabel('Y(m)','FontSize',18);
%ylabel('Standard deviation of hydraulic head (m)','FontSize',18);
%legend('100 realizations','9 selected realizations' );

subplot(2,2,4);
hold all;
%plot(1:120,var_BC(1:120,5),'LineWidth',3);
%plot(1:120,var_BC(1:120,10),'LineWidth',3);
% plot(1:120,var_BC(1:120,15),'LineWidth',3);
% plot(1:120,var_BC(1:120,20),'LineWidth',3);
% plot(1:120,var_BC(1:120,30),'LineWidth',3);
%plot(1:120,var_BC(1:120,50),'LineWidth',3);
plot(1:120,var_BC(361:480,100),'LineWidth',3);
plot(1:120,BC_var_small(361:480,100),'LineWidth',3);
%plot(1:120,var_BC(1:120,150),'LineWidth',3);
ylim([0 0.03]);
title('East BC at 100th hour','fontsize',16);
set(gca,'fontsize',16);
xlabel('Y(m)','FontSize',18);
%ylabel('Standard deviation of hydraulic head (m)','FontSize',18);
%legend('100 realizations','9 selected realizations' );