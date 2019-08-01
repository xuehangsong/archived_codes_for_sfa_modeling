%not working, out of memory.
C = combnk(1:50,4);
for i = 1:max(size(C))
    c = C(i,:);
%     i1 = min(C(i,:));
%     i3 = max(C(i,:));
%     b = c(c~=i1);
%     i2 = b(b~=i3);
%     %i2 = C(i,find((C(i,:)>min(C(i,:)))&&(C(i,:)<max(C(i,:)))));
%     Dc3_1(i) = D_T1(i1,i2) + D_T1(i1,i3) + D_T1(i2,i3);
%     Dc3_2(i) = D_T2(i1,i2) + D_T2(i1,i3) + D_T2(i2,i3);
%     Dc3_12(i) = D_T12(i1,i2) + D_T12(i1,i3) + D_T12(i2,i3);
    c1 = combnk(c,2);
    for j = 1:max(size(c1))
        c2 = c(c~=c1(j,:));
        c3 = combnk(c2,2);
        for k = 1:max(size(c3))
            c4 = c2(c2~=c3(k,:));
            c5 = combnk(c4,2);
            for l = 1:max(size(c5))
                c6 = c4(c4~=c5(l,:));
                c1s = sort(c1(:,j));
                c3s = sort(c3(:,k));
                c5s = sort(c5(:,l));
                c6s = sort(c6);
                Dc8_1(i,j,k,l) = D_T1(c1s(1),c1s(2)) + D_T1(c3s(1),c3s(2)) + D_T1(c5s(1),c5s(2)) + D_T1(c6s(1),c6s(2));
                Dc8_2(i,j,k,l) = D_T2(c1s(1),c1s(2)) + D_T2(c3s(1),c3s(2)) + D_T2(c5s(1),c5s(2)) + D_T2(c6s(1),c6s(2));
                Dc8_12(i,j,k,l) = D_T12(c1s(1),c1s(2)) + D_T12(c3s(1),c3s(2)) + D_T12(c5s(1),c5s(2)) + D_T12(c6s(1),c6s(2));
            end
        end
    end
end
maxind1 = find(Dc8_1 == max(max(max(max((Dc8_1))))));
maxind2 = find(Dc8_2 == max(max(max(max((Dc8_2))))));
maxind12 = find(Dc8_12 == max(max(max(max((Dc8_12))))));
% maxind1 = find(Dc3_1 == max(Dc3_1));
% maxind2 = find(Dc3_2 == max(Dc3_2));
% maxind12 = find(Dc3_12 == max(Dc3_12)); 
comb1 = C(maxind1(1),:);
comb2 = C(maxind2(1),:);
comb12 = C(maxind12(1),:);