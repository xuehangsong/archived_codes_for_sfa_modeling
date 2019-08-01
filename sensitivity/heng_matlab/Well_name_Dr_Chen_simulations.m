labels{1} = 'Well_399-1-21A';
labels{2} = 'Well_399-1-21B';
labels{3} = 'Well_399-1-60';
labels{4} = 'Well_399-2-01';
labels{5} = 'Well_399-2-02';
labels{6} = 'Well_399-2-03';
labels{7} = 'Well_399-2-05';
labels{9} = 'Well_399-2-10';
labels{11} = 'Well_399-2-25';
labels{12} = 'Well_399-2-32';
labels{13} = 'Well_399-2-33';
labels{14} = 'Well_399-3-18';
labels{15} = 'Well_399-3-26';
labels{16} = 'Well_399-3-29';
labels{17} = 'Well_399-3-34';
labels{18} = 'Well_399-3-37';
nsim = 200;
subplot(2,2,1);
hold all;
plot(Well_data_1_21A(:,1)-41365,Well_data_1_21A(:,3),'k*');
for i = 1:20:nsim-19
    plot(Time{i},Head_1{i}(obs_index{17}(3),:),'b');
end
legend('Data','Simulation results');
xlabel('Time (hour)');
ylabel('Hydraulic head (m)');
title('Well 399-1-21A');
ylim([104.5 107]);
subplot(2,2,2);
hold all;
plot(Well_data_1_21B(:,1)-41365,Well_data_1_21B(:,3),'k*');
for i = 1:20:nsim-19
    plot(Time{i},Head_1{i}(obs_index{6}(1),:),'b');
end
ylim([104.5 107]);
legend('Data','Simulation results');
xlabel('Time (hour)');
ylabel('Hydraulic head (m)');
title('Well 399-1-21B');
subplot(2,2,3);
hold all;
plot(Well_data_1_60(:,1)-41365,Well_data_1_60(:,3),'k*');
for i = 1:20:nsim-19
    plot(Time{i},Head_1{i}(obs_index{3}(1),:),'b');
end
ylim([104.5 107]);
legend('Data','Simulation results');
xlabel('Time (hour)');
ylabel('Hydraulic head (m)');
title('Well 399-1-60');
subplot(2,2,4);
hold all;
plot(Well_data_2_1(:,1)-41365,Well_data_2_1(:,3),'k*');
for i = 1:20:nsim-19
    plot(Time{i},Head_1{i}(obs_index{2}(1),:),'b');
end
ylim([104.5 107]);
legend('Data','Simulation results');
xlabel('Time (hour)');
ylabel('Hydraulic head (m)');
title('Well 399-2-01');