clear x_index y_index xcoord ycoord;
SS_cr11 = load('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Sensitivity_OK/SS_c1_real_5.txt');
SS_cr12 = load('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Sensitivity_OK/SS_c1_real_10.txt');
SS_cr13 = load('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Sensitivity_OK/SS_c1_real_15.txt');
SS_cr14 = load('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Sensitivity_OK/SS_c1_real_20.txt');
SS_cr15 = load('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Sensitivity_OK/SS_c1_real_30.txt');
SS_cr16 = load('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Sensitivity_OK/SS_c1_real_50.txt');
SS_cr17 = load('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Sensitivity_OK/SS_c1_real_100.txt');
SS_cr18 = load('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Sensitivity_OK/SS_c1_real_170.txt');
SS_cr19 = load('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Sensitivity_OK/SS_c1_real_180.txt');
SS_cr110 = load('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Sensitivity_OK/SS_c1_real_190.txt');
SS_cr11t = reshape(SS_cr11,120,120);
SS_cr12t = reshape(SS_cr12,120,120);
SS_cr13t = reshape(SS_cr13,120,120);
SS_cr14t = reshape(SS_cr14,120,120);
SS_cr15t = reshape(SS_cr15,120,120);
SS_cr16t = reshape(SS_cr16,120,120);
SS_cr17t = reshape(SS_cr17,120,120);
SS_cr18t = reshape(SS_cr18,120,120);
SS_cr19t = reshape(SS_cr19,120,120);
SS_cr110t = reshape(SS_cr110,120,120);
SM_cr11 = load('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Sensitivity_OK/SM_c1_real_5.txt');
SM_cr12 = load('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Sensitivity_OK/SM_c1_real_10.txt');
SM_cr13 = load('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Sensitivity_OK/SM_c1_real_15.txt');
SM_cr14 = load('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Sensitivity_OK/SM_c1_real_20.txt');
SM_cr15 = load('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Sensitivity_OK/SM_c1_real_30.txt');
SM_cr16 = load('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Sensitivity_OK/SM_c1_real_50.txt');
SM_cr17 = load('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Sensitivity_OK/SM_c1_real_100.txt');
SM_cr18 = load('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Sensitivity_OK/SM_c1_real_170.txt');
SM_cr19 = load('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Sensitivity_OK/SM_c1_real_180.txt');
SM_cr110 = load('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Sensitivity_OK/SM_c1_real_190.txt');
SM_cr11t = reshape(SM_cr11,120,120);
SM_cr12t = reshape(SM_cr12,120,120);
SM_cr13t = reshape(SM_cr13,120,120);
SM_cr14t = reshape(SM_cr14,120,120);
SM_cr15t = reshape(SM_cr15,120,120);
SM_cr16t = reshape(SM_cr16,120,120);
SM_cr17t = reshape(SM_cr17,120,120);
SM_cr18t = reshape(SM_cr18,120,120);
SM_cr19t = reshape(SM_cr19,120,120);
SM_cr110t = reshape(SM_cr110,120,120);
ST_cr11 = load('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Sensitivity_OK/ST_c1_real_5.txt');
ST_cr12 = load('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Sensitivity_OK/ST_c1_real_10.txt');
ST_cr13 = load('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Sensitivity_OK/ST_c1_real_15.txt');
ST_cr14 = load('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Sensitivity_OK/ST_c1_real_20.txt');
ST_cr15 = load('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Sensitivity_OK/ST_c1_real_30.txt');
ST_cr16 = load('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Sensitivity_OK/ST_c1_real_50.txt');
ST_cr17 = load('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Sensitivity_OK/ST_c1_real_100.txt');
ST_cr18 = load('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Sensitivity_OK/ST_c1_real_170.txt');
ST_cr19 = load('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Sensitivity_OK/ST_c1_real_180.txt');
ST_cr110 = load('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Sensitivity_OK/ST_c1_real_190.txt');
ST_cr11t = reshape(ST_cr11,120,120);
ST_cr12t = reshape(ST_cr12,120,120);
ST_cr13t = reshape(ST_cr13,120,120);
ST_cr14t = reshape(ST_cr14,120,120);
ST_cr15t = reshape(ST_cr15,120,120);
ST_cr16t = reshape(ST_cr16,120,120);
ST_cr17t = reshape(ST_cr17,120,120);
ST_cr18t = reshape(ST_cr18,120,120);
ST_cr19t = reshape(ST_cr19,120,120);
ST_cr110t = reshape(ST_cr110,120,120);
x1 = linspace(0.5, 119.5, 120);
y1 = linspace(0.5, 119.5, 120);
for i = 1:N
    m = 0;
    for j = 1: max(size(well_82_st_c1_real(:,1,1)))
        if (well_82_st_c1_real(j,1,i)) ~= 0
            m = m + 1;
            x_index{i,m} = find(well_82_st_c1_real(j,1,i)+10>=x1 & x1>=well_82_st_c1_real(j,1,i)-10);
            y_index{i,m} = find((well_82_st_c1_real(j,2,i)+10)>=y1 & y1>=well_82_st_c1_real(j,2,i)-10);
            if m > 1
                xcoord{i} = union(x_index{i,m},x_index{i,m-1});
                ycoord{i} = union(y_index{i,m},y_index{i,m-1});
            end
        end
    end
    mt(i) = m;
