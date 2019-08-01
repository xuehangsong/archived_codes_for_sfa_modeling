spc_max = max(spc_data_all);
spc_min = min(spc_data_all);
spc_dif = spc_max - spc_min;
ratio = 300/spc_dif;
t_end = 730/24;

subplot(5,3,1);
hold all;
t1 = Well_data_1_21A(:,1)-41365;
Well_data_1_21A_spc = 1000*Well_data_1_21A(:,2);
Well_data_1_21A_spc(Well_data_1_21A_spc == 0) = [];
t1(Well_data_1_21A_spc == 0) = [];
in_end = find(t1 >= t_end, 1, 'first');
for i = 1:nsim
    h1 = plot(Time{i}(17,:),fluxavc1{i}(17,:),'blue','LineWidth',4);
end
[haxes,hline1,hline2] = plotyy(t1(1:in_end)*24,max(1.5-Well_data_1_21A_spc(1:in_end)/300,0),t1(1:in_end)*24,Well_data_1_21A_spc(1:in_end));
%legend([h1 hline1],{'Simulated','Observed'});
set(haxes,'fontsize',14);
set(hline1,'LineWidth',1,'marker','.','color','red');
set(hline2,'LineStyle','--','LineWidth',4);
% ylabel(haxes(1),'River water fraction'); % label left y-axis
% ylabel(haxes(2),'SpC'); % label right y-axis
% xlabel(haxes(2),'Time (hour)');
set(haxes,'xlim',[0 730]);
set(haxes(1),'ylim',[-0.1 1.1]);
set(gca,'YTick',[linspace(0,1,3)]);
set(haxes(2),'YTick',[linspace(150,510,4)]);
set(haxes(2),'ylim',[150 510]);
title('1-21A','fontsize',14);
box on;


% subplot(4,4,2);
% hold all;
% t1 = Well_data_1_21B(:,1)-41365;
% in_end = find(t1 >= t_end, 1, 'first');
% [haxes,hline1,hline2] = plotyy(t1(1:in_end)*24,1.5-Well_data_1_21A_spc(1:in_end)/300,t1(1:in_end)*24,Well_data_1_21A_spc(1:in_end));
% for i = 1:nsim
%     h1 = plot(Time{i}(6,:),fluxavc1{i}(6,:),'r','LineWidth',4);
% end
% %legend([h1],{'Simulated'});
% set(haxes,'fontsize',14);
% set(hline1,'LineWidth',4);
% set(hline2,'LineStyle','--','LineWidth',4);
% % ylabel(haxes(1),'River water fraction'); % label left y-axis
% % ylabel(haxes(2),'SpC'); % label right y-axis
% % xlabel(haxes(2),'Time (hour)');
% set(haxes,'xlim',[0 730]);
% set(haxes(1),'ylim',[-0.1 1.1]);
% set(gca,'YTick',[linspace(0,1,3)]);
% set(haxes(2),'YTick',[linspace(150,510,4)]);
% set(haxes(2),'ylim',[150 510]);
% title('Well 399-1-21B','fontsize',14);
% box on;


subplot(5,3,2);
hold all;
t1 = Well_data_1_60(:,1)-41365;
Well_data_1_60_spc = 1000*Well_data_1_60(:,2);
t1(Well_data_1_60_spc == 0) = [];
Well_data_1_60_spc(Well_data_1_60_spc == 0) = [];
in_end = find(t1 >= t_end, 1, 'first');
for i = 1:nsim
    h1 = plot(Time{i}(4,:),fluxavc1{i}(4,:),'blue','LineWidth',4);
