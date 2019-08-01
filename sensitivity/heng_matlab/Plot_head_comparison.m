plot(1:192,Head_1_76_new{1}(1,:));
hold all;
plot(1:192,Head_1_76_old{1}(1,:));
legend('new simulation','old simulation');
xlabel('Time (h)');
ylabel('Hydraulic head (m)');
