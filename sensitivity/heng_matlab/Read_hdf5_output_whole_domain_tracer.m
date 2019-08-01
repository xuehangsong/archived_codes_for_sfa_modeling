openfolder = 'E:/PNNL_Research_Files/New_Uncertainty_WRR_Data';
m = 1;
n = 1;
t = 4;
pho = 996.877;
g = 9.81;
a(1:120,1:120) = 0;
b(1:120,1:120) = 0;
tracer(1:m,1:n,1:100,1:120,1:120) = 0;
for i = 1:m
    openfolder1 = strcat(openfolder,sprintf('/BC_1_MID_%d',i));
    filename = strcat(openfolder1,sprintf('/pflotran1R1.h5'));
    hinfo = hdf5info(filename);
    temp = hdf5read(hinfo.GroupHierarchy.Groups(t).Datasets(6));
    for ii = 1:120
        for jj = 1:120
            a(ii,jj) = find(temp(:,ii,jj) == 1,1,'first');
        end
    end
    for j = 1:n
        openfolder1 = strcat(openfolder,sprintf('/BC_%d_MID_%d',j,i));
        for k = 1:100
            disp(k);
            filename = strcat(openfolder1,sprintf('/pflotran1R%d.h5',k));
            hinfo = hdf5info(filename);
            temp = hdf5read(hinfo.GroupHierarchy.Groups(t).Datasets(5));
            tempx = hdf5read(hinfo.GroupHierarchy.Groups(t).Datasets(1));
            tempy = hdf5read(hinfo.GroupHierarchy.Groups(t).Datasets(2));
            tempt = hdf5read(hinfo.GroupHierarchy.Groups(t).Datasets(7));
            for ii = 1:120
                for jj = 1:120
                    b(ii,jj) = find(temp(:,ii,jj) < 1, 1, 'first') -1;
                    if b(ii,jj) < a(ii,jj)
                        disp('error');
                        tracer(i,j,k,ii,jj) = 0;
                    else
                        sumv = 0;
                        for kk = (a(ii,jj)):(b(ii,jj))
                            v = sqrt(tempx(kk,ii,jj)^2 + tempy(kk,ii,jj)^2);
                            tracer(i,j,k,ii,jj) = tracer(i,j,k,ii,jj) + v*tempt(kk,ii,jj);
                            sumv = sumv + v;
                        end
                        tracer(i,j,k,ii,jj) = tracer(i,j,k,ii,jj)./sumv;
                    end
                end
            end
        end
    end
end
save('tracer_1.mat','tracer');