C = combnk(1:100,3);
for i = 1:max(size(C))
    c = C(i,:);
    i1 = min(C(i,:));
    i3 = max(C(i,:));
    b = c(c~=i1);
    i2 = b(b~=i3);
    %i2 = C(i,find((C(i,:)>min(C(i,:)))&&(C(i,:)<max(C(i,:)))));
    Dc3_1(i) = D_T1(i1,i2) + D_T1(i1,i3) + D_T1(i2,i3);
    Dc3_2(i) = D_T2(i1,i2) + D_T2(i1,i3) + D_T2(i2,i3);
    Dc3_12(i) = D_T12(i1,i2) + D_T12(i1,i3) + D_T12(i2,i3);
end
maxind1 = find(Dc3_1 == max(Dc3_1));
maxind2 = find(Dc3_2 == max(Dc3_2));
maxind12 = find(Dc3_12 == max(Dc3_12)); 
comb1 = C(maxind1,:);
comb2 = C(maxind2,:);
comb12 = C(maxind12,:);