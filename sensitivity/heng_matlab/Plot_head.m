data1 = h5read('C:\Users\daih524\Desktop\2015_Spring\Data_for_Test_Case\BC_Data_From_Chen\4heng\Material1.h5','/Materials/Material Ids');
data2 = h5read('C:\Users\daih524\Desktop\2015_Spring\Sensitivity_Analysis\Test_Case\plot120x120x15_ngrid120x120x30_material.h5','/Materials/Material Ids');
datanew1 = reshape(data1,[120 120 30]);
file1 = fopen('C:\Users\daih524\Desktop\2015_Spring\Data_for_Test_Case\BC_Data_From_Chen\4heng\Material_data.txt','w');
fprintf(file1,'%d %d %d %d %d %d %d %d %d %d\n',data1);
fclose(file1);
well_data = load('C:\Users\daih524\Desktop\2015_Spring\Data_for_Test_Case\BC_Data_From_Chen\4heng\CS_OK\Revised_Data.txt');
datanew = reshape(data2,[120 120 30]);
for i = 1:120
    for j = 1:120
         a = find(datanew(j,i,:) == 4,1,'last');
         depth(j,i) = 95 + a*0.5;
    end
end
subplot(1,2,1)
surface(1:120,1:120,depth');
caxis([96.5 102.5]);
data3 = load('C:\Users\daih524\Desktop\2015_Spring\Data_for_Test_Case\BC_Data_From_Chen\4heng\CS_OK\Contact_surfaceexponential_drift0.txt');
subplot(1,2,2);
surface(1:120,1:120,data3');
caxis([96.5 102.5]);