end
[haxes,hline1,hline2] = plotyy(t1(1:in_end)*24,max(1.5-Well_data_1_60_spc(1:in_end)/300,0),t1(1:in_end)*24,Well_data_1_60_spc(1:in_end));
%legend([h1 hline1],{'Simulated','Observed'});
set(haxes,'fontsize',14);
set(hline1,'LineWidth',1,'marker','.','color','red');
set(hline2,'LineStyle','--','LineWidth',4);
% ylabel(haxes(1),'River water fraction'); % label left y-axis
% ylabel(haxes(2),'SpC'); % label right y-axis
% xlabel(haxes(2),'Time (hour)');
set(haxes,'xlim',[0 730]);
set(haxes(1),'ylim',[-0.1 1.1]);
set(gca,'YTick',[linspace(0,1,3)]);
set(haxes(2),'YTick',[linspace(150,510,4)]);
set(haxes(2),'ylim',[150 510]);
title('1-60','fontsize',14);
box on;

subplot(5,3,4);
hold all;
t1 = Well_data_2_1(:,1)-41365;
Well_data_2_1_spc = 1000*Well_data_2_1(:,2);
t1(Well_data_2_1_spc == 0) = [];
Well_data_2_1_spc(Well_data_2_1_spc == 0) = [];
in_end = find(t1 >= t_end, 1, 'first');
for i = 1:nsim
    h1 = plot(Time{i}(1,:),fluxavc1{i}(1,:),'blue','LineWidth',4);
end
[haxes,hline1,hline2] = plotyy(t1(1:in_end)*24,max(1.5-Well_data_2_1_spc(1:in_end)/300,0),t1(1:in_end)*24,Well_data_2_1_spc(1:in_end));
legend([h1 hline1],{'Simulation','Observed data'});
set(haxes,'fontsize',14);
set(hline1,'LineWidth',1,'marker','.','color','red');
set(hline2,'LineStyle','--','LineWidth',4);
% ylabel(haxes(1),'River water fraction'); % label left y-axis
% ylabel(haxes(2),'SpC'); % label right y-axis
% xlabel(haxes(2),'Time (hour)');
set(haxes,'xlim',[0 730]);
set(haxes(1),'ylim',[-0.1 1.1]);
set(gca,'YTick',[linspace(0,1,3)]);
set(haxes(2),'YTick',[linspace(150,510,4)]);
set(haxes(2),'ylim',[150 510]);
title('2-01','fontsize',14);
box on;


subplot(5,3,5);
hold all;
t1 = Well_data_2_2(:,1)-41365;
Well_data_2_2_spc = 1000*Well_data_2_2(:,2);
t1(Well_data_2_2_spc == 0) = [];
Well_data_2_2_spc(Well_data_2_2_spc == 0) = [];
in_end = find(t1 >= t_end, 1, 'first');
for i = 1:nsim
    h1 = plot(Time{i}(8,:),fluxavc1{i}(8,:),'blue','LineWidth',4);
end
[haxes,hline1,hline2] = plotyy(t1(1:in_end)*24,max(1.5-Well_data_2_2_spc(1:in_end)/300,0),t1(1:in_end)*24,Well_data_2_2_spc(1:in_end));
%legend([h1 hline1],{'Simulated','Observed'});
set(haxes,'fontsize',14);
set(hline1,'LineWidth',1,'marker','.','color','red');
set(hline2,'LineStyle','--','LineWidth',4);
ylabel(haxes(1),'River water fraction'); % label left y-axis
% ylabel(haxes(2),'SpC'); % label right y-axis
% xlabel(haxes(2),'Time (hour)');
set(haxes,'xlim',[0 730]);
set(haxes(1),'ylim',[-0.1 1.1]);
set(gca,'YTick',[linspace(0,1,3)]);
set(haxes(2),'YTick',[linspace(150,510,4)]);
set(haxes(2),'ylim',[150 510]);
title('2-02','fontsize',14);
box on;


subplot(5,3,6);
hold all;
t1 = Well_data_2_3(:,1)-41365;
Well_data_2_3_spc = 1000*Well_data_2_3(:,2);
Well_data_2_3_spc(Well_data_2_3_spc == 0) = [];
t1(Well_data_2_3_spc == 0) = [];
in_end = find(t1 >= t_end, 1, 'first');
for i = 1:nsim
    h1 = plot(Time{i}(7,:),fluxavc1{i}(7,:),'blue','LineWidth',4);
