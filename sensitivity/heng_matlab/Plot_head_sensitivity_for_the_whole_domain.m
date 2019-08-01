for i = 1:4
    subplot(3,4,i);
    hold all;
    scatter3(Well_add_120(1:40,1),Well_add_120(1:40,2),120*ones(40,1),20,'ko');
scatter3(60.11, 83.76,120,30,'ko','fill');
    surf(S_S_new(:,:,i),'edgecolor','none');
    if i == 1
        ylabel('Y (m)');
    end
    xlim([1 120]);
    ylim([1 120]);
    view(2);
    caxis([0.5,1]);
    set(gca,'Fontsize',14);
    colormap jet;

    axis square;
    if i == 1
        title('Time = 10 hours','Fontsize',18);
    elseif i == 2
        title('50 hours','Fontsize',18);
        
    elseif i == 3
        title('100 hours','Fontsize',18);
    elseif i == 4
        title('150 hours','Fontsize',18);
        colorbar;
            hcb=colorbar;
    set(hcb,'YTick',[0.5,0.75,1])
    end
    subplot(3,4,4+i);
    hold all;
    scatter3(Well_add_120(1:40,1),Well_add_120(1:40,2),120*ones(40,1),20,'ko');
scatter3(60.11, 83.76,120,30,'ko','fill');
    surf(S_M_new(:,:,i),'edgecolor','none');
    if i == 1
        ylabel('Y (m)');
    end
    caxis([0,0.1]);
    xlim([1 120]);
    ylim([1 120]);
    view(2);
    %caxis([104.6,105]);
    set(gca,'Fontsize',14);
    colormap jet;
    %    xlabel('X (m)');
    %    ylabel('Y (m)');
    axis square;
    if i == 4
        colorbar;
    end
    subplot(3,4,8+i);
    hold all;
    scatter3(Well_add_120(1:40,1),Well_add_120(1:40,2),120*ones(40,1),20,'ko');
scatter3(60.11, 83.76,120,30,'ko','fill');
    surf(S_T_new(:,:,i),'edgecolor','none');
    if i == 1
        ylabel('Y (m)');
    end
    caxis([0,0.5]);
    xlim([1 120]);
    ylim([1 120]);
    view(2);
    %caxis([104.6,105]);
    set(gca,'Fontsize',14);
    colormap jet;
    xlabel('X (m)');
    %    ylabel('Y (m)');
    axis square;
    if i == 4
        colorbar;
                    hcb=colorbar;
    set(hcb,'YTick',[0,0.25,0.5])
    end
end