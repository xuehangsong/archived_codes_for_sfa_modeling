for i = 1:4
    subplot(2,2,i);
        hold all;
    scatter3(Well_add_120(:,1),Well_add_120(:,2),120*ones(82,1),20,'ko');
scatter3(60.11, 83.76,120,30,'ko','fill');
    tracer_temp(1:120,1:120) = tracer_total(i,1,1,1,:,:)/0.001;
    surf(tracer_temp,'edgecolor','none');
    xlim([1 120]);
    ylim([1 120]);
    view(2);
    %caxis([104.6,105]);
    set(gca,'Fontsize',14);
    colormap jet;
    xlabel('X (m)');
    ylabel('Y (m)');
    colorbar;
    axis square;
    if i == 1
        title('Time = 10 hours');
    elseif i == 2
        title('Time = 50 hours');
        
    elseif i == 3
        title('Time = 100 hours');
    elseif i == 4
        title('Time = 150 hours');
    end
end
