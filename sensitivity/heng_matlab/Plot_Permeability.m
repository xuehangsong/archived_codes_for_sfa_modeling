for i = 1:10
  %  perm1(i,:,:,:) = reshape(h5read('C:\Users\daih524\Desktop\2015_Spring\For_Guzel\Perm_2_2.h5',sprintf('/Permeability%d',i)),[60 60 30]);
  %  perm2(i,:,:,:) = reshape(h5read('C:\Users\daih524\Desktop\2015_Spring\For_Guzel\Perm_4_4.h5',sprintf('/Permeability%d',i)),[30 30 30]);
    perm_orig(i,:,:,:) = reshape(h5read('C:\Users\daih524\Desktop\2015_Spring\Data_for_Test_Case\Test_case_Input_Include_HDF5_Files\MeanFields_newEBF_prior_120x120x30_par1to600.h5',sprintf('/Permeability%d',i)),[120 120 30]);
%    perm_norm(i,:,:,:) = perm(i,:,:,:)./max(max(max(perm(i,:,:,:))));
end
%perm100(:,:,:) = perm1(100,:,:,:);
%perm100_2(:,:,:) = perm2(100,:,:,:);
perm4_orig(:,:,:) = perm_orig(4,:,:,:);
perm1_orig(:,:,:) = perm_orig(1,:,:,:);
perm2_orig(:,:,:) = perm_orig(2,:,:,:);
perm3_orig(:,:,:) = perm_orig(3,:,:,:);
for i = 1:30
  %  perm_t1(:,:,i) = perm100(:,:,i)';
  %  perm_t2(:,:,i) = perm100_2(:,:,i)';
    perm1_origt(:,:,i) = perm1_orig(:,:,i)';
    perm2_origt(:,:,i) = perm2_orig(:,:,i)';
    perm3_origt(:,:,i) = perm3_orig(:,:,i)';
    perm4_origt(:,:,i) = perm4_orig(:,:,i)';
end
x = linspace(1,119,60);
y = linspace(1,119,60);
x2 = linspace(2,118,30);
y2 = linspace(2,118,30);
x1 = linspace(0.5,119.5,120);
y1 = linspace(0.5,119.5,120);
z = linspace(95.5,109.5,30);
z1 = linspace(95.5,109.5,30);
z2 = linspace(95.5,109.5,30);
[x,y,z] = meshgrid(x,y,z);
[x1,y1,z1] = meshgrid(x1,y1,z1);
[x2,y2,z2] = meshgrid(x2,y2,z2);
xslice = [];  
yslice = []; 
zslice = [102,103,104]; 


subplot(2,2,1);
slice(x1,y1,z1,perm1_origt,xslice,yslice,zslice)
colorbar;
xlim([0,120]);
caxis([1e-9 5e-8]);
ylim([0,120]);
colormap jet;
set(gca,'fontsize',16)
xlabel('X (m)','fontsize',20);
ylabel('Y (m)','fontsize',20);
zlabel('Z (m)','fontsize',20);
title('Realization ID 1');

subplot(2,2,2);
slice(x1,y1,z1,perm2_origt,xslice,yslice,zslice)
colorbar;
xlim([0,120]);
caxis([1e-9 5e-8]);
ylim([0,120]);
set(gca,'fontsize',16)
colormap jet;
xlabel('X (m)','fontsize',20);
ylabel('Y (m)','fontsize',20);
zlabel('Z (m)','fontsize',20);
title('Realization ID 2');

subplot(2,2,3);
slice(x1,y1,z1,perm3_origt,xslice,yslice,zslice)
colorbar;
xlim([0,120]);
caxis([1e-9 5e-8]);
ylim([0,120]);
set(gca,'fontsize',16)
colormap jet;
xlabel('X (m)','fontsize',20);
ylabel('Y (m)','fontsize',20);
zlabel('Z (m)','fontsize',20);
title('Realization ID 3');

subplot(2,2,4);
slice(x1,y1,z1,perm4_origt,xslice,yslice,zslice)
colorbar;
xlim([0,120]);
caxis([1e-9 5e-8]);
ylim([0,120]);
colormap jet;
set(gca,'fontsize',16)
xlabel('X (m)','fontsize',20);
ylabel('Y (m)','fontsize',20);
zlabel('Z (m)','fontsize',20);
title('Realization ID 4');