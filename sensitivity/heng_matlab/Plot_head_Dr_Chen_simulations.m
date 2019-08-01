nsim = 200;
t_end = 41365 + 730/24;

subplot(4,4,1);
hold all;
in_end = find(Well_data_1_21A(:,1) >= t_end, 1, 'first');
for i = 11:10:nsim-9
    plot(Time{i}(1,:),Head_1{i}(obs_index{17}(3),:),'b','LineWidth',10);
end
h1 = plot(Time{1}(1,:),Head_1{1}(obs_index{17}(3),:),'b','LineWidth',10);
h2 = plot((Well_data_1_21A(1:in_end,1)-41365)*24,Well_data_1_21A(1:in_end,3),'ko','MarkerSize',5);
set(gca,'fontsize',14)
%legend([h1 h2], {'Simulation results','Data'});
%xlabel('Time (hour)','fontsize',16);
%ylabel('Hydraulic head (m)','fontsize',16);
title('Well 399-1-21A','fontsize',14);
ylim([104.5 107])
xlim([0 730]);
box on;
subplot(4,4,2);
hold all;
in_end = find(Well_data_1_21B(:,1) >= t_end, 1, 'first');
for i = 11:10:nsim-9
    plot(Time{i}(1,:),Head_1{i}(obs_index{6}(1),:),'b','LineWidth',10);
end
h1 = plot(Time{1}(1,:),Head_1{1}(obs_index{6}(1),:),'b','LineWidth',10);
h2 = plot((Well_data_1_21B(1:in_end,1)-41365)*24,Well_data_1_21B(1:in_end,3),'ko','MarkerSize',5);
set(gca,'fontsize',14)
ylim([104.5 107]);
xlim([0 730]);
%legend([h1 h2],{'Data','Simulation results'});
%xlabel('Time (hour)','fontsize',16);
%ylabel('Hydraulic head (m)','fontsize',16);
title('Well 399-1-21B','fontsize',14);
box on;
subplot(4,4,3);
hold all;
in_end = find(Well_data_1_60(:,1) >= t_end, 1, 'first');
for i = 11:10:nsim-9
    plot(Time{i}(1,:),Head_1{i}(obs_index{3}(1),:),'b','LineWidth',10);
end
h1 = plot(Time{1}(1,:),Head_1{1}(obs_index{3}(1),:),'b','LineWidth',10);
h2 = plot((Well_data_1_60(1:in_end,1)-41365)*24,Well_data_1_60(1:in_end,3),'ko','MarkerSize',5);
set(gca,'fontsize',14)
ylim([104.5 107]);
xlim([0 730]);
%legend('Data','Simulation results');
%xlabel('Time (hour)','fontsize',16);
%ylabel('Hydraulic head (m)','fontsize',16);
title('Well 399-1-60','fontsize',14);
box on;
subplot(4,4,4);
hold all;
in_end = find(Well_data_2_1(:,1) >= t_end, 1, 'first');
for i = 11:10:nsim-9
    plot(Time{i}(1,:),Head_1{i}(obs_index{2}(1),:),'b','LineWidth',10);
end
h2 = plot(Time{1}(1,:),Head_1{1}(obs_index{2}(1),:),'b','LineWidth',10);
h1 = plot((Well_data_2_1(1:in_end,1)-41365)*24,Well_data_2_1(1:in_end,3),'ko','MarkerSize',5);
set(gca,'fontsize',14)
ylim([104.5 107]);
xlim([0 730]);
legend([h1 h2],{'Data','Simulation results'});
%xlabel('Time (hour)','fontsize',16);
%ylabel('Hydraulic head (m)','fontsize',16);
title('Well 399-2-01','fontsize',14);
box on;

subplot(4,4,5);
hold all;
in_end = find(Well_data_2_2(:,1) >= t_end, 1, 'first');
for i = 1:10:nsim-9
    plot(Time{i}(1,:),Head_1{i}(obs_index{8}(3),:),'b','LineWidth',10);
