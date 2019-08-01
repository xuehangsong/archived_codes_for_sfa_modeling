% Create the indicator of the Hanford-Ringold interface with updated H/R contact
% including river bathemetry and DEM
close all
clear all
addpath('/Users/chen737/Work/FieldGeneration/input_files_anchor');
addpath('/Users/chen737/Work/FieldGeneration/interface');

%
%grid information
grid.n_pts = [200 200 50];
grid.d_pts = [2  2  0.5];

x0 = 594186;
y0 = 115943;
z0 = 90;
a = 15/180 *pi; % rotation

%---------------
% Grid location
x0_fld = x0;
y0_fld = y0;
z0_fld = z0;

corners = [594186	115943;
			594572.4	116046.5;
			594468.9	116432.9;
			594082.5	116329.4];


//%load the ringold/hanford contact data 
[x y z1 z2 z3 z4 z5 z6 z7 z8 z9 z10] = textread('300A_EV_surfaces_012612.dat','%f %f %f %f %f %f %f %f %f %f %f %f ','headerlines',21);

%The grid size of the data
dx = 2;
dy= 2;


% Max coordinates to read
xmax = x0_fld + grid.n_pts(1)*grid.d_pts(1);
xmin = x0_fld - 120;
ymax = y0_fld + grid.n_pts(1)*grid.d_pts(1)+ 120;
ymin = y0_fld - 10;

% Create interface data

idx = find((x > xmin) & (x < xmax) & (y > ymin) & (y < ymax));
x = x(idx);
y = y(idx);
h_RH = z10(idx);

figure
plot(x,y,'o');
hold on
for i = 1:3
	  plot(corners(i:i+1,1), corners(i:i+1,2),'k-','LineWidth',2.5);
hold on
end
plot([corners(4,1) corners(1,1)],[corners(4,2) corners(1,2)],'k-','LineWidth',2.5);
axis equal;
%grid on;

%load the DEM data
%ncols         2251
%nrows         2501
%xllcorner     590999
%yllcorner     113499
%cellsize      2
%NODATA_value  -9999
DEM_data = load('newbath_10mDEM_grid.ascii');
DEM_X_range = 590999:2:595499;
DEM_Y_range = 118499:-2:113499;
[DEM_X_Grid,DEM_Y_Grid] = meshgrid(DEM_X_range,DEM_Y_range);
x_bath = reshape(DEM_X_Grid,1,[]);
y_bath = reshape(DEM_Y_Grid,1,[]);
h_bath = reshape(DEM_data,1,[]);

%obtain the data within the relevant domain
idx_bath = find((x_bath > xmin) & (x_bath < xmax) & (y_bath > ymin) & (y_bath < ymax));
x_bath = x_bath(idx_bath);
y_bath = y_bath(idx_bath);
h_bath = h_bath(idx_bath);

%load in new dem data
DEM_USGS = load('hammond2010_dem.txt');
% ncols         428
% nrows         526
% xllcorner     593610.7184367
% yllcorner     115048.40168492
% cellsize      2.89143237976
% NODATA_value  -9999
DEM_USGS(find(DEM_USGS == -9999)) = NaN;
DEM_X_USGS = 593610.72:2.8914:594845.36;
DEM_Y_USGS = 116566.39:-2.8914:115048.3;

[new_X_USGS,new_Y_USGS] = meshgrid(DEM_X_USGS,DEM_Y_USGS);
x_bath_USGS = reshape(new_X_USGS,1,[]);
y_bath_USGS = reshape(new_Y_USGS,1,[]);
h_bath_USGS = reshape(DEM_USGS,1,[]);

idx_bath_USGS = find((x_bath_USGS > xmin) & (x_bath_USGS < xmax) & (y_bath_USGS > ymin) & (y_bath_USGS < ymax));
x_bath_USGS = x_bath_USGS(idx_bath_USGS);
y_bath_USGS = y_bath_USGS(idx_bath_USGS);
h_bath_USGS = h_bath_USGS(idx_bath_USGS);

figure()
contourf(new_X_USGS,new_Y_USGS,DEM_USGS)
axis equal
hold on
for i = 1:3
	  plot(corners(i:i+1,1), corners(i:i+1,2),'k-','LineWidth',2.5);
hold on
end
plot([corners(4,1) corners(1,1)],[corners(4,2) corners(1,2)],'k-','LineWidth',2.5);
title('USGS DEM','FontSize',18) 
xlim([xmin xmax])
ylim([ymin ymax])
caxis([110 120])
%caxis([100 120])
colorbar
% new lidar dem

DEM_new = load('300a_bth_ascii.txt');
% ncols         1188
% nrows         1479
% xllcorner     593635.50000001
% yllcorner     115070
% cellsize      1
% NODATA_value  -9999
DEM_new(find(DEM_new == -9999)) = NaN;
DEM_X_new = 593635.5:1:594822.5;
DEM_Y_new = 116548:-1:115070;

