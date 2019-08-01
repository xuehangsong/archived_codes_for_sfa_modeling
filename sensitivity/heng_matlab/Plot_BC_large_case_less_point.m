BC_East = h5read('..\Larger_case_Dr_Chen\BC_hdf5_OK\BC_OK.h5','/BC_East/Data');
BC_West = h5read('..\Larger_case_Dr_Chen\BC_hdf5_OK\BC_OK.h5','/BC_West/Data');
BC_North = h5read('..\Larger_case_Dr_Chen\BC_hdf5_OK\BC_OK.h5','/BC_North/Data');
BC_South = h5read('..\Larger_case_Dr_Chen\BC_hdf5_OK\BC_OK.h5','/BC_South/Data');
for i = 200:600:2000
    for j = 1:37
        BC(:,j,(i-200)/600+1) = load(sprintf('C:/Users/daih524/Desktop/2015_Spring/Larger_case_Dr_Chen/BC_UK1_BigPlume_2014/BC_height%d%d.txt',i,j));
    end
end
x1 = -798:4:798;
x2 = -448:4:448;
subplot(2,2,1);
hold all;
for i = 1:6:37
    plot(x1,BC(451:850,i,1),'LineWidth',2);
end
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
for i = 1:6:37
    plot(x1,BC(851:1250,i,1),'LineWidth',2);
end
plot(x1,BC_East(200,:),'*','LineWidth',2);
legend(labels1{1:6:37},'All points');
title('East BC','fontsize',16);
set(gca,'fontsize',16)
xlabel('Y','FontSize',18);
ylabel('h (m)','FontSize',18);
xlim([x1(1) x1(end)]);
box on;
subplot(2,2,3);
hold all;
for i = 1:6:37
    plot(x2,BC(226:450,i,1),'LineWidth',2);
end
plot(x2,BC_North(200,:),'*','LineWidth',2);
title('North BC','fontsize',16);
set(gca,'fontsize',16)
xlabel('X','FontSize',18);
ylabel('h (m)','FontSize',18);
xlim([x2(1) x2(end)]);
box on;
subplot(2,2,4);
hold all;
for i = 1:6:37
    plot(x2,BC(1:225,i,1),'LineWidth',2);
end
plot(x2,BC_South(200,:),'*','LineWidth',2);
title('South BC','fontsize',16);
set(gca,'fontsize',16)
xlabel('X','FontSize',18);
ylabel('h (m)','FontSize',18);
xlim([x2(1) x2(end)]);
box on;