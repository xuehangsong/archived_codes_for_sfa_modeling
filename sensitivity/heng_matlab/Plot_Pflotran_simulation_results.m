n = 1;
m = 1;
w = 2;
wellname = strrep(wellname,'_','-');
subplot(2,2,1);
P_temp1 = Pressure{n,m}(w,:);
plot(Time{n,m}(:),P_temp1,'LineWidth',3);
set(gca,'fontsize',16)
xlabel('Time (h)');
ylabel('Pressure head (Pa)');
title(wellname{w});
subplot(2,2,2);
T1_temp = Tracer1{n,m}(w,:);
plot(Time{n,m}(:),T1_temp,'LineWidth',3);
set(gca,'fontsize',16)
xlabel('Time (h)');
ylabel('Tracer 1 (mol/L)');
title(wellname{w});
subplot(2,2,3);
T2_temp = Tracer2{n,m}(w,:);
plot(Time{n,m}(:),T2_temp,'LineWidth',3);
set(gca,'fontsize',16)
xlabel('Time (h)');
ylabel('Tracer 2 (mol/L)');
title(wellname{w});
subplot(2,2,4);
T3_temp = Tracer3{n,m}(w,:);
plot(Time{n,m}(:),T3_temp,'LineWidth',3);
set(gca,'fontsize',16)
xlabel('Time (h)');
ylabel('Tracer 3 (mol/L)');
title(wellname{w});