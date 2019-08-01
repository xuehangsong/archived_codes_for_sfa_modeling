
subplot(2,1,1);
hold all;
scatter3(Well_add_120(1:40,1),Well_add_120(1:40,2),120*ones(40,1),40,'ko','fill');
scatter3(60.11, 83.76,120,40,'ko','fill');
surface(1:120,1:120,krige_data','edgecolor','none');
set(gca,'fontsize',14)
caxis([96.5 102.5]);
view(2);
axis square;
colormap jet;
colorbar;
box on;
axis([1 120 1 120]);
xlabel('X (m)','fontsize',20);
ylabel('Y (m)','fontsize',20);
title('Kriging');
subplot(2,1,2);
hold all;
scatter3(Well_add_120(1:40,1),Well_add_120(1:40,2),120*ones(40,1),40,'ko','fill');
scatter3(60.11, 83.76,120,40,'ko','fill');
surface(1:120,1:120,CS(:,:,26)','edgecolor','none');
set(gca,'fontsize',14)
caxis([96.5 102.5]);
view(2);
axis square;
colorbar;
colormap jet;
box on;
axis([1 120 1 120]);
xlabel('X (m)','fontsize',20);
ylabel('Y (m)','fontsize',20);
title('Conditional Simulation');