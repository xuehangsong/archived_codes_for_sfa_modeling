grid = load('..\Data_for_Test_Case\BC_Data_From_Chen\4heng\CS_OK\Domain_Coord.txt');
well_data = load('..\Data_for_Test_Case\BC_Data_From_Chen\4heng\CS_OK\Revised_Data.txt');
krige_data = load('..\Data_for_Test_Case\BC_Data_From_Chen\4heng\CS_OK\Contact_surface_exponential_drift0.txt');
krige_data = reshape(krige_data,120,120);
[m,n] = size(krige_data);
data2 = h5read('C:\Users\daih524\Desktop\2015_Spring\Sensitivity_Analysis\Test_Case\plot120x120x15_ngrid120x120x30_material.h5','/Materials/Material Ids');
datanew = reshape(data2,[120 120 30]);
for i = 1:120
    for j = 1:120
         a = find(datanew(j,i,:) == 4,1,'last');
         depth(j,i) = 95 + a*0.5;
    end
end
krige(1:m*n,1:3) = 0;
krige(:,1:2) = grid(:,1:2);
for i = 1:m
    for j = 1:n
        krige((i-1)*n+j,3) = krige_data(j,i);
    end
end
surface(1:120,1:120,depth');
caxis([96.5 102.5]);
%subplot(1,2,1);
%surface(1:120,1:120,depth');
%caxis([96.5 102.5]);
% scatter3(well_data(:,1),well_data(:,2),well_data(:,3));
% hold all;
% scatter3(krige(:,1),krige(:,2),krige(:,3));
%subplot(1,2,1);
hold on;
% for i = 1:max(size(well_data))
%     scatter3(well_data(i,1),well_data(i,2),well_data(i,3),150,'*','b');
%     for j = 1:m*n
%         if (krige(j,1:2) == well_data(i,1:2))
%             scatter3(krige(j,1),krige(j,2),krige(j,3),150,'r');
%         end
%     end
% end
xlabel('X');
ylabel('Y');
%subplot(1,2,2);
%surface(1:120,1:120,krige_data');
%caxis([96.5 102.5]);
%xlabel('X');
%ylabel('Y');