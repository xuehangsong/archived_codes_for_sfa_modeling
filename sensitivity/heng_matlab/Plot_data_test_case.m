grid = load('..\Data_for_Test_Case\BC_Data_From_Chen\4heng\CS_OK\Domain_Coord.txt');
test_data = h5read('C:\Users\daih524\Desktop\2015_Spring\Sensitivity_Analysis\Test_Case\plot120x120x15_ngrid120x120x30_material.h5','/Materials/Material Ids');
well_data = load('C:\Users\daih524\Desktop\2015_Spring\Data_for_Test_Case\BC_Data_From_Chen\4heng\CS_OK\Revised_Data.txt');
datanew = reshape(test_data,[120 120 30]);
depth_test(1:120,1:120) = 0;
for i = 1:120
    for j = 1:120
        a = find(datanew(j,i,:) == 4,1,'last');
        depth_test(j,i) = 95 + a*0.5;
    end
end
[m,n] = size(depth_test);
depth_test_new(1:m*n,1:3) = 0;
depth_test_new(:,1:2) = grid(:,1:2);
for i = 1:m
    for j = 1:n
        depth_test_new((i-1)*n+j,3) = depth_test(j,i);
    end
end
subplot(1,2,1);
hold on;
for i = 1:max(size(well_data))
    if (well_data(i,1)<=120)&&(well_data(i,2)<=120)&&(well_data(i,1)>=0)&&(well_data(i,2)>=0)
        scatter3(well_data(i,1),well_data(i,2),well_data(i,3),150,'*','b');
        for j = 1:m*n
            if (depth_test_new(j,1:2) == well_data(i,1:2))
                scatter3(depth_test_new(j,1),depth_test_new(j,2),depth_test_new(j,3),150,'r');
                legend('Well data','Base case data');
            end
        end
    end
end
xlabel('X');
ylabel('Y');
zlabel('Z');
subplot(1,2,2);
hold on;
for i = 1:max(size(well_data))
    if (well_data(i,1)<=120)&&(well_data(i,2)<=120)&&(well_data(i,1)>=0)&&(well_data(i,2)>=0)
        scatter3(well_data(i,1),well_data(i,2),well_data(i,3),150,'*','b');
        for j = 1:m*n
            if (depth_test_new(j,1:2) == well_data(i,1:2))
                scatter3(depth_test_new(j,1),depth_test_new(j,2),depth_test_new(j,3),150,'r');
                legend('Well data','Base case data');
            end
        end
    end
end
xlabel('X');
ylabel('Y');
zlabel('Z');