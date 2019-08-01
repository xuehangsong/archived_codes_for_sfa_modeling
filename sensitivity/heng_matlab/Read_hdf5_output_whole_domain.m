openfolder = 'E:/PNNL_Research_Files/New_Uncertainty_WRR_Data';
m = 10;
n = 10;
t = 1;
pho = 996.877;
g = 9.81;
h(1:m,1:n,1:100,1:t,1:120,1:120) = 0;
for l = 1:t
    for i = 1:m
        for j = 1:n
            openfolder1 = strcat(openfolder,sprintf('/BC_%d_MID_%d',i,j));
            for k = 1:100
                disp(k);
                filename = strcat(openfolder1,sprintf('/pflotran1R%d.h5',k));
                hinfo = hdf5info(filename);
                if l == 1
                    temp = hdf5read(hinfo.GroupHierarchy.Groups(3+l).Datasets(4));
                    h(i,j,k,l,:,:) = temp(10,:,:)./(pho*g) + 99.75 - 101325/(pho*g);
                elseif l<=11
                    temp = hdf5read(hinfo.GroupHierarchy.Groups(3+l).Datasets(4));
                    h(i,j,k,l+8,:,:) = temp(10,:,:)./(pho*g) + 99.75 - 101325/(pho*g);
                else
                    temp = hdf5read(hinfo.GroupHierarchy.Groups(3+l).Datasets(4));
                    h(i,j,k,l-10,:,:) =  temp(10,:,:)./(pho*g) + 99.75 - 101325/(pho*g);
                end      
                %    perm_norm(i,:,:,:) = perm(i,:,:,:)./max(max(max(perm(i,:,:,:))));
            end
        end
    end
end
save('h_15.mat','h');