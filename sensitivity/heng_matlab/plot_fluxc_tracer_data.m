S = 4;
M = 4;
nsim = 1;
%for i = 1:S
 %   for j = 1:M
        for k = 1:nsim
            fluxavc1_mgl{k} = fluxavc1{k}.*79.904*1000;
            fluxavc2_mgl{k} = fluxavc2{k}.*35.4530*1000;
        end
%   end
%end
plot(Time{1},fluxavc3{1}(30,:));
hold all;
plot(time10,Tracer3_10);
% plot(Time{1},fluxavc2_mgl{1}(35,:));
% hold all;
% plot(time5+191,Tracer2_5);
% subplot(2,2,1);
% plot(Time{1},fluxavc2_mgl{1}(30,:));
% hold all;
% plot(time3+191,Tracer2_3);
% legend('Simulation','Data');
% xlabel('Time (h)');
% ylabel('concentration (mg/L)');
% title(wellnamegroup{30});
% subplot(2,2,2);
% plot(Time{1},fluxavc2_mgl{1}(31,:));
% hold all;
% plot(time1+191,Tracer2_1);
% xlabel('Time (h)');
% ylabel('concentration (mg/L)');
% title(wellnamegroup{31});
% subplot(2,2,3);
% plot(Time{1},fluxavc2_mgl{1}(29,:));
% hold all;
% plot(time4+191,Tracer2_4);
% xlabel('Time (h)');
% ylabel('concentration (mg/L)');
% title(wellnamegroup{29});
% subplot(2,2,4);
% plot(Time{1},fluxavc2_mgl{1}(32,:));
% hold all;
% plot(time5+191,Tracer2_5);
% xlabel('Time (h)');
% ylabel('concentration (mg/L)');
% title(wellnamegroup{32});