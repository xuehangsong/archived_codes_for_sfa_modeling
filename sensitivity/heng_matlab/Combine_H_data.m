% for k = 1:6
%     for i = 1:10
%         for j = 1:100
%             Headt{k+4,i,j} = Headt_5_10{k,i,j};
%         end
%     end
% end

for k = 1:6
    for i = 1:10
        for j = 1:100
            fluxavc1t{k+4,i,j} = fluxavc1t_5_10{k,i,j};
        end
    end
end

for k = 1:6
    for i = 1:10
        for j = 1:100
            Timet{k+4,i,j} = Timet_5_10{k,i,j};
        end
    end
end

for k = 1:6
    for i = 1:10
        wellnamegroupt{k+4,i} = wellnamegroupt_5_10{k,i};
    end
end
% 
% for k = 1:6
%     for i = 1:10
%         wellnamet{k+4,i} = wellnamet_5_10{k,i};
%     end
% end