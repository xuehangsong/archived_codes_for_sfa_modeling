% nsim = 98;
% for i = 1:nsim
%     CS_cs(1:14400,i) = load(sprintf('C:\\Users\\daih524\\Desktop\\2015_Spring\\Data_for_Test_Case\\BC_Data_From_Chen\\4heng\\CS_CS\\CS%d.txt',i));
%     CS(1:120,1:120,i) = reshape(CS_cs(:,i),[120 120]);
% end
% data2 = h5read('C:\Users\daih524\Desktop\2015_Spring\Sensitivity_Analysis\Test_Case\plot120x120x15_ngrid120x120x30_material.h5','/Materials/Material Ids');
% datanew = reshape(data2,[120 120 30]);
% for i = 1:120
%     for j = 1:120
%          a = find(datanew(j,i,:) == 4,1,'last');
%          depth(j,i) = 95 + a*0.5;
%     end
% end
% subplot(2,2,1);
% surface(1:120,1:120,depth');
% set(gca,'fontsize',14)
% caxis([96.5 102.5]);
% xlabel('X','fontsize',20);
% ylabel('Y','fontsize',20);
% title('Base case');
subplot(1,2,1);
hold all;
surface(1:120,1:120,CS(:,:,55)');
set(gca,'fontsize',14)
caxis([96.5 102.5]);
xlabel('X (m)','fontsize',20);
ylabel('Y (m)','fontsize',20);
title('Conditional Simulation 55');
%plot(Well_in_120(:,1),Well_in_120(:,2),'o');
scatter3(Well_in_120(:,1),Well_in_120(:,2),120*ones(40,1),150,'ko');
set(gca,'fontsize',16)
text(Well_in_120(:,1), Well_in_120(:,2), 120*ones(40,1),labels1, 'VerticalAlignment','bottom', ...
                             'HorizontalAlignment','right')
%xlabel('X','fontsize',16);
%ylabel('Y','fontsize',16);
subplot(1,2,2);
hold all;
surface(1:120,1:120,CS(:,:,81)');
set(gca,'fontsize',14)
caxis([96.5 102.5]);
xlabel('X (m)','fontsize',20);
ylabel('Y (m)','fontsize',20);
title('Conditional Simulation 81');
scatter3(Well_in_120(:,1),Well_in_120(:,2),120*ones(40,1),150,'ko');
set(gca,'fontsize',16)
text(Well_in_120(:,1), Well_in_120(:,2), 120*ones(40,1),labels1, 'VerticalAlignment','bottom', ...
                             'HorizontalAlignment','right')
% subplot(2,2,3);
% hold all;
% surface(1:120,1:120,CS(:,:,98)');
% set(gca,'fontsize',14)
% xlabel('X (m)','fontsize',20);
% ylabel('Y (m)','fontsize',20);
% title('Conditional Simulation 3');
% scatter3(Well_in_120(:,1),Well_in_120(:,2),120*ones(40,1),150,'ko');
% set(gca,'fontsize',16)
% text(Well_in_120(:,1), Well_in_120(:,2), 120*ones(40,1),labels1, 'VerticalAlignment','bottom', ...
%                              'HorizontalAlignment','right')
% caxis([96.5 102.5]);
% subplot(2,2,4);
% hold all;
% surface(1:120,1:120,CS(:,:,97)');
% set(gca,'fontsize',14)
% xlabel('X (m)','fontsize',20);
% ylabel('Y (m)','fontsize',20);
% title('Conditional Simulation 4');
% scatter3(Well_in_120(:,1),Well_in_120(:,2),120*ones(40,1),150,'ko');
% set(gca,'fontsize',16)
% text(Well_in_120(:,1), Well_in_120(:,2), 120*ones(40,1),labels1, 'VerticalAlignment','bottom', ...
%                              'HorizontalAlignment','right')
% caxis([96.5 102.5]);