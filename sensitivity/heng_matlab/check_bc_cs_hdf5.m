
BC_East2 = h5read('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/BC_hdf5_CS/BC_sim10.h5','/BC_East/Data');
BC_South2 = h5read('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/BC_hdf5_CS/BC_sim10.h5','/BC_South/Data');
BC_North2 = h5read('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/BC_hdf5_CS/BC_sim10.h5','/BC_North/Data');
BC_West2 = h5read('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/BC_hdf5_CS/BC_sim10.h5','/BC_West/Data');
subplot(2,2,1);
hold all;
plot(1:120,BC_South2(t,1:120),'-*','LineWidth',3);
plot(1:120,BC_cs(1:120,10+2,t),'LineWidth',3);

subplot(2,2,2);
hold all;
plot(1:120,BC_North2(t,1:120),'-*','LineWidth',3);
plot(1:120,BC_cs(121:240,10+2,t),'LineWidth',3);

subplot(2,2,3);
hold all;
plot(1:120,BC_West2(t,1:120),'-*','LineWidth',3);
plot(1:120,BC_cs(241:360,10+2,t),'LineWidth',3);

subplot(2,2,4);
hold all;
plot(1:120,BC_East2(t,1:120),'-*','LineWidth',3);
plot(1:120,BC_cs(361:480,10+2,t),'LineWidth',3);