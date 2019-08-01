ini_h_1 = load(sprintf('C:/Users/daih524/Desktop/2015_Spring/Larger_case_Dr_Chen/BC_UK1_BigPlume_2014/Initial_h_36_37.txt'));
ini_h_2 = load(sprintf('C:/Users/daih524/Desktop/2015_Spring/Larger_case_Dr_Chen/BC_UK1_BigPlume_2014/Initial_h_37.txt'));
ini_h_3 = load(sprintf('C:/Users/daih524/Desktop/2015_Spring/Larger_case_Dr_Chen/BC_UK1_BigPlume_2014/Initial_h_1_4.txt'));
h_initial = h5read('..\Larger_case_Dr_Chen\H_initial_hdf5_OK\H_initial_OK.h5','/Initial_Head/Data');
x1 = linspace(-448,448,225);
y1 = linspace(-798,798,400);

subplot(1,4,1);
surf(x1,y1,h_initial','edgecolor','none');
xlim([-450 450]);
ylim([-800 800]);
set(gca,'fontsize',14);
%set(gca, 'Position', [0.03 0.03 0.225*2 0.400*2])
xlabel('X','FontSize',18);
ylabel('Y','FontSize',18);
view(2);
box on;
caxis([104.7, 105.2]);

subplot(1,4,2);
surf(x1,y1,ini_h_2','edgecolor','none');
xlim([-450 450]);
ylim([-800 800]);
set(gca,'fontsize',14);
%set(gca, 'Position', [0.03 0.03 0.225*2 0.400*2])
xlabel('X','FontSize',18);
ylabel('Y','FontSize',18);
view(2);
caxis([104.7, 105.2]);
box on;

subplot(1,4,3);
surf(x1,y1,ini_h_1','edgecolor','none');
xlim([-450 450]);
ylim([-800 800]);
set(gca,'fontsize',14);
%set(gca, 'Position', [0.03 0.03 0.225*2 0.400*2])
xlabel('X','FontSize',18);
ylabel('Y','FontSize',18);
view(2);
caxis([104.7, 105.2]);
box on;

subplot(1,4,4);
surf(x1,y1,ini_h_3','edgecolor','none');
xlim([-450 450]);
ylim([-800 800]);
set(gca,'fontsize',14);
%set(gca, 'Position', [0.03 0.03 0.225*2 0.400*2])
xlabel('X','FontSize',18);
ylabel('Y','FontSize',18);
view(2);
caxis([104.7, 105.2]);
box on;
colorbar;