end
subplot(3,8,1);
hold all;
scatter3(Well_add_120(:,1),Well_add_120(:,2),120*ones(82,1),20,'ko');
scatter3(60.11, 83.76,120,30,'ko','fill');
for i = 1:mt(2)  
    surf(x1(x_index{2,i}),y1(y_index{2,i}),SS_cr11t(x_index{2,i},y_index{2,i})','edgecolor','none');
    view(2);
    axis([0 120 0 120]);
 %   colorbar;
    caxis([0, 1]);
    %caxis([0,1]);
    axis square;
    box on;
end
title('Time = 5 hours','fontsize',14);

%    text(Well_in_120(:,1), Well_in_120(:,2), 120*ones(40,1),labels1, 'VerticalAlignment','bottom', ...
%                             'HorizontalAlignment','right')
%title('Boundary condition sensitivity index','fontsize',12);
%xlabel('X (m)','fontsize',12);
ylabel('Y (m)','fontsize',12);
set(gca,'fontsize',12)

subplot(3,8,9);
hold all;
scatter3(Well_add_120(:,1),Well_add_120(:,2),120*ones(82,1),20,'ko');
scatter3(60.11, 83.76,120,30,'ko','fill');
for i = 1:mt(2)  
    surf(x1(x_index{2,i}),y1(y_index{2,i}),SM_cr11t(x_index{2,i},y_index{2,i})','edgecolor','none');
    view(2);
    axis([0 120 0 120]);
%    colorbar;
    caxis([0.0, 1]);
%    caxis([0,1]);
    axis square;
    box on;
end
%title('Material ID sensitivity index','fontsize',12);
%xlabel('X (m)','fontsize',12);
ylabel('Y (m)','fontsize',12);
set(gca,'fontsize',12)

subplot(3,8,17);
hold all;
scatter3(Well_add_120(:,1),Well_add_120(:,2),120*ones(82,1),20,'ko');
scatter3(60.11, 83.76,120,30,'ko','fill');
for i = 1:mt(2)  
    surf(x1(x_index{2,i}),y1(y_index{2,i}),ST_cr11t(x_index{2,i},y_index{2,i})','edgecolor','none');
    view(2);
    axis([0 120 0 120]);
 %   colorbar;
    caxis([0.0, 1]);
%    caxis([0,1]);
    axis square;
    box on;
end
%title('Permeability sensitivity index','fontsize',12);
xlabel('X (m)','fontsize',12);
ylabel('Y (m)','fontsize',12);
set(gca,'fontsize',12)

subplot(3,8,2);
hold all;
scatter3(Well_add_120(:,1),Well_add_120(:,2),120*ones(82,1),20,'ko');
scatter3(60.11, 83.76,120,30,'ko','fill');
for i = 1:mt(3)  
    surf(x1(x_index{3,i}),y1(y_index{3,i}),SS_cr12t(x_index{3,i},y_index{3,i})','edgecolor','none');
    view(2);
    axis([0 120 0 120]);
%    colorbar;
    caxis([0.0, 1]);
%    caxis([0,1]);
    axis square;
    box on;
end
title('10 hours','fontsize',14);
%title('Boundary condition sensitivity index','fontsize',12);
%xlabel('X (m)','fontsize',12);
%ylabel('Y (m)','fontsize',12);
set(gca,'fontsize',12)

subplot(3,8,10);
hold all;
scatter3(Well_add_120(:,1),Well_add_120(:,2),120*ones(82,1),20,'ko');
scatter3(60.11, 83.76,120,30,'ko','fill');
for i = 1:mt(3)  
    surf(x1(x_index{3,i}),y1(y_index{3,i}),SM_cr12t(x_index{3,i},y_index{3,i})','edgecolor','none');
    view(2);
    axis([0 120 0 120]);
%    colorbar;
    caxis([0.0, 1]);
%    caxis([0,1]);
    axis square;
    box on;
end
%title('Material ID sensitivity index','fontsize',12);
%xlabel('X (m)','fontsize',12);
%ylabel('Y (m)','fontsize',12);
set(gca,'fontsize',12)

subplot(3,8,18);
hold all;
scatter3(Well_add_120(:,1),Well_add_120(:,2),120*ones(82,1),20,'ko');
scatter3(60.11, 83.76,120,30,'ko','fill');
for i = 1:mt(3)  
    surf(x1(x_index{3,i}),y1(y_index{3,i}),ST_cr12t(x_index{3,i},y_index{3,i})','edgecolor','none');
    view(2);
    axis([0 120 0 120]);
%    colorbar;
    caxis([0.0, 1]);
%    caxis([0,1]);
    axis square;
    box on;
end
%title('Permeability sensitivity index','fontsize',12);
xlabel('X (m)','fontsize',12);
%ylabel('Y (m)','fontsize',12);
set(gca,'fontsize',12)
    
subplot(3,8,3);
hold all;
scatter3(Well_add_120(:,1),Well_add_120(:,2),120*ones(82,1),20,'ko');
scatter3(60.11, 83.76,120,30,'ko','fill');
for i = 1:mt(4)  
    surf(x1(x_index{4,i}),y1(y_index{4,i}),SS_cr13t(x_index{4,i},y_index{4,i})','edgecolor','none');
    view(2);
    axis([0 120 0 120]);
%    colorbar;
    caxis([0.0, 1]);
%    caxis([0,1]);
    axis square;
    box on;
end
title('15 hours','fontsize',14);

%title('Boundary condition sensitivity index','fontsize',12);
%xlabel('X (m)','fontsize',12);
%ylabel('Y (m)','fontsize',12);
set(gca,'fontsize',12)

subplot(3,8,11);
hold all;
scatter3(Well_add_120(:,1),Well_add_120(:,2),120*ones(82,1),20,'ko');
scatter3(60.11, 83.76,120,30,'ko','fill');
for i = 1:mt(4)  
    surf(x1(x_index{4,i}),y1(y_index{4,i}),SM_cr13t(x_index{4,i},y_index{4,i})','edgecolor','none');
    view(2);
    axis([0 120 0 120]);
%    colorbar;
    caxis([0.0, 1]);
%    caxis([0,1]);
    axis square;
    box on;
end
%title('Material ID sensitivity index','fontsize',12);
%xlabel('X (m)','fontsize',12);
%ylabel('Y (m)','fontsize',12);
set(gca,'fontsize',12)

subplot(3,8,19);
hold all;
scatter3(Well_add_120(:,1),Well_add_120(:,2),120*ones(82,1),20,'ko');
scatter3(60.11, 83.76,120,30,'ko','fill');
for i = 1:mt(4)  
    surf(x1(x_index{4,i}),y1(y_index{4,i}),ST_cr13t(x_index{4,i},y_index{4,i})','edgecolor','none');
    view(2);
    axis([0 120 0 120]);
 %   colorbar;
    caxis([0.0, 1]);
%    caxis([0,1]);
    axis square;
    box on;
end
%title('Permeability sensitivity index','fontsize',12);
xlabel('X (m)','fontsize',12);
%ylabel('Y (m)','fontsize',12);
set(gca,'fontsize',12)

subplot(3,8,4);
hold all;
scatter3(Well_add_120(:,1),Well_add_120(:,2),120*ones(82,1),20,'ko');
scatter3(60.11, 83.76,120,30,'ko','fill');
for i = 1:mt(5)  
    surf(x1(x_index{5,i}),y1(y_index{5,i}),SS_cr14t(x_index{5,i},y_index{5,i})','edgecolor','none');
    view(2);
    axis([0 120 0 120]);
 %   colorbar;
    caxis([0.0, 1]);
 %   caxis([0,1]);
    axis square;
    box on;
end
title('20 hours','fontsize',14);
%title('Boundary condition sensitivity index','fontsize',12);
%xlabel('X (m)','fontsize',12);
%ylabel('Y (m)','fontsize',12);
set(gca,'fontsize',12)

subplot(3,8,12);
hold all;
scatter3(Well_add_120(:,1),Well_add_120(:,2),120*ones(82,1),20,'ko');
scatter3(60.11, 83.76,120,30,'ko','fill');
for i = 1:mt(5)  
    surf(x1(x_index{5,i}),y1(y_index{5,i}),SM_cr14t(x_index{5,i},y_index{5,i})','edgecolor','none');
    view(2);
    axis([0 120 0 120]);
%    colorbar;
    caxis([0.0, 1]);
%    caxis([0,1]);
    axis square;
    box on;
end
%title('Material ID sensitivity index','fontsize',12);
%xlabel('X (m)','fontsize',12);
%ylabel('Y (m)','fontsize',12);
set(gca,'fontsize',12)

subplot(3,8,20);
hold all;
scatter3(Well_add_120(:,1),Well_add_120(:,2),120*ones(82,1),20,'ko');
scatter3(60.11, 83.76,120,30,'ko','fill');
for i = 1:mt(5)  
    surf(x1(x_index{5,i}),y1(y_index{5,i}),ST_cr14t(x_index{5,i},y_index{5,i})','edgecolor','none');
    view(2);
    axis([0 120 0 120]);
%    colorbar;
    caxis([0.0, 1]);
%    caxis([0,1]);
    axis square;
    box on;
end
%title('Permeability sensitivity index','fontsize',12);
xlabel('X (m)','fontsize',12);
%ylabel('Y (m)','fontsize',12);
set(gca,'fontsize',12)

subplot(3,8,5);
hold all;
scatter3(Well_add_120(:,1),Well_add_120(:,2),120*ones(82,1),20,'ko');
scatter3(60.11, 83.76,120,30,'ko','fill');
for i = 1:mt(7)  
    surf(x1(x_index{7,i}),y1(y_index{7,i}),SS_cr15t(x_index{7,i},y_index{7,i})','edgecolor','none');
    view(2);
    axis([0 120 0 120]);
    caxis([0.0, 1]);
%    caxis([0,1]);
    axis square;
    box on;
end
title('30 hours','fontsize',14);

%title('Boundary condition sensitivity index','fontsize',12);
%xlabel('X (m)','fontsize',12);
%ylabel('Y (m)','fontsize',12);
set(gca,'fontsize',12)

subplot(3,8,13);
hold all;
scatter3(Well_add_120(:,1),Well_add_120(:,2),120*ones(82,1),20,'ko');
scatter3(60.11, 83.76,120,30,'ko','fill');
for i = 1:mt(7)  
    surf(x1(x_index{7,i}),y1(y_index{7,i}),SM_cr15t(x_index{7,i},y_index{7,i})','edgecolor','none');
    view(2);
    axis([0 120 0 120]);
    caxis([0.0, 1]);
 %   caxis([0,1]);
    axis square;
    box on;
end
%title('Material ID sensitivity index','fontsize',12);
%xlabel('X (m)','fontsize',12);
%ylabel('Y (m)','fontsize',12);
set(gca,'fontsize',12)

subplot(3,8,21);
hold all;
scatter3(Well_add_120(:,1),Well_add_120(:,2),120*ones(82,1),20,'ko');
scatter3(60.11, 83.76,120,30,'ko','fill');
for i = 1:mt(7)  
    surf(x1(x_index{7,i}),y1(y_index{7,i}),ST_cr15t(x_index{7,i},y_index{7,i})','edgecolor','none');
    view(2);
    axis([0 120 0 120]);
    caxis([0.0, 1]);
 %   caxis([0,1]);
    axis square;
    box on;
end
%title('Permeability sensitivity index','fontsize',12);
xlabel('X (m)','fontsize',12);
%ylabel('Y (m)','fontsize',12);
set(gca,'fontsize',12)

subplot(3,8,6);
hold all;
scatter3(Well_add_120(:,1),Well_add_120(:,2),120*ones(82,1),20,'ko');
scatter3(60.11, 83.76,120,30,'ko','fill');
for i = 1:mt(11)  
    surf(x1(x_index{11,i}),y1(y_index{11,i}),SS_cr16t(x_index{11,i},y_index{11,i})','edgecolor','none');
    view(2);
    axis([0 120 0 120]);
    caxis([0.0, 1]);
%    caxis([0,1]);
    axis square;
    box on;
end
title('50 hours','fontsize',14);

%title('Boundary condition sensitivity index','fontsize',12);
%xlabel('X (m)','fontsize',12);
%ylabel('Y (m)','fontsize',12);
set(gca,'fontsize',12)

subplot(3,8,14);
hold all;
scatter3(Well_add_120(:,1),Well_add_120(:,2),120*ones(82,1),20,'ko');
scatter3(60.11, 83.76,120,30,'ko','fill');
for i = 1:mt(11)  
    surf(x1(x_index{11,i}),y1(y_index{11,i}),SM_cr16t(x_index{11,i},y_index{11,i})','edgecolor','none');
    view(2);
    axis([0 120 0 120]);
    caxis([0.0, 1]);
 %   caxis([0,1]);
    axis square;
    box on;
end
%title('Material ID sensitivity index','fontsize',12);
%xlabel('X (m)','fontsize',12);
%ylabel('Y (m)','fontsize',12);
set(gca,'fontsize',12)

subplot(3,8,22);
hold all;
scatter3(Well_add_120(:,1),Well_add_120(:,2),120*ones(82,1),20,'ko');
scatter3(60.11, 83.76,120,30,'ko','fill');
for i = 1:mt(11)  
    surf(x1(x_index{11,i}),y1(y_index{11,i}),ST_cr16t(x_index{11,i},y_index{11,i})','edgecolor','none');
    view(2);
    axis([0 120 0 120]);
    caxis([0.0, 1]);
 %   caxis([0,1]);
    axis square;
    box on;
end
%title('Permeability sensitivity index','fontsize',12);
xlabel('X (m)','fontsize',12);
%ylabel('Y (m)','fontsize',12);
set(gca,'fontsize',12)

subplot(3,8,7);
hold all;
scatter3(Well_add_120(:,1),Well_add_120(:,2),120*ones(82,1),20,'ko');
scatter3(60.11, 83.76,120,30,'ko','fill');
for i = 1:mt(21)  
    surf(x1(x_index{21,i}),y1(y_index{21,i}),SS_cr17t(x_index{21,i},y_index{21,i})','edgecolor','none');
    view(2);
    axis([0 120 0 120]);
    caxis([0.0, 1]);
%    caxis([0,1]);
    axis square;
    box on;
end
title('100 hours','fontsize',14);

%title('Boundary condition sensitivity index','fontsize',12);
%xlabel('X (m)','fontsize',12);
%ylabel('Y (m)','fontsize',12);
set(gca,'fontsize',12)

subplot(3,8,15);
hold all;
scatter3(Well_add_120(:,1),Well_add_120(:,2),120*ones(82,1),20,'ko');
scatter3(60.11, 83.76,120,30,'ko','fill');
for i = 1:mt(21)  
    surf(x1(x_index{21,i}),y1(y_index{21,i}),SM_cr17t(x_index{21,i},y_index{21,i})','edgecolor','none');
    view(2);
    axis([0 120 0 120]);
    caxis([0.0, 1]);
 %   caxis([0,1]);
    axis square;
    box on;
end
%title('Material ID sensitivity index','fontsize',12);
%xlabel('X (m)','fontsize',12);
%ylabel('Y (m)','fontsize',12);
set(gca,'fontsize',12)

subplot(3,8,23);
hold all;
scatter3(Well_add_120(:,1),Well_add_120(:,2),120*ones(82,1),20,'ko');
scatter3(60.11, 83.76,120,30,'ko','fill');
for i = 1:mt(21)  
    surf(x1(x_index{21,i}),y1(y_index{21,i}),ST_cr17t(x_index{21,i},y_index{21,i})','edgecolor','none');
    view(2);
    axis([0 120 0 120]);
    caxis([0.0, 1]);
 %   caxis([0,1]);
    axis square;
    box on;
end
%title('Permeability sensitivity index','fontsize',12);
xlabel('X (m)','fontsize',12);
%ylabel('Y (m)','fontsize',12);
set(gca,'fontsize',12)

subplot(3,8,8);
hold all;
scatter3(Well_add_120(:,1),Well_add_120(:,2),120*ones(82,1),20,'ko');
scatter3(60.11, 83.76,120,30,'ko','fill');
legend('Observation wells','Injection well');
for i = 1:mt(35)  
    surf(x1(x_index{35,i}),y1(y_index{35,i}),SS_cr18t(x_index{35,i},y_index{35,i})','edgecolor','none');
    view(2);
    axis([0 120 0 120]);
    colorbar;
    caxis([0.0, 1]);
%    caxis([0,1]);
    axis square;
    box on;
end
title('170 hours','fontsize',14);

%title('Boundary condition sensitivity index','fontsize',12);
%xlabel('X (m)','fontsize',12);
%ylabel('Y (m)','fontsize',12);
set(gca,'fontsize',12)

subplot(3,8,16);
hold all;
scatter3(Well_add_120(:,1),Well_add_120(:,2),120*ones(82,1),20,'ko');
scatter3(60.11, 83.76,120,30,'ko','fill');
for i = 1:mt(35)  
    surf(x1(x_index{35,i}),y1(y_index{35,i}),SM_cr18t(x_index{35,i},y_index{35,i})','edgecolor','none');
    view(2);
    axis([0 120 0 120]);
    colorbar;
    caxis([0.0, 1]);
 %   caxis([0,1]);
    axis square;
    box on;
end
%title('Material ID sensitivity index','fontsize',12);
%xlabel('X (m)','fontsize',12);
%ylabel('Y (m)','fontsize',12);
set(gca,'fontsize',12)

subplot(3,8,24);
hold all;
scatter3(Well_add_120(:,1),Well_add_120(:,2),120*ones(82,1),20,'ko');
scatter3(60.11, 83.76,120,30,'ko','fill');
for i = 1:mt(35)  
    surf(x1(x_index{35,i}),y1(y_index{35,i}),ST_cr18t(x_index{35,i},y_index{35,i})','edgecolor','none');
    view(2);
    axis([0 120 0 120]);
    colorbar;
    caxis([0.0, 1]);
 %   caxis([0,1]);
    axis square;
    box on;
end
%title('Permeability sensitivity index','fontsize',12);
xlabel('X (m)','fontsize',12);
%ylabel('Y (m)','fontsize',12);
set(gca,'fontsize',12)