krige_data = load('..\Data_for_Test_Case\BC_Data_From_Chen\4heng\CS_OK\Contact_surfaceexponential_drift0.txt');
krige_data = reshape(krige_data,120,120);
data2 = h5read('C:\Users\daih524\Desktop\2015_Spring\Data_for_Test_Case\Test_case_Input_Include_HDF5_Files\plot120x120x15_ngrid120x120x30_material.h5','/Materials/Material Ids');
datanew = reshape(data2,[120 120 30]);
for i = 1:120
    for j = 1:120
         a = find(datanew(j,i,:) == 4,1,'last');
         depth(j,i) = 95 + a*0.5;
    end
end
nsim = 100;
for i = 1:nsim
    CS_cs(1:14400,i) = load(sprintf('C:\\Users\\daih524\\Desktop\\2015_Spring\\Data_for_Test_Case\\BC_Data_From_Chen\\4heng\\CS_CS\\CS%d.txt',i));
    CS(1:120,1:120,i) = reshape(CS_cs(:,i),[120 120]);
end
subplot(2,5,1);
surface(1:120,1:120,depth','edgecolor','none');
set(gca,'fontsize',14)
caxis([96.5 102.5]);
colormap jet;
view(2);
axis square;
box on;
axis([0 120 0 120]);
xlabel('X (m)','fontsize',20);
ylabel('Y (m)','fontsize',20);
title('Expert interpretation');

subplot(2,5,2);
surface(1:120,1:120,krige_data','edgecolor','none');
set(gca,'fontsize',14)
caxis([96.5 102.5]);
view(2);
axis square;
box on;
axis([0 120 0 120]);
xlabel('X (m)','fontsize',20);
ylabel('Y (m)','fontsize',20);
title('Kriging');

subplot(2,5,3);
surface(1:120,1:120,CS(:,:,7)','edgecolor','none');
set(gca,'fontsize',14)
caxis([96.5 102.5]);
view(2);
axis square;
box on;
axis([0 120 0 120]);
xlabel('X (m)','fontsize',20);
ylabel('Y (m)','fontsize',20);
title('Realization ID 7');

subplot(2,5,4);
surface(1:120,1:120,CS(:,:,20)','edgecolor','none');
set(gca,'fontsize',14)
view(2);
axis square;
box on;
axis([0 120 0 120]);
xlabel('X (m)','fontsize',20);
ylabel('Y (m)','fontsize',20);
title('Realization ID 20');
caxis([96.5 102.5]);
subplot(2,5,5);
surface(1:120,1:120,CS(:,:,60)','edgecolor','none');
set(gca,'fontsize',14)
view(2);
axis square;
box on;
axis([0 120 0 120]);
xlabel('X (m)','fontsize',20);
ylabel('Y (m)','fontsize',20);
title('Realization ID 60');
caxis([96.5 102.5]);
subplot(2,5,6);
surface(1:120,1:120,CS(:,:,67)','edgecolor','none');
set(gca,'fontsize',14)
view(2);
axis square;
box on;
axis([0 120 0 120]);
xlabel('X (m)','fontsize',20);
ylabel('Y (m)','fontsize',20);
title('Realization ID 67');
caxis([96.5 102.5]);
subplot(2,5,7);
surface(1:120,1:120,CS(:,:,76)','edgecolor','none');
set(gca,'fontsize',14)
view(2);
axis square;
box on;
axis([0 120 0 120]);
xlabel('X (m)','fontsize',20);
ylabel('Y (m)','fontsize',20);
title('Realization ID 76');
caxis([96.5 102.5]);
subplot(2,5,8);
surface(1:120,1:120,CS(:,:,90)','edgecolor','none');
set(gca,'fontsize',14)
view(2);
axis square;
box on;
axis([0 120 0 120]);
xlabel('X (m)','fontsize',20);
ylabel('Y (m)','fontsize',20);
title('Realization ID 90');
caxis([96.5 102.5]);
subplot(2,5,9);
surface(1:120,1:120,CS(:,:,94)','edgecolor','none');
set(gca,'fontsize',14)
view(2);
axis square;
box on;
axis([0 120 0 120]);
xlabel('X (m)','fontsize',20);
ylabel('Y (m)','fontsize',20);
title('Realization ID 94');
caxis([96.5 102.5]);
subplot(2,5,10);
surface(1:120,1:120,CS(:,:,99)','edgecolor','none');
set(gca,'fontsize',14)
view(2);
axis square;
box on;
axis([0 120 0 120]);
xlabel('X (m)','fontsize',20);
ylabel('Y (m)','fontsize',20);
title('Realization ID 99');
caxis([96.5 102.5]);