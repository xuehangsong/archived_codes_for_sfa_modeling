nsim = 15;
h_cs = load(sprintf('C:\\Users\\daih524\\Desktop\\2015_Spring\\Data_for_Test_Case\\BC_Data_From_Chen\\4heng\\BC_CS\\Whole_h161.txt'));
for i = 1:nsim
    h(1:120,1:120,i) = reshape(h_cs(:,i),[120 120]);
end
subplot(2,2,1);
surface(1:120,1:120,h(:,:,11)');
subplot(2,2,2);
surface(1:120,1:120,h(:,:,12)');
subplot(2,2,3);
surface(1:120,1:120,h(:,:,13)');
subplot(2,2,4);
surface(1:120,1:120,h(:,:,14)');