end
[haxes,hline1,hline2] = plotyy(t1(1:in_end)*24,max(1.5-Well_data_2_3_spc(1:in_end)/300,0),t1(1:in_end)*24,Well_data_2_3_spc(1:in_end));
%legend([h1 hline1],{'Simulated','Observed'});
set(haxes,'fontsize',14);
set(hline1,'LineWidth',1,'marker','.','color','red');
set(hline2,'LineStyle','--','LineWidth',4);
% ylabel(haxes(1),'River water fraction'); % label left y-axis
% ylabel(haxes(2),'SpC'); % label right y-axis
% xlabel(haxes(2),'Time (hour)');
set(haxes,'xlim',[0 730]);
set(haxes(1),'ylim',[-0.1 1.1]);
set(gca,'YTick',[linspace(0,1,3)]);
set(haxes(2),'YTick',[linspace(150,510,4)]);
set(haxes(2),'ylim',[150 510]);
title('2-03','fontsize',14);
box on;


subplot(5,3,7);
hold all;
t1 = Well_data_2_5(:,1)-41365;
Well_data_2_5_spc = 1000*Well_data_2_5(:,2);
t1(Well_data_2_5_spc == 0) = [];
Well_data_2_5_spc(Well_data_2_5_spc == 0) = [];
in_end = find(t1 >= t_end, 1, 'first');
for i = 1:nsim
    h1 = plot(Time{i}(11,:),fluxavc1{i}(11,:),'blue','LineWidth',4);
end
[haxes,hline1,hline2] = plotyy(t1(1:in_end)*24,max(1.5-Well_data_2_5_spc(1:in_end)/300,0),t1(1:in_end)*24,Well_data_2_5_spc(1:in_end));
%legend([h1 hline1],{'Simulated','Observed'});
set(haxes,'fontsize',14);
set(hline1,'LineWidth',1,'marker','.','color','red');
set(hline2,'LineStyle','--','LineWidth',4);
%ylabel(haxes(1),'River water fraction'); % label left y-axis
%ylabel(haxes(2),'SpC'); % label right y-axis
%xlabel(haxes(2),'Time (hour)');
set(haxes,'xlim',[0 730]);
set(haxes(1),'ylim',[-0.1 1.1]);
set(gca,'YTick',[linspace(0,1,3)]);
set(haxes(2),'YTick',[linspace(150,510,4)]);
set(haxes(2),'ylim',[150 510]);
title('2-05','fontsize',14);
box on;


subplot(5,3,8);
hold all;
t1 = Well_data_2_10(:,1)-41365;
Well_data_2_10_spc = 1000*Well_data_2_10(:,2);
t1(Well_data_2_10_spc == 0) = [];
Well_data_2_10_spc(Well_data_2_10_spc == 0) = [];
in_end = find(t1 >= t_end, 1, 'first');
for i = 1:nsim
    h1 = plot(Time{i}(16,:),fluxavc1{i}(16,:),'blue','LineWidth',4);
end
[haxes,hline1,hline2] = plotyy(t1(1:in_end)*24,max(1.5-Well_data_2_10_spc(1:in_end)/300,0),t1(1:in_end)*24,Well_data_2_10_spc(1:in_end));
%legend([h1 hline1],{'Simulated','Observed'});
set(haxes,'fontsize',14);
set(hline1,'LineWidth',1,'marker','.','color','red');
set(hline2,'LineStyle','--','LineWidth',4);
%ylabel(haxes(1),'River water fraction'); % label left y-axis
ylabel(haxes(2),'SpC (\mus/cm)'); % label right y-axis
%xlabel(haxes(2),'Time (hour)');
set(haxes,'xlim',[0 730]);
set(haxes(1),'ylim',[-0.1 1.1]);
set(gca,'YTick',[linspace(0,1,3)]);
set(haxes(2),'YTick',[linspace(150,510,4)]);
set(haxes(2),'ylim',[150 510]);
title('2-10','fontsize',14);
box on;


