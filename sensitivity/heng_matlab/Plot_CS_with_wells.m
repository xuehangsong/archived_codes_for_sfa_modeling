hold all;
surface(1:120,1:120,CS(:,:,100)');
set(gca,'fontsize',14)
caxis([96.5 102.5]);
xlabel('X (m)','fontsize',20);
ylabel('Y (m)','fontsize',20);
title('Conditional Simulation 1');
%plot(Well_in_120(:,1),Well_in_120(:,2),'o');
scatter3(Well_in_120(:,1),Well_in_120(:,2),120*ones(40,1),150,'ko');
set(gca,'fontsize',16)
text(Well_in_120(:,1), Well_in_120(:,2), 120*ones(40,1),labels1, 'VerticalAlignment','bottom', ...
                             'HorizontalAlignment','right')