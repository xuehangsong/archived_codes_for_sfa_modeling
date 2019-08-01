Head_t(2,:,:,:,:) = Head_t_1(2,:,:,:,:);
Head_t(4,:,:,:,:) = Head_t_1(4,:,:,:,:);
Head_t(6,:,:,:,:) = Head_t_1(6,:,:,:,:);

fluxavc1_t(2,:,:,:,:) = fluxavc1_t_1(2,:,1:99,:,:);
fluxavc1_t(4,:,:,:,:) = fluxavc1_t_1(4,:,1:99,:,:);
fluxavc1_t(6,:,:,:,:) = fluxavc1_t_1(6,:,1:99,:,:);

for i = 1:82
    for j = 1:10
        if cbreak1_1(i,j) == 1;
            cbreak1(i,j) = 1;
        end
    end
end