% subplot(5,3,8);
% hold all;
% t1 = Well_data_2_10(:,1)-41365;
% Well_data_2_10_spc = 1000*Well_data_2_10(:,2);
% t1(Well_data_2_10_spc == 0) = [];
% Well_data_2_10_spc(Well_data_2_10_spc == 0) = [];
% in_end = find(t1 >= t_end, 1, 'first');
% for i = 1:nsim
%     h1 = plot(Time{i}(4,:),fluxavc1{i}(4,:),'r','LineWidth',4);
% end
% [haxes,hline1,hline2] = plotyy(t1(1:in_end)*24,1.5-Well_data_2_10_spc(1:in_end)/300,t1(1:in_end)*24,Well_data_2_10_spc(1:in_end));
% %legend([h1],{'Simulated'});
% set(haxes,'fontsize',14);
% set(hline1,'LineWidth',4);
% set(hline2,'LineStyle','--','LineWidth',4);
% % ylabel(haxes(1),'River water fraction'); % label left y-axis
% % ylabel(haxes(2),'SpC'); % label right y-axis
% % xlabel(haxes(2),'Time (hour)');
% set(haxes,'xlim',[0 730]);
% set(haxes(1),'ylim',[-0.1 1.1]);
% set(gca,'YTick',[linspace(0,1,3)]);
% set(haxes(2),'YTick',[linspace(150,510,4)]);
% set(haxes(2),'ylim',[150 510]);
% title('Well 399-2-25','fontsize',14);
% box on;


subplot(5,3,9);
hold all;
t1 = Well_data_2_32(:,1)-41365;
Well_data_2_32_spc = 1000*Well_data_2_32(:,2);
t1(Well_data_2_32_spc == 0) = [];
Well_data_2_32_spc(Well_data_2_32_spc == 0) = [];
in_end = find(t1 >= t_end, 1, 'first');
for i = 1:nsim
    h1 = plot(Time{i}(18,:),fluxavc1{i}(18,:),'blue','LineWidth',4);
end
[haxes,hline1,hline2] = plotyy(t1(1:in_end)*24,max(1.5-Well_data_2_32_spc(1:in_end)/300, 0),t1(1:in_end)*24,Well_data_2_32_spc(1:in_end));
%legend([h1 hline1],{'Simulated','Observed'});
set(haxes,'fontsize',14);
set(hline1,'LineWidth',1,'marker','.','color','red');
set(hline2,'LineStyle','--','LineWidth',4);
% ylabel(haxes(1),'River water fraction'); % label left y-axis
% ylabel(haxes(2),'SpC'); % label right y-axis
% xlabel(haxes(2),'Time (hour)');
set(haxes,'xlim',[0 730]);
set(haxes(1),'ylim',[-0.1 1.1]);
set(gca,'YTick',[linspace(0,1,3)]);
set(haxes(2),'YTick',[linspace(150,510,4)]);
set(haxes(2),'ylim',[150 510]);
title('2-32','fontsize',14);
box on;


subplot(5,3,10);
hold all;
t1 = Well_data_2_33(:,1)-41365;
Well_data_2_33_spc = 1000*Well_data_2_33(:,2);
Well_data_2_33_spc(Well_data_2_33_spc == 0) = [];
t1(Well_data_2_33_spc == 0) = [];
in_end = find(t1 >= t_end, 1, 'first');
for i = 1:nsim
    h1 = plot(Time{i}(5,:),fluxavc1{i}(5,:),'blue','LineWidth',4);
