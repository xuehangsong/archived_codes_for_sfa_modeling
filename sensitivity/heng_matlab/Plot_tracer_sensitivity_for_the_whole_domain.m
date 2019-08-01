for i = 1:4
    for ii = 1:120
        for jj = 1:120
            if max(max(max(tracer_total(i,:,:,:,ii,jj)/0.001)))<0.05
                S_S_c1_new(ii,jj,i) = 0;
                S_M_c1_new(ii,jj,i) = 0;
                S_T_c1_new(ii,jj,i) = 0;
            end
        end
    end
    subplot(3,4,i);
    hold all;
    scatter3(Well_add_120(1:40,1),Well_add_120(1:40,2),120*ones(40,1),20,'ko');
    scatter3(60.11, 83.76,120,30,'ko','fill');
    h = surf(S_S_c1_new(:,:,i),'edgecolor','none');
    pause(1);
    
    S_S_c1_new(S_S_c1_new== 0) = NaN;
    set(h, 'zdata', S_S_c1_new(:,:,i))
    if i == 1
        ylabel('Y (m)');
    end
    xlim([1 120]);
    ylim([1 120]);
    view(2);
    caxis([0,0.3]);
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
    end
    set(gca,'TickLength',[0.05,0.05]);
    box on;
    subplot(3,4,4+i);
    hold all;
    scatter3(Well_add_120(1:40,1),Well_add_120(1:40,2),120*ones(40,1),20,'ko');
    scatter3(60.11, 83.76,120,30,'ko','fill');
    h = surf(S_M_c1_new(:,:,i),'edgecolor','none');
    pause(1);
    S_M_c1_new(S_M_c1_new== 0) = NaN;
    set(h, 'zdata', S_M_c1_new(:,:,i))
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
    set(gca,'TickLength',[0.05,0.05]);
    box on;
    subplot(3,4,8+i);
    hold all;
    scatter3(Well_add_120(1:40,1),Well_add_120(1:40,2),120*ones(40,1),20,'ko');
    scatter3(60.11, 83.76,120,30,'ko','fill');
    h = surf(S_T_c1_new(:,:,i),'edgecolor','none');
    pause(1);
    S_T_c1_new(S_T_c1_new== 0) = NaN;
    set(h, 'zdata', S_T_c1_new(:,:,i))
    if i == 1
        ylabel('Y (m)');
    end
    caxis([0.6,1]);
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
    end
    set(gca,'TickLength',[0.05,0.05]);
    box on;
end