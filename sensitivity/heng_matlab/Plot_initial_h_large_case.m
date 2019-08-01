subplot(2,2,1);
h_initial = h5read('..\Larger_case_Dr_Chen\H_initial_hdf5_OK_2015-2016\H_initial_OK.h5','/Initial_Head/Data');
y1 = linspace(-448,448,225);
x1 = linspace(-798,798,400);
surf(y1,x1,h_initial,'edgecolor','none');
xlim([-450 450]);
ylim([-800 800]);
% xlim([0 400]);
% ylim([0 400]);
set(gca,'fontsize',14);
%set(gca, 'Position', [0.03 0.03 0.400*2 0.225*2])
xlabel('X','FontSize',18);
ylabel('Y','FontSize',18);
view(2);
box on;
colorbar;

subplot(2,2,2);
h_initial = h5read('..\Larger_case_Dr_Chen\H_initial_hdf5_OK_2015-2016_Wrong\H_initial_OK.h5','/Initial_Head/Data');
y1 = linspace(-448,448,225);
x1 = linspace(-798,798,400);
surf(y1,x1,h_initial,'edgecolor','none');
xlim([-450 450]);
ylim([-800 800]);
% xlim([0 400]);
% ylim([0 400]);
set(gca,'fontsize',14);
%set(gca, 'Position', [0.03 0.03 0.400*2 0.225*2])
xlabel('X','FontSize',18);
ylabel('Y','FontSize',18);
view(2);
box on;
colorbar;

subplot(2,2,3);
h_initial = h5read('..\Larger_case_Dr_Chen\H_initial_hdf5_OK_2015-2016_test\H_initial_OK.h5','/Initial_Head/Data');
y1 = linspace(-448,448,225);
x1 = linspace(-798,798,400);
surf(y1,x1,h_initial,'edgecolor','none');
xlim([-450 450]);
ylim([-800 800]);
% xlim([0 400]);
% ylim([0 400]);
set(gca,'fontsize',14);
%set(gca, 'Position', [0.03 0.03 0.400*2 0.225*2])
xlabel('X','FontSize',18);
ylabel('Y','FontSize',18);
view(2);
box on;
colorbar;

subplot(2,2,4);
h_initial = h5read('..\Larger_case_Dr_Chen\H_initial_hdf5_OK_2015-2016_Wrong_test\H_initial_OK.h5','/Initial_Head/Data');
y1 = linspace(-448,448,225);
x1 = linspace(-798,798,400);
surf(y1,x1,h_initial,'edgecolor','none');
xlim([-450 450]);
ylim([-800 800]);
% xlim([0 400]);
% ylim([0 400]);
set(gca,'fontsize',14);
%set(gca, 'Position', [0.03 0.03 0.400*2 0.225*2])
xlabel('X','FontSize',18);
ylabel('Y','FontSize',18);
view(2);
box on;
colorbar;