end
[haxes,hline1,hline2] = plotyy(t1(1:in_end)*24,max(1.5-Well_data_2_33_spc(1:in_end)/300,0),t1(1:in_end)*24,Well_data_2_33_spc(1:in_end));
%legend([h1 hline1],{'Simulated','Observed'});
set(haxes,'fontsize',14);
set(hline1,'LineWidth',1,'marker','.','color','red');
set(hline2,'LineStyle','--','LineWidth',4);
% ylabel(haxes(1),'River water fraction'); % label left y-axis
% ylabel(haxes(2),'SpC'); % label right y-axis
% xlabel(haxes(2),'Time (hour)');
set(haxes,'xlim',[0 730]);
set(haxes(1),'ylim',[-0.1 1.1]);
set(gca,'YTick',[linspace(0,1,3)]);
set(haxes(2),'YTick',[linspace(150,510,4)]);
set(haxes(2),'ylim',[150 510]);
title('2-33','fontsize',14);
box on;


subplot(5,3,11);
hold all;
t1 = Well_data_3_18(:,1)-41365;
Well_data_3_18_spc = 1000*Well_data_3_18(:,2);
t1(Well_data_3_18_spc == 0) = [];
Well_data_3_18_spc(Well_data_3_18_spc == 0) = [];
in_end = find(t1 >= t_end, 1, 'first');
for i = 1:nsim
    h1 = plot(Time{i}(9,:),fluxavc1{i}(9,:),'blue','LineWidth',4);
end
[haxes,hline1,hline2] = plotyy(t1(1:in_end)*24,max(1.5-Well_data_3_18_spc(1:in_end)/300,0),t1(1:in_end)*24,Well_data_3_18_spc(1:in_end));
%legend([h1 hline1],{'Simulated','Observed'});
set(haxes,'fontsize',14);
set(hline1,'LineWidth',1,'marker','.','color','red');
set(hline2,'LineStyle','--','LineWidth',4);
% ylabel(haxes(1),'River water fraction'); % label left y-axis
% ylabel(haxes(2),'SpC'); % label right y-axis
% xlabel(haxes(2),'Time (hour)');
set(haxes,'xlim',[0 730]);
set(haxes(1),'ylim',[-0.1 1.1]);
set(gca,'YTick',[linspace(0,1,3)]);
set(haxes(2),'YTick',[linspace(150,510,4)]);
set(haxes(2),'ylim',[150 510]);
title('3-18','fontsize',14);
box on;


subplot(5,3,12);
hold all;
t1 = Well_data_3_26(:,1)-41365;
Well_data_3_26_spc = 1000*Well_data_3_26(:,2);
t1(Well_data_3_26_spc == 0) = [];
Well_data_3_26_spc(Well_data_3_26_spc == 0) = [];
in_end = find(t1 >= t_end, 1, 'first');
for i = 1:nsim
    h1 = plot(Time{i}(10,:),fluxavc1{i}(10,:),'blue','LineWidth',4);
end
[haxes,hline1,hline2] = plotyy(t1(1:in_end)*24,max(1.5-Well_data_3_26_spc(1:in_end)/300,0),t1(1:in_end)*24,Well_data_3_26_spc(1:in_end));
%legend([h1 hline1],{'Simulated','Observed'});
set(haxes,'fontsize',14);
set(hline1,'LineWidth',1,'marker','.','color','red');
set(hline2,'LineStyle','--','LineWidth',4);
% ylabel(haxes(1),'River water fraction'); % label left y-axis
% ylabel(haxes(2),'SpC'); % label right y-axis
% xlabel(haxes(2),'Time (hour)');
set(haxes,'xlim',[0 730]);
set(haxes(1),'ylim',[-0.1 1.1]);
set(gca,'YTick',[linspace(0,1,3)]);
set(haxes(2),'YTick',[linspace(150,510,4)]);
set(haxes(2),'ylim',[150 510]);
title('3-26','fontsize',14);
box on;


subplot(5,3,13);
hold all;
t1 = Well_data_3_29(:,1)-41365;
Well_data_3_29_spc = 1000*Well_data_3_29(:,2);
t1(Well_data_3_29_spc == 0) = [];
Well_data_3_29_spc(Well_data_3_29_spc == 0) = [];
in_end = find(t1 >= t_end, 1, 'first');
for i = 1:nsim
    h1 = plot(Time{i}(13,:),fluxavc1{i}(13,:),'blue','LineWidth',4);
