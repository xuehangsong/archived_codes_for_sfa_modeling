for i = 1:100
    perm(i,:,:,:) = reshape(h5read('C:\Users\daih524\Desktop\2015_Spring\Data_for_Test_Case\Test_case_Input_Include_HDF5_Files\MeanFields_newEBF_prior_120x120x30_par1to600.h5',sprintf('/Permeability%d',i)),[120 120 30]);
    %    perm_norm(i,:,:,:) = perm(i,:,:,:)./max(max(max(perm(i,:,:,:))));
end
perm1(:,:,:) = perm(1,:,:,:);
for i = 1:30
    perm1(:,:,i) = perm1(:,:,i)';
end
for i = 1:120
    for j = 1:120
        for k = 1:30
            std_perm(i,j,k) = std(perm(:,j,i,k));
        end
    end
end
for i = 1:30
    std_perm(:,:,i) = std_perm(:,:,i);
end
x = linspace(0.5,119.5,120);
y = linspace(0.5,119.5,120);
z = linspace(95.5,109.5,30);
[x,y,z] = meshgrid(x,y,z);
xslice = [];  
yslice = []; 
zslice = [102,103,104]; 
%slice(x,y,z,perm1,xslice,yslice,zslice)
slice(x,y,z,std_perm,xslice,yslice,zslice)
colorbar;
xlim([0,120]);
ylim([0,120]);
caxis([0 1e-8]);
xlabel('x (m)','fontsize',24)
ylabel('y (m)','fontsize',24)
zlabel('z (m)','fontsize',24)
