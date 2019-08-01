D_H_res = reshape(D_H,9900,1);
D_T1_res = reshape(D_T1,9900,1);
D_T2_res = reshape(D_T2,9900,1);
D_T3_res = reshape(D_T3,9900,1);
D_T1_sort = sort(D_T1_res);
D_T2_sort = sort(D_T2_res);
D_T3_sort = sort(D_T3_res);
for i = 1:9900
    [m,n] = find(D_T1 == D_T1_sort(i));
    Rank_T1(m,n) = i;
    [m,n] = find(D_T2 == D_T2_sort(i));
    Rank_T2(m,n) = i;
    [m,n] = find(D_T3 == D_T3_sort(i));
    Rank_T3(m,n) = i;
end
Rank_total = Rank_T1 + Rank_T2 + Rank_T3;
[m,n] = find(Rank_total == max(max(Rank_total)));