n = 40;
m = 3;
for i = 1:n
    for j = 1:m
        peak = max(Tracer{j,i});
        Tracer_norm{j,i} = Tracer{j,i}./peak;
    end
end        
% for i = 1:36
%     subplot(6,6,i);
%     plot(Time_data{i}-191.58,Tracer_norm{1,i},'*-','LineWidth',2);
%     title(wellnames_data{i});
% end
for i = 1:40
    subplot(6,7,i);
    plot(Time_data{i},Tracer{3,i},'*-','LineWidth',2);
    title(wellnames_data{i});
end
xlabel('Time (h)');
ylabel('Normalized concentration');
% subplot(4,4,1);
% plot(Time_data{1}-191.58,Tracer_norm{1,1},'*-','LineWidth',2);
% title(wellnames_data{1});
% subplot(4,4,2);
% plot(Time_data{2}-191.58,Tracer_norm{1,2},'*-','LineWidth',2);
% title(wellnames_data{1});
% subplot(4,4,3);
% plot(Time_data{3}-191.58,Tracer_norm{1,3},'*-','LineWidth',2);
% title(wellnames_data{1});
% subplot(4,4,4);
% plot(Time_data{4}-191.58,Tracer_norm{1,4},'*-','LineWidth',2);
% title(wellnames_data{1});
% subplot(4,4,5);
% plot(Time_data{5}-191.58,Tracer_norm{1,5},'*-','LineWidth',2);
% title(wellnames_data{1});
% subplot(4,4,6);
% plot(Time_data{6}-191.58,Tracer_norm{1,6},'*-','LineWidth',2);
% title(wellnames_data{1});
% subplot(4,4,7);
% plot(Time_data{7}-191.58,Tracer_norm{1,7},'*-','LineWidth',2);
% title(wellnames_data{1});
% subplot(4,4,8);
% plot(Time_data{8}-191.58,Tracer_norm{1,8},'*-','LineWidth',2);
% title(wellnames_data{1});
% subplot(4,4,9);
% plot(Time_data{9}-191.58,Tracer_norm{1,9},'*-','LineWidth',2);
% subplot(4,4,10);
% plot(Time_data{10}-191.58,Tracer_norm{1,10},'*-','LineWidth',2);
% subplot(4,4,11);
% plot(Time_data{11}-191.58,Tracer_norm{1,11},'*-','LineWidth',2);
% subplot(4,4,12);
% plot(Time_data{12}-191.58,Tracer_norm{1,12},'*-','LineWidth',2);
% subplot(4,4,13);
% plot(Time_data{13}-191.58,Tracer_norm{1,13},'*-','LineWidth',2);
% subplot(4,4,14);
% plot(Time_data{14}-191.58,Tracer_norm{1,14},'*-','LineWidth',2);
% subplot(4,4,15);
% plot(Time_data{15}-191.58,Tracer_norm{1,15},'*-','LineWidth',2);
% subplot(4,4,16);
% plot(Time_data{16}-191.58,Tracer_norm{1,16},'*-','LineWidth',2);
