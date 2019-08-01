CS(1:120,1:120,101) = depth;
CS(1:120,1:120,101) = krige_data;
for i = 1:120
    for j = 1:120
        CS_var_100(i,j) = var(CS(i,j,:));
    end
end
surface(1:120,1:120,CS_var_100','edgecolor','none');
set(gca,'fontsize',14)
view(2);
axis square;
box on;
axis([0 120 0 120]);
xlabel('X (m)','fontsize',20);
ylabel('Y (m)','fontsize',20);
title('Variance of contact surface simulations');