end
plot((Well_data_2_2(1:in_end,1)-41365)*24,Well_data_2_2(1:in_end,3),'ko','MarkerSize',5);
set(gca,'fontsize',14)
%legend('Data','Simulation results');
%xlabel('Time (hour)','fontsize',16);
ylabel('Hydraulic head (m)','fontsize',24);
title('Well 399-2-02','fontsize',14);
ylim([104.5 107]);
xlim([0 730]);
box on;
subplot(4,4,6);
hold all;
in_end = find(Well_data_2_3(:,1) >= t_end, 1, 'first');
for i = 1:10:nsim-9
    plot(Time{i}(1,:),Head_1{i}(obs_index{7}(1),:),'b','LineWidth',10);
end
plot((Well_data_2_3(1:in_end,1)-41365)*24,Well_data_2_3(1:in_end,3),'ko','MarkerSize',5);
set(gca,'fontsize',14)
ylim([104.5 107]);
xlim([0 730]);
%legend('Data','Simulation results');
%xlabel('Time (hour)','fontsize',16);
%ylabel('Hydraulic head (m)','fontsize',16);
title('Well 399-2-03','fontsize',14);
box on;
subplot(4,4,7);
hold all;
in_end = find(Well_data_2_5(:,1) >= t_end, 1, 'first');
for i = 1:10:nsim-9
    plot(Time{i}(1,:),Head_1{i}(obs_index{11}(1),:),'b','LineWidth',10);
end
plot((Well_data_2_5(1:in_end,1)-41365)*24,Well_data_2_5(1:in_end,3),'ko','MarkerSize',5);
set(gca,'fontsize',14)
ylim([104.5 107]);
xlim([0 730]);
%legend('Data','Simulation results');
%xlabel('Time (hour)','fontsize',16);
%ylabel('Hydraulic head (m)','fontsize',16);
title('Well 399-2-05','fontsize',14);
box on;
subplot(4,4,8);
hold all;
in_end = find(Well_data_2_10(:,1) >= t_end, 1, 'first');
for i = 1:10:nsim-9
    plot(Time{i}(1,:),Head_1{i}(obs_index{16}(1),:),'b','LineWidth',10);
end
plot((Well_data_2_10(1:in_end,1)-41365)*24,Well_data_2_10(1:in_end,3),'ko','MarkerSize',5);
set(gca,'fontsize',14)
ylim([104.5 107]);
xlim([0 730]);
%legend('Data','Simulation results');
%xlabel('Time (hour)','fontsize',16);
%ylabel('Hydraulic head (m)','fontsize',16);
title('Well 399-2-10','fontsize',14);
box on;


subplot(4,4,9);
hold all;
in_end = find(Well_data_2_25(:,1) >= t_end, 1, 'first');
for i = 1:10:nsim-9
    plot(Time{i}(1,:),Head_1{i}(obs_index{4}(5),:),'b','LineWidth',10);
end
plot((Well_data_2_25(1:in_end,1)-41365)*24,Well_data_2_25(1:in_end,3),'ko','MarkerSize',5);
set(gca,'fontsize',14)
%legend('Data','Simulation results');
%xlabel('Time (hour)','fontsize',16);
%ylabel('Hydraulic head (m)','fontsize',16);
title('Well 399-2-25','fontsize',14);
ylim([104.5 107]);
xlim([0 730]);
box on;
subplot(4,4,10);
hold all;
in_end = find(Well_data_2_32(:,1) >= t_end, 1, 'first');
for i = 1:10:nsim-9
    plot(Time{i}(1,:),Head_1{i}(obs_index{18}(1),:),'b','LineWidth',10);
end
plot((Well_data_2_32(1:in_end,1)-41365)*24,Well_data_2_32(1:in_end,3),'ko','MarkerSize',5);
set(gca,'fontsize',14)
ylim([104.5 107]);
xlim([0 730]);
%legend('Data','Simulation results');
%xlabel('Time (hour)','fontsize',16);
%ylabel('Hydraulic head (m)','fontsize',16);
title('Well 399-2-32','fontsize',14);
box on;
subplot(4,4,11);
hold all;
in_end = find(Well_data_2_32(:,1) >= t_end, 1, 'first');
for i = 1:10:nsim-9
    plot(Time{i}(1,:),Head_1{i}(obs_index{5}(1),:),'b','LineWidth',10);
