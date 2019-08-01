for i = 200:600:2000
    BC2(:,(i-200)/600+1) = load(sprintf('C:/Users/daih524/Desktop/2015_Spring/Larger_case_Dr_Chen/BC_UK1_BigPlume_2014/BC_height%d14.txt',i));
    BC3(:,(i-200)/600+1) = load(sprintf('C:/Users/daih524/Desktop/2015_Spring/Larger_case_Dr_Chen/BC_UK1_BigPlume_2014/BC_height%d3637.txt',i));
end
x1 = -798:4:798;
x2 = -448:4:448;
subplot(2,2,1);
hold all;
plot(x1,BC2(451:850,1),'LineWidth',2);
plot(x1,BC3(451:850,1),'LineWidth',2);
plot(x1,BC_West(200,:),'*','LineWidth',2);
title('West BC','fontsize',16);
set(gca,'fontsize',16)
xlabel('Y','FontSize',18);
ylabel('h (m)','FontSize',18);
xlim([x1(1) x1(end)]);
box on;
%legend(labels1{1:6:37});
subplot(2,2,2);
hold all;
plot(x1,BC2(851:1250,1),'LineWidth',2);
plot(x1,BC3(851:1250,1),'LineWidth',2);
plot(x1,BC_East(200,:),'*','LineWidth',2);
legend('Missing 1 and 4','Missing 36 and 37','All points');
title('East BC','fontsize',16);
set(gca,'fontsize',16)
xlabel('Y','FontSize',18);
ylabel('h (m)','FontSize',18);
xlim([x1(1) x1(end)]);
box on;
subplot(2,2,3);
hold all;
plot(x2,BC2(226:450,1),'LineWidth',2);
plot(x2,BC3(226:450,1),'LineWidth',2);
plot(x2,BC_North(200,:),'*','LineWidth',2);
title('North BC','fontsize',16);
set(gca,'fontsize',16)
xlabel('X','FontSize',18);
ylabel('h (m)','FontSize',18);
xlim([x2(1) x2(end)]);
box on;
subplot(2,2,4);
hold all;
plot(x2,BC2(1:225,1),'LineWidth',2);
plot(x2,BC3(226:450,1),'LineWidth',2);
plot(x2,BC_South(200,:),'*','LineWidth',2);
title('South BC','fontsize',16);
set(gca,'fontsize',16)
xlabel('X','FontSize',18);
ylabel('h (m)','FontSize',18);
xlim([x2(1) x2(end)]);
box on;