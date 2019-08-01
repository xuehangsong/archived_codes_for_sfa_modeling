for i = 1:4
    subplot(2,2,i);
    h_temp(1:120,1:120) = h_total(1,1,1,i,:,:);
    surf(h_temp,'edgecolor','none');
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
