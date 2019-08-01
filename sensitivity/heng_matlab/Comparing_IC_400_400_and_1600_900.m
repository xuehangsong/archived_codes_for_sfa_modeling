subplot(1,2,1);
h_initial1 = h5read('..\Larger_case_Dr_Chen\H_initial_hdf5_OK_2015-2016\H_initial_OK.h5','/Initial_Head/Data');
y1 = linspace(-448,448,225);
x1 = linspace(-798,798,400);
surf(y1,x1,h_initial1,'edgecolor','none');
% xlim([-450 450]);
% ylim([-800 800]);
xlim([0 400]);
ylim([0 400]);
set(gca,'fontsize',14);
%set(gca, 'Position', [0.03 0.03 0.400*2 0.225*2])
xlabel('X (m)','FontSize',18);
ylabel('Y (m)','FontSize',18);
view(2);
box on;
colorbar;
caxis([105.45 105.63]);

subplot(1,2,2);
h_initial = h5read('C:/Users/daih524/Desktop/2015_Spring/BC_400m_Dr_Chen/H_initial_hdf5_OK_2015_2016/H_initial_OK.h5','/Initial_Head/Data');
x1 = linspace(1,399,200);
y1 = linspace(1,399,200);
surf(x1,y1,h_initial,'edgecolor','none');
xlim([0 400]);
ylim([0 400]);
set(gca,'fontsize',14);
%set(gca, 'Position', [0.03 0.03 0.225*2 0.400*2])
xlabel('X (m)','FontSize',18);
ylabel('Y (m)','FontSize',18);
view(2);
box on;
colorbar;
caxis([105.45 105.63]);