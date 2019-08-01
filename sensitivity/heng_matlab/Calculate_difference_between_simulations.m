%function [D_P,D_T1,D_T2,D_T3] = Calculate_difference_between_simulations(Pressure,Tracer1,Tracer2,Tracer3,Time,wellname)
m = 100;
n = 1;
%t1 = max(size(Time{1,1}));
%D_P(1:m-1,1:m)=0;
%D_P_temp(1:m-1,1:m,1:1500)=0;
well_num = max(size(wellnamegroup_76));
% Time{68,1} = Time{67,1};
% Pressure{68,1} = Pressure{67,1};
% Tracer1{68,1} = Tracer1{67,1};
% Tracer2{68,1} = Tracer2{67,1};
% Tracer3{68,1} = Tracer3{67,1};
% D_P_temp(1:99,1:100,1:well_num,1:1100) = 0;
% D_T1_temp(1:99,1:100,1:well_num,1:1100) = 0;
% D_T2_temp(1:99,1:100,1:well_num,1:1100) = 0;
% D_T3_temp(1:99,1:100,1:well_num,1:1100) = 0;
for i = 1:m-1
    i
    for j = i+1:m
        j
%        D_H(i,j) = 0;
        D_T1(i,j) = 0;
%        D_T2(i,j) = 0;
%        D_T3(i,j) = 0;
%        D_T12(i,j) = 0;
        for k = 1:well_num
            t = max(size(Time_76{i,n}(1,:)));
%            D_H_temp = 0;
            D_T1_temp = 0;
%            D_T2_temp = 0;
%            D_T3_temp = 0;
            for l = 2:t
                index = find(Time_76{j,n}(1,:)==Time_76{i,n}(1,l));
                if size(index)~=0
              %      D_H_temp = D_H_temp + abs(Head_well{j,n}(k,index)- Head_well{i,n}(k,l)).^2;
                    D_T1_temp = D_T1_temp + abs(fluxavc1_76{j,n}(k,index)/0.001- fluxavc1_76{i,n}(k,l)/0.001).^2;
%                    D_T2_temp = D_T2_temp + abs(fluxavc2_76{n,j}(k,index)- fluxavc2_76{n,i}(k,l)).^2;
%                    D_T3_temp = D_T3_temp + abs(fluxavc3_76{j,n}(k,index)- fluxavc3_76{i,n}(k,l)).^2;
%                     D_P_temp(i,j,k,l) = abs(Pressure{j,n}(k,index)- Pressure{i,n}(k,l)).^2;
%                     D_T1_temp(i,j,k,l) = abs(Tracer1{j,n}(k,index)- Tracer1{i,n}(k,l)).^2;
%                     D_T2_temp(i,j,k,l) = abs(Tracer2{j,n}(k,index)- Tracer2{i,n}(k,l)).^2;
%                     D_T3_temp(i,j,k,l) = abs(Tracer3{j,n}(k,index)- Tracer3{i,n}(k,l)).^2;
                end
            end
   %         D_H(i,j) = D_H(i,j) + D_H_temp;
            D_T1(i,j) = D_T1(i,j) + D_T1_temp;
%            D_T2(i,j) = D_T2(i,j) + D_T2_temp;
   %         D_T3(i,j) = D_T3(i,j) + D_T3_temp;
%             D_P_t(i,j,k) = sqrt(sum(D_P_temp(i,j,k,:)));
%             D_T1_t(i,j,k) = sqrt(sum(D_T1_temp(i,j,k,:)));
%             D_T2_t(i,j,k) = sqrt(sum(D_T2_temp(i,j,k,:)));
%             D_T3_t(i,j,k) = sqrt(sum(D_T3_temp(i,j,k,:)));
%            D_T12(i,j) = D_T12(i,j) + D_T1_temp + D_T2_temp;
        end
        D_T1(i,j) = sqrt(D_T1(i,j)/(well_num*max(size(index))));
%        D_T2(i,j) = sqrt(D_T2(i,j))/(well_num*max(size(index)));
%        D_T3(i,j) = sqrt(D_T3(i,j))/(well_num*max(size(index)));
%        D_T12(i,j) = sqrt(D_T12(i,j))/(well_num*max(size(index)));
    end
end
