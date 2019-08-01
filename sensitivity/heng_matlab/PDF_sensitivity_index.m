n = 120;
for i = 1:4
S_S_temp(1:n^2,i) = reshape(S_S(:,:,i),[n^2 1]);
S_T_temp(1:n^2,i) = reshape(S_T(:,:,i),[n^2 1]);
S_S_temp_c1(1:n^2,i) = reshape(S_S_c1(:,:,i),[n^2 1]);
S_T_temp_c1(1:n^2,i) = reshape(S_T_c1(:,:,i),[n^2 1]);
end
% subplot(1,2,1);
% hold all;
% for i = 1:4
% xx = linspace(0.4,1.05,2000);
% [f] = ksdensity(S_S_temp(:,i),xx);
% h = plot(xx,f,'-','LineWidth',3);
% end
% set(gca,'fontsize',20);
% xlabel('S_S');
% ylabel('PDF');
% box on;
% legend('10 hours','50 hours','100 hours','150 hours');
% subplot(1,2,2);
% hold all;
% for i = 1:4
% xx = linspace(-0.1,0.6,2000);
% [f] = ksdensity(S_T_temp(:,i),xx);
% h = plot(xx,f,'-','LineWidth',3);
% end
% set(gca,'fontsize',20);
% box on;
% xlabel('S_T');
% ylabel('PDF');
% legend('10 hours','50 hours','100 hours','150 hours');

% subplot(1,2,1);
% hold all;
% for i = 1:4
% xx = linspace(-0.05,1.05,2000);
% [f] = ksdensity(S_S_temp_c1(:,i),xx);
% h = plot(xx,f,'-','LineWidth',3);
% end
% set(gca,'fontsize',20);
% xlabel('S_S');
% ylabel('PDF');
% xlim([-0.1 0.6]);
% box on;
% legend('10 hours','50 hours','100 hours','150 hours');
% subplot(1,2,2);
% hold all;
% for i = 1:4
% xx = linspace(0.4,1.05,2000);
% [f] = ksdensity(S_T_temp_c1(:,i),xx);
% h = plot(xx,f,'-','LineWidth',3);
% end
% set(gca,'fontsize',20);
% box on;
% xlabel('S_T');
% xlim([0.4 1.1]);
% ylabel('PDF');
% legend('10 hours','50 hours','100 hours','150 hours');



for i = 1:4
subplot(2,2,i);
qqplot(S_S_temp_c1(:,i));
set(gca,'fontsize',18);
box on;
end