end
plot((Well_data_2_33(1:in_end,1)-41365)*24,Well_data_2_33(1:in_end,3),'ko','MarkerSize',5);
set(gca,'fontsize',14)
ylim([104.5 107]);
xlim([0 730]);
%legend('Data','Simulation results');
%xlabel('Time (hour)','fontsize',16);
%ylabel('Hydraulic head (m)','fontsize',16);
title('Well 399-2-33','fontsize',14);
box on;
subplot(4,4,12);
hold all;
in_end = find(Well_data_3_18(:,1) >= t_end, 1, 'first');
for i = 1:10:nsim-9
    plot(Time{i}(1,:),Head_1{i}(obs_index{9}(1),:),'b','LineWidth',10);
end
plot((Well_data_3_18(1:in_end,1)-41365)*24,Well_data_3_18(1:in_end,3),'ko','MarkerSize',5);
set(gca,'fontsize',14)
ylim([104.5 107]);
xlim([0 730]);
%legend('Data','Simulation results');
%xlabel('Time (hour)','fontsize',16);
%ylabel('Hydraulic head (m)','fontsize',16);
title('Well 399-3-18','fontsize',14);
box on;



subplot(4,4,13);
hold all;
in_end = find(Well_data_3_26(:,1) >= t_end, 1, 'first');
for i = 1:10:nsim-9
    plot(Time{i}(1,:),Head_1{i}(obs_index{10}(3),:),'b','LineWidth',10);
end
plot((Well_data_3_26(1:in_end,1)-41365)*24,Well_data_3_26(1:in_end,3),'ko','MarkerSize',5);
set(gca,'fontsize',14)
%legend('Data','Simulation results');
%xlabel('Time (hour)','fontsize',16);
%ylabel('Hydraulic head (m)','fontsize',16);
title('Well 399-3-26','fontsize',14);
ylim([104.5 107]);
xlim([0 730]);
box on;
subplot(4,4,14);
hold all;
in_end = find(Well_data_3_29(:,1) >= t_end, 1, 'first');
for i = 1:10:nsim-9
    plot(Time{i}(1,:),Head_1{i}(obs_index{13}(1),:),'b','LineWidth',10);
end
plot((Well_data_3_29(1:in_end,1)-41365)*24,Well_data_3_29(1:in_end,3),'ko','MarkerSize',5);
set(gca,'fontsize',14)
ylim([104.5 107]);
xlim([0 730]);
%legend('Data','Simulation results');
%xlabel('Time (hour)','fontsize',16);
%ylabel('Hydraulic head (m)','fontsize',16);
title('Well 399-3-29','fontsize',14);
box on;
subplot(4,4,15);
hold all;
in_end = find(Well_data_3_34(:,1) >= t_end, 1, 'first');
for i = 1:10:nsim-9
    plot(Time{i}(1,:),Head_1{i}(obs_index{1}(1),:),'b','LineWidth',10);
end
plot((Well_data_3_34(1:in_end,1)-41365)*24,Well_data_3_34(1:in_end,3),'ko','MarkerSize',5);
set(gca,'fontsize',14)
ylim([104.5 107]);
xlim([0 730]);
%legend('Data','Simulation results');
xlabel('Time (hour)','fontsize',24);
%ylabel('Hydraulic head (m)','fontsize',16);
title('Well 399-3-34','fontsize',14);
box on;
subplot(4,4,16);
hold all;
in_end = find(Well_data_3_37(:,1) >= t_end, 1, 'first');
for i = 1:10:nsim-9
    plot(Time{i}(1,:),Head_1{i}(obs_index{14}(1),:),'b','LineWidth',10);
end
plot((Well_data_3_37(1:in_end,1)-41365)*24,Well_data_3_37(1:in_end,3),'ko','MarkerSize',5);
set(gca,'fontsize',14)
ylim([104.5 107]);
xlim([0 730]);
%legend('Data','Simulation results');
%xlabel('Time (hour)','fontsize',16);
%ylabel('Hydraulic head (m)','fontsize',16);
title('Well 399-3-37','fontsize',14);
box on;