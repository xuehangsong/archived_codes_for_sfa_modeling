%subplot(2,2,1);
surf(D_T1,'edgecolor','none');
xlabel('Realization ID','fontsize',20);
ylabel('Realization ID','fontsize',20);
%title('Tracer 1','fontsize',20);
view(2);
axis square;
box on;
colorbar;
set(gca,'fontsize',20)
% subplot(2,2,2);
% surf(D_T2);
% xlabel('Simulation index');
% ylabel('Simulation index');
% title('Tracer 2');
% subplot(2,2,3);
% surf(D_T12);
% xlabel('Simulation index');
% ylabel('Simulation index');
% title('Tracer 3');
