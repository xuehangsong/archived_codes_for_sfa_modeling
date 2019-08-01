nsim = 100;
for i = 1:nsim
    CS_cs(1:14400,i) = load(sprintf('C:\\Users\\daih524\\Desktop\\2015_Spring\\Data_for_Test_Case\\BC_Data_From_Chen\\4heng\\CS_CS\\CS%d.txt',i));
    CS(1:120,1:120,i) = reshape(CS_cs(:,i),[120 120]);
end
for i = 1:120
    for j = 1:120
        std_CS(i,j) = std(CS(i,j,:));
    end
end
surf(std_CS');
hold all;
scatter3(Well_in_120(:,1)+0.5,Well_in_120(:,2)+0.5,120*ones(40,1),150,'ko');
set(gca,'fontsize',16)
text(Well_in_120(:,1), Well_in_120(:,2), 120*ones(40,1),labels1, 'VerticalAlignment','bottom', ...
                             'HorizontalAlignment','right')