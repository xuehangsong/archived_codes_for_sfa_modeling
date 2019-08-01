subplot(2,1,1); 
hold all;
for i = 1:4
     plot(timec(1:1003),fluxavc1t{i,3,5}(30,1:1003)/0.001,'b');
end
legend('BC simulations');
title('Well 4-13','Fontsize',16);
subplot(2,1,2);
hold all;
for i = 1:4
     plot(timec(1:1003),fluxavc1t{4,i,5}(30,1:1003)/0.001,'b');
end
legend('MID simulations');
xlabel('Time (hour)','Fontsize',16);
ylabel('Normalized tracer 1 concentration','Fontsize',16);