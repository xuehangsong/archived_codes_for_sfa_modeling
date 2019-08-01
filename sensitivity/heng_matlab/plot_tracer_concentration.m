nsim = 100;
subplot(2,2,1);
hold all;
plot(time_0{1},max((Cl0{1}-mean(Cl01{1}(end-10:end)))/100,0),'*-','LineWidth',2);
for k = 1:nsim
    plot(Time{k},fluxavc1{k}(30,:)./0.001);
end
set(gca,'fontsize',16)
%    axis([0 1000 0 0.9]);
xlim([0 1000]);
title(wellnames_data{1});
legend('Well data','Simulation results');
xlabel('Time (h)','fontsize',20);
ylabel('Normalized concentration','fontsize',20);
subplot(2,2,2);
hold all;
plot(time_0{1},max((Cl0{1}-mean(Cl01{1}(end-10:end)))/100,0),'*-','LineWidth',2);
for k = 1:nsim
    plot(Time{k},fluxavc1{k}(30,:)./0.001);
end
set(gca,'fontsize',16)
%    axis([0 1000 0 0.9]);
xlim([0 1000]);
title(wellnames_data{1});
legend('Well data','Simulation results');
xlabel('Time (h)','fontsize',20);
ylabel('Normalized concentration','fontsize',20);