end
[haxes,hline1,hline2] = plotyy(t1(1:in_end)*24,max(1.5-Well_data_3_29_spc(1:in_end)/300,0),t1(1:in_end)*24,Well_data_3_29_spc(1:in_end));
%legend([h1 hline1],{'Simulated','Observed'});
set(haxes,'fontsize',14);
set(hline1,'LineWidth',1,'marker','.','color','red');
set(hline2,'LineStyle','--','LineWidth',4);
% ylabel(haxes(1),'River water fraction'); % label left y-axis
% ylabel(haxes(2),'SpC'); % label right y-axis
xlabel(haxes(2),'Time (hour)');
set(haxes,'xlim',[0 730]);
set(haxes(1),'ylim',[-0.1 1.1]);
set(gca,'YTick',[linspace(0,1,3)]);
set(haxes(2),'YTick',[linspace(150,510,4)]);
set(haxes(2),'ylim',[150 510]);
title('3-29','fontsize',14);
box on;


subplot(5,3,14);
hold all;
t1 = Well_data_3_34(:,1)-41365;
Well_data_3_34_spc = 1000*Well_data_3_34(:,2);
Well_data_3_34_spc(Well_data_3_34_spc == 0) = [];
t1(Well_data_3_34_spc == 0) = [];
in_end = find(t1 >= t_end, 1, 'first');
for i = 1:nsim
    h1 = plot(Time{i}(3,:),fluxavc1{i}(3,:),'blue','LineWidth',4);
end
[haxes,hline1,hline2] = plotyy(t1(1:in_end)*24,max(1.5-Well_data_3_34_spc(1:in_end)/300,0),t1(1:in_end)*24,Well_data_3_34_spc(1:in_end));
%legend([h1 hline1],{'Simulated','Observed'});
set(haxes,'fontsize',14);
set(hline1,'LineWidth',1,'marker','.','color','red');
set(hline2,'LineStyle','--','LineWidth',4);
% ylabel(haxes(1),'River water fraction'); % label left y-axis
% ylabel(haxes(2),'SpC'); % label right y-axis
% xlabel(haxes(2),'Time (hour)');
set(haxes,'xlim',[0 730]);
set(haxes(1),'ylim',[-0.1 1.1]);
set(gca,'YTick',[linspace(0,1,3)]);
set(haxes(2),'YTick',[linspace(150,510,4)]);
set(haxes(2),'ylim',[150 510]);
title('3-34','fontsize',14);
box on;


subplot(5,3,15);
hold all;
t1 = Well_data_3_37(:,1)-41365;
Well_data_3_37_spc = 1000*Well_data_3_37(:,2);
t1(Well_data_3_37_spc == 0) = [];
Well_data_3_37_spc(Well_data_3_37_spc == 0) = [];
in_end = find(t1 >= t_end, 1, 'first');
for i = 1:nsim
    h1 = plot(Time{i}(14,:),fluxavc1{i}(14,:),'blue','LineWidth',4);
end
[haxes,hline1,hline2] = plotyy(t1(1:in_end)*24,max(1.5-Well_data_3_37_spc(1:in_end)/300,0),t1(1:in_end)*24,Well_data_3_37_spc(1:in_end));
%legend([h1 hline1],{'Simulated','Observed'});
set(haxes,'fontsize',14);
set(hline1,'LineWidth',1,'marker','.','color','red');
set(hline2,'LineStyle','--','LineWidth',4);
% ylabel(haxes(1),'River water fraction'); % label left y-axis
% ylabel(haxes(2),'SpC'); % label right y-axis
% xlabel(haxes(2),'Time (hour)');
set(haxes,'xlim',[0 730]);
set(haxes(1),'ylim',[-0.1 1.1]);
set(gca,'YTick',[linspace(0,1,3)]);
set(haxes(2),'YTick',[linspace(150,510,4)]);
set(haxes(2),'ylim',[150 510]);
title('3-37','fontsize',14);
box on;