[new_X_Grid,new_Y_Grid] = meshgrid(DEM_X_new,DEM_Y_new);
x_bath_new = reshape(new_X_Grid,1,[]);
y_bath_new = reshape(new_Y_Grid,1,[]);
h_bath_new = reshape(DEM_new,1,[]);

idx_bath_new = find((x_bath_new > xmin) & (x_bath_new < xmax) & (y_bath_new > ymin) & (y_bath_new < ymax));
x_bath_new = x_bath_new(idx_bath_new);
y_bath_new = y_bath_new(idx_bath_new);
h_bath_new = h_bath_new(idx_bath_new);

figure()
contourf(new_X_Grid,new_Y_Grid,DEM_new)
axis equal
hold on
for i = 1:3
	  plot(corners(i:i+1,1), corners(i:i+1,2),'k-','LineWidth',2.5);
hold on
end
plot([corners(4,1) corners(1,1)],[corners(4,2) corners(1,2)],'k-','LineWidth',2.5);
title('New Lidar DEM','FontSize',18)
xlim([xmin xmax])
ylim([ymin ymax])
caxis([110 120])
colorbar

% grid locations for interpolation
xv = [grid.d_pts(1)/2:grid.d_pts(1):grid.n_pts(1)*grid.d_pts(1)];
yv = [grid.d_pts(2)/2:grid.d_pts(2):grid.n_pts(2)*grid.d_pts(2)];

[XI,YI] = meshgrid(xv,yv);

%rotate the coordinates to the global coordinate system
%xglobal0=XI * cos(-a) + YI * sin(-a) + x0_fld;
%yglobal0=YI * cos(-a) - XI * sin(-a) + y0_fld;

%calculate the interpolated values using Matlab's bilinear command
%ZI0 = interp2(x,y,h,xglobal0,yglobal0,'linear');
%manual bilinear calculation
Z1 = NaN * ones(size(XI,1),size(XI,2)); % for RH contact
Z2 = NaN * ones(size(XI,1),size(XI,2)); % for bathemetry
Z3 = NaN * ones(size(XI,1),size(XI,2)); % for new lidar bathemetry
Z4 = NaN * ones(size(XI,1),size(XI,2)); % for usgs bathemetry
output_res = 1;
for i=1:size(XI,1)
    for j=1:size(XI,2)
        %%%%rotate the location point to the global coordinate
        xglobal=XI(i,j)*cos(-a)+YI(i,j)*sin(-a)+x0_fld;
        yglobal=YI(i,j)*cos(-a)-XI(i,j)*sin(-a)+y0_fld;
        idx1 = find((x >= (xglobal - 10)) & x < (xglobal + 10) & (y >= (yglobal - 10)) & y < (yglobal + 10));
        
        %         idx1
        %         length(idx1)
        %         figure;
        %         scatter(x,y,'bo')
        %         hold on
        %         plot(xglobal,yglobal,'r+','MarkerSize',6)
        %         hold on
        %         plot(x(idx1),y(idx1),'r*','MarkerSize',6)
        %         num2str(XI(i,j),'%10.5f')
        %         num2str(YI(i,j),'%10.5f')
        %         [x(idx1)',y(idx1)']
        %         h(idx1)'
  %         ind4=[find(yv1 == y(idx1(1))), find(xv1 == x(idx1(1)));
		      %             find(yv1 == y(idx1(2))), find(xv1 == x(idx1(2)));
		      %             find(yv1 == y(idx1(3))), find(xv1 == x(idx1(3)));
		      %             find(yv1 == y(idx1(4))), find(xv1 == x(idx1(4)))]
  %         interface(ind4)
  if(length(idx1)>1)
    %find 4 points that are closest to the targeting point
       xtemp = x(idx1);
ytemp = y(idx1);
htemp = h_RH(idx1);
xlow = max(xtemp(find(xtemp < xglobal)));
xupp = min(xtemp(find(xtemp >= xglobal)));
ylow = max(ytemp(find(ytemp < yglobal)));
yupp = min(ytemp(find(ytemp >= yglobal)));
z1 = htemp(find(xtemp == xlow & ytemp == ylow));
z2 = htemp(find(xtemp == xupp & ytemp == ylow));
z3 = htemp(find(xtemp == xupp & ytemp == yupp));
z4 = htemp(find(xtemp == xlow & ytemp == yupp));
Z1(i,j) = (z1*(xupp-xglobal)*(yupp-yglobal) + z2*(xglobal-xlow)*(yupp-yglobal) + z3*(xglobal-xlow)*(yglobal-ylow) +z4*(xupp-xglobal)*(yglobal-ylow))/((xupp-xlow)*(yupp-ylow));
end
% bathemetry
idx2 = find((x_bath >= (xglobal - 2)) & x_bath < (xglobal + 2) & (y_bath >= (yglobal - 2)) & y_bath < (yglobal + 2));
htemp = h_bath(idx2);
xtemp = x_bath(idx2);
ytemp = y_bath(idx2);
xlow = min(xtemp);
xupp = max(xtemp);
ylow = min(ytemp);
yupp = max(ytemp);
z1 = htemp(find(xtemp == xlow & ytemp == ylow));
z2 = htemp(find(xtemp == xupp & ytemp == ylow));
z3 = htemp(find(xtemp == xupp & ytemp == yupp));
z4 = htemp(find(xtemp == xlow & ytemp == yupp));
Z2(i,j) = (z1*(xupp-xglobal)*(yupp-yglobal) + z2*(xglobal-xlow)*(yupp-yglobal) + z3*(xglobal-xlow)*(yglobal-ylow) +z4*(xupp-xglobal)*(yglobal-ylow))/((xupp-xlow)*(yupp-ylow));
%for new Lidar DEM data
idx3 = find((x_bath_new >= (xglobal - 1)) & x_bath_new < (xglobal + 1) & (y_bath_new >= (yglobal - 1)) & y_bath_new < (yglobal + 1));
htemp = h_bath_new(idx3);
xtemp = x_bath_new(idx3);
ytemp = y_bath_new(idx3);
xlow = min(xtemp);
xupp = max(xtemp);
ylow = min(ytemp);
yupp = max(ytemp);
z1 = htemp(find(xtemp == xlow & ytemp == ylow));
z2 = htemp(find(xtemp == xupp & ytemp == ylow));
z3 = htemp(find(xtemp == xupp & ytemp == yupp));
z4 = htemp(find(xtemp == xlow & ytemp == yupp));
Z3(i,j) = (z1*(xupp-xglobal)*(yupp-yglobal) + z2*(xglobal-xlow)*(yupp-yglobal) + z3*(xglobal-xlow)*(yglobal-ylow) +z4*(xupp-xglobal)*(yglobal-ylow))/((xupp-xlow)*(yupp-ylow));
if(output_res)
  [XI(i,j),YI(i,j)]
    [xglobal yglobal]
    display "New LiDar"
    idx3
    xtemp
    ytemp
    htemp
    [z1 z2 z3 z4]
    Z3(i,j)
    end
        
    %for USGS DEM data
    idx4 = find((x_bath_USGS >= (xglobal - 2.8914)) & x_bath_USGS < (xglobal + 2.8914) & (y_bath_USGS >= (yglobal - 2.8914)) & y_bath_USGS < (yglobal + 2.8914));
htemp = h_bath_USGS(idx4);
xtemp = x_bath_USGS(idx4);
ytemp = y_bath_USGS(idx4);
xlow = min(xtemp);
xupp = max(xtemp);
ylow = min(ytemp);
yupp = max(ytemp);
z1 = htemp(find(xtemp == xlow & ytemp == ylow));
z2 = htemp(find(xtemp == xupp & ytemp == ylow));
z3 = htemp(find(xtemp == xupp & ytemp == yupp));
z4 = htemp(find(xtemp == xlow & ytemp == yupp));
Z4(i,j) = (z1*(xupp-xglobal)*(yupp-yglobal) + z2*(xglobal-xlow)*(yupp-yglobal) + z3*(xglobal-xlow)*(yglobal-ylow) +z4*(xupp-xglobal)*(yglobal-ylow))/((xupp-xlow)*(yupp-ylow));        
if(output_res)
  display "USGS DEM"
    idx4
    xtemp
    ytemp
    htemp
    [z1 z2 z3 z4]
    Z4(i,j)
    end
    end
    end
    figure
    subplot(2,2,1)
    contourf(XI,YI,Z1)
    title('R/H Contact')
    axis equal
    set(gca,'FontName','Times','FontSize',16)
    xlim([0 400])
    ylim([0 400])
    caxis([85 103])
    colorbar

    subplot(2,2,2)
    contourf(XI,YI,Z2)
    caxis([100 120])
    title('Bathemetry')
    axis equal
    set(gca,'FontName','Times','FontSize',16)
    xlim([0 400])
    ylim([0 400])
    colorbar

    % subplot(2,2,3)
    % contourf(XI,YI,Z2-Z1)
    % title('Bathemetry - R/H Contact')
    % axis equal
    % set(gca,'FontName','Times','FontSize',16)
    % xlim([0 400])
    % ylim([0 400])
    % colorbar
    subplot(2,2,3)
    contourf(XI,YI,Z4)
    caxis([100 120])
    title('USGS DEM')
    axis equal
    set(gca,'FontName','Times','FontSize',16)
    xlim([0 400])
    ylim([0 400])
    colorbar


    subplot(2,2,4)
    contourf(XI,YI,Z3)
    caxis([100 120])
    title('New Lidar DEM')
    axis equal
    set(gca,'FontName','Times','FontSize',16)
    xlim([0 400])
    ylim([0 400])
    colorbar
    % Create indicators
    % zv = [grid.d_pts(3)/2 :grid.d_pts(3): grid.n_pts(3)*grid.d_pts(3)] + z0_fld;
% ind_RH = ones(prod(grid.n_pts),1);
% ct=1;
% for k = 1:grid.n_pts(3)
	    %     for j = 1:grid.n_pts(2)
			    %         for i = 1:grid.n_pts(1)
						%             xx = XI(j,i);
%             yy = YI(j,i);
%             zz1 = Z1(j,i); 
%             zz2 = Z2(j,i);
%             if(~isnan(zz1))
		%                 if(zv(k)>zz2)
				    %                     ind_RH(ct) = 0;
%                 end
%                 if(zv(k)<=zz2 && zv(k)>zz1)
		    %                     ind_RH(ct) = 1;
%                 end
%                 if(zv(k)<=zz1)
		    %                     ind_RH(ct) = 4;
%                 end 
%             end
%             if(isnan(zz1))
		    %                 if(zv(k)>zz2)
					%                     ind_RH(ct) = 0;
%                 end
%                 if(zv(k)<=zz2)
		    %                     ind_RH(ct) = 4;
%                 end
%             end
%             ct=ct+1;
%         end
%     end
% end
% 
% ind_RH=int32(ind_RH); 
% cellid=int32([1:prod(grid.n_pts)]);
% %save('material_ids_bilinear.txt','ind_RH','-ascii');
% 
% %---------------
% % Save Ringold-Hanford Interface
% hdf5write(['Plume_400x400x20_2mx2mxhalfRes_material.h5'],'/Materials/Cell Ids',cellid);
% hdf5write(['Plume_400x400x20_2mx2mxhalfRes_material.h5'],'/Materials/Material Ids',ind_RH,'WriteMode','append');
% display 'done!'

% %comapre new and old interfaces
% ind_RH_old = hdf5read(['plot120x120x15_ngrid' gridxyz '_material_old.h5'],['/Materials/Material Ids']);

% %find the depth at well locations
% %read in the coordinates of all the wells
% [wells well_x well_y well_top Borehole_ID top_screen bot_screen contact_depth] = textread('well_list_full_IFRC.txt','%s %f %f %f %s %f %f %f ','headerlines',1);
% nwell = length(well_x);
% zwell = zeros(nwell,1);
% contact_elev = zeros(nwell,1);
% for i = 1:nwell
	    %     xglobal = well_x(i);
%     yglobal = well_y(i);
%     idx1 = find((x >= (xglobal - dx)) & x < (xglobal + dx) & (y >= (yglobal - dy)) & y < (yglobal + dy));
%     %         idx1
%     %         length(idx1)
%     %         figure;
%     %         scatter(x,y,'bo')
%     %         hold on
%     %         plot(xglobal,yglobal,'r+','MarkerSize',6)
%     %         hold on
%     %         plot(x(idx1),y(idx1),'r*','MarkerSize',6)
%     %         num2str(XI(i,j),'%10.5f')
%     %         num2str(YI(i,j),'%10.5f')
%     %         [x(idx1)',y(idx1)']
%     %         h(idx1)'
%     %         ind4=[find(yv1 == y(idx1(1))), find(xv1 == x(idx1(1)));
%     %             find(yv1 == y(idx1(2))), find(xv1 == x(idx1(2)));
%     %             find(yv1 == y(idx1(3))), find(xv1 == x(idx1(3)));
%     %             find(yv1 == y(idx1(4))), find(xv1 == x(idx1(4)))]
%     %         interface(ind4)
%     htemp = h(idx1);
%     xtemp = x(idx1);
%     ytemp = y(idx1);
%     xlow = min(xtemp);
%     xupp = max(xtemp);
%     ylow = min(ytemp);
%     yupp = max(ytemp);
%     z1 = htemp(find(xtemp == xlow & ytemp == ylow));
%     z2 = htemp(find(xtemp == xupp & ytemp == ylow));
%     z3 = htemp(find(xtemp == xupp & ytemp == yupp));
%     z4 = htemp(find(xtemp == xlow & ytemp == yupp));
%     zwell(i) = (z1*(xupp-xglobal)*(yupp-yglobal) + z2*(xglobal-xlow)*(yupp-yglobal) + z3*(xglobal-xlow)*(yglobal-ylow) +z4*(xupp-xglobal)*(yglobal-ylow))/((xupp-xlow)*(yupp-ylow));
%     contact_elev(i) = well_top(i) - 0.3048 * contact_depth(i);
% end

