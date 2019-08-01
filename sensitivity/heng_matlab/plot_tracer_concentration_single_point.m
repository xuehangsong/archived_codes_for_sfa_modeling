nsim = 100;
subplot(3,4,1)
hold all;
h1 = plot(Time_35{1}(1,:),Tracer2_35{1}(96,:)/0.001,'b-','LineWidth',2);
for k = 10:10:nsim
    plot(Time{k},Tracer2_35{k}(96,:)/0.001,'b-','LineWidth',2);
end
h2 = plot(time_0{3},Br0{3}/100,'k*');
%h2 = plot(time_0{3},max((Cl0{3}-mean(Cl01{3}(end-10:end)))/100,0),'k*');
ylabel('Normalized concentration');
%xlabel('Time (h)');
%legend([h1,h2],{'Material ID simulations permeability 35','Data'});
title('Well 2-8-1');

subplot(3,4,2)
hold all;
h1 = plot(Time_35{1}(1,:),Tracer2_35{1}(97,:)/0.001,'b-','LineWidth',2);
for k = 10:10:nsim
    plot(Time{k},Tracer2_35{k}(97,:)/0.001,'b-','LineWidth',2);
end
%h2 = plot(time_0{3},max((Cl0{3}-mean(Cl01{3}(end-10:end)))/100,0),'k*');
h2 = plot(time_0{3},Br0{3}/100,'k*');
%ylabel('Normalized concentration');
%xlabel('Time (h)');
%legend([h1,h2],{'Material ID simulations permeability 35','Data'});
title('Well 2-8-2');

subplot(3,4,3)
hold all;
h1 = plot(Time_35{1}(1,:),Tracer2_35{1}(98,:)/0.001,'b-','LineWidth',2);
for k = 10:10:nsim
    plot(Time{k},Tracer2_35{k}(98,:)/0.001,'b-','LineWidth',2);
end
%h2 = plot(time_0{3},max((Cl0{3}-mean(Cl01{3}(end-10:end)))/100,0),'k*');
h2 = plot(time_0{3},Br0{3}/100,'k*');
%ylabel('Normalized concentration');
%xlabel('Time (h)');
%legend([h1,h2],{'Material ID simulations permeability 35','Data'});
title('Well 2-8-3');

subplot(3,4,4)
hold all;
h1 = plot(Time_35{1}(1,:),Tracer2_35{1}(99,:)/0.001,'b-','LineWidth',2);
for k = 10:10:nsim
    plot(Time{k},Tracer2_35{k}(99,:)/0.001,'b-','LineWidth',2);
end
%h2 = plot(time_0{3},max((Cl0{3}-mean(Cl01{3}(end-10:end)))/100,0),'k*');
h2 = plot(time_0{3},Br0{3}/100,'k*');
%ylabel('Normalized concentration');
%xlabel('Time (h)');
legend([h1,h2],{'Material ID simulations permeability 35','Data'});
title('Well 2-8-4');

subplot(3,4,5)
hold all;
h1 = plot(Time_35{1}(1,:),Tracer2_35{1}(100,:)/0.001,'b-','LineWidth',2);
for k = 10:10:nsim
    plot(Time{k},Tracer2_35{k}(100,:)/0.001,'b-','LineWidth',2);
end
%h2 = plot(time_0{1},max((Cl0{1}-mean(Cl01{1}(end-10:end)))/100,0),'k*');
h2 = plot(time_0{1},Br0{1}/100,'k*');
ylabel('Normalized concentration');
%xlabel('Time (h)');
%legend([h1,h2],{'Material ID simulations permeability 35','Data'});
title('Well 2-9-1');

subplot(3,4,6)
hold all;
h1 = plot(Time_35{1}(1,:),Tracer2_35{1}(101,:)/0.001,'b-','LineWidth',2);
for k = 10:10:nsim
    plot(Time{k},Tracer2_35{k}(101,:)/0.001,'b-','LineWidth',2);
end
%h2 = plot(time_0{1},max((Cl0{1}-mean(Cl01{1}(end-10:end)))/100,0),'k*');
h2 = plot(time_0{1},Br0{1}/100,'k*');
%ylabel('Normalized concentration');
%xlabel('Time (h)');
%legend([h1,h2],{'Material ID simulations permeability 35','Data'});
title('Well 2-9-2');

subplot(3,4,7)
hold all;
h1 = plot(Time_35{1}(1,:),Tracer2_35{1}(102,:)/0.001,'b-','LineWidth',2);
for k = 10:10:nsim
    plot(Time{k},Tracer2_35{k}(102,:)/0.001,'b-','LineWidth',2);
end
%h2 = plot(time_0{1},max((Cl0{1}-mean(Cl01{1}(end-10:end)))/100,0),'k*');
h2 = plot(time_0{1},Br0{1}/100,'k*');
%ylabel('Normalized concentration');
%xlabel('Time (h)');
%legend([h1,h2],{'Material ID simulations permeability 35','Data'});
title('Well 2-9-3');

subplot(3,4,9)
hold all;
h1 = plot(Time_35{1}(1,:),Tracer2_35{1}(114,:)/0.001,'b-','LineWidth',2);
for k = 10:10:nsim
    plot(Time{k},Tracer2_35{k}(114,:)/0.001,'b-','LineWidth',2);
end
%h2 = plot(time_0{2},max((Cl0{2}-mean(Cl01{2}(end-10:end)))/100,0),'k*');
h2 = plot(time_0{2},Br0{2}/100,'k*');
ylabel('Normalized concentration');
xlabel('Time (h)');
%legend([h1,h2],{'Material ID simulations permeability 35','Data'});
title('Well 2-34-1');

subplot(3,4,10)
hold all;
h1 = plot(Time_35{1}(1,:),Tracer2_35{1}(115,:)/0.001,'b-','LineWidth',2);
for k = 10:10:nsim
    plot(Time{k},Tracer2_35{k}(115,:)/0.001,'b-','LineWidth',2);
end
%h2 = plot(time_0{2},max((Cl0{2}-mean(Cl01{2}(end-10:end)))/100,0),'k*');
h2 = plot(time_0{2},Br0{2}/100,'k*');
%ylabel('Normalized concentration');
xlabel('Time (h)');
%legend([h1,h2],{'Material ID simulations permeability 35','Data'});
title('Well 2-34-2');

subplot(3,4,11)
hold all;
h1 = plot(Time_35{1}(1,:),Tracer2_35{1}(116,:)/0.001,'b-','LineWidth',2);
for k = 10:10:nsim
    plot(Time{k},Tracer2_35{k}(116,:)/0.001,'b-','LineWidth',2);
end
%h2 = plot(time_0{2},max((Cl0{2}-mean(Cl01{2}(end-10:end)))/100,0),'k*');
h2 = plot(time_0{2},Br0{2}/100,'k*');
%ylabel('Normalized concentration');
xlabel('Time (h)');
%legend([h1,h2],{'Material ID simulations permeability 35','Data'});
title('Well 2-34-3');

