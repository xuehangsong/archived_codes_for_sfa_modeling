%function [Time,Head_1,Head_well,fluxavc1,fluxavc2,fluxavc3,Tracer1,Tracer2,Tracer3,Qx,Qy,Qz,wellname,wellnamegroup] = Read_observation_well_data()
%function [Time,Head_1,Head_well,fluxavc1,fluxavc2,fluxavc3,wellname,wellnamegroup] = Read_observation_well_data()
function [Time,fluxavc1,wellname,wellnamegroup] = Read_observation_well_data()
%Read data for difference calculation
randcpu = 120;
%inputn = 100;
inputn = 100;
realn = 1;
% Preameability field number
realnum = 75;
pho = 996.877;
g = 9.81;
%Number of data types for one well.
n = 8;
for i = 1:inputn
    for j = 1:realn
        welln = 0;
        clear wellname_temp;
        for k = 1:randcpu
            openfolder = sprintf(['F:/PNNL_RESEARCH_FILES/BC_Simulation_results_10_20_76/pflotran%dR%d-obs-%d.tec'],i,j+realnum,k);
            if exist(openfolder,'file');
                fid = fopen(openfolder,'r');
                tline = fgetl(fid);
                indexnum = find(tline == '"');
                numofwells = ((max(size(indexnum))/2)-1)/n;
                welln = welln + numofwells;
                wellindex = find(tline =='W');
                for jj = 1:numofwells
                    wellname_temp{welln-numofwells+jj} = tline(wellindex((jj-1)*8+1):wellindex((jj-1)*8+1)+10);
                    if (j == 1)&&(i == 1)
                        wellname{welln-numofwells+jj} = tline(wellindex((jj-1)*8+1):wellindex((jj-1)*8+1)+10);
                    end
                end
                ii = 1;
                while (ischar(tline))
                    tline = fgetl(fid);
                    if (ischar(tline))
                        dtemp(ii,:) = str2num(tline);
                    end
                    ii = ii+1;
                end
                %                Time_temp(1:max(size(dtemp(:,1)))) = dtemp(:,1);
                %                Time{i,j}(1:max(size(Time_temp))) = Time_temp(:);
                for kk = 1:numofwells
                    if (j==1) && (i==1)
                        Time{i,j}(welln-numofwells+kk,:) = dtemp(:,1);
                        Pressure{i,j}(welln-numofwells+kk,:) = dtemp(:,n*(kk-1)+2);
                        Head{i,j}(welln-numofwells+kk,:) = dtemp(:,n*(kk-1)+2)./(pho*g);
                        Saturation{i,j}(welln-numofwells+kk,:) = dtemp(:,n*(kk-1)+3);
                        Tracer1{i,j}(welln-numofwells+kk,:) = dtemp(:,n*(kk-1)+4);
                        Tracer2{i,j}(welln-numofwells+kk,:) = dtemp(:,n*(kk-1)+5);
                        Tracer3{i,j}(welln-numofwells+kk,:) = dtemp(:,n*(kk-1)+6);
                        Qx{i,j}(welln-numofwells+kk,:) = dtemp(:,n*(kk-1)+7);
                        Qy{i,j}(welln-numofwells+kk,:) = dtemp(:,n*(kk-1)+8);
                        Qz{i,j}(welln-numofwells+kk,:) = dtemp(:,n*(kk-1)+9);
                    else
                        for kkk = 1:numel(wellname)
                            if(wellname_temp{welln-numofwells+kk}==wellname{kkk})
                                Time{i,j}(kkk,:) = dtemp(:,1);
                                Pressure{i,j}(kkk,:) = dtemp(:,n*(kk-1)+2);
                                Head{i,j}(kkk,:) = dtemp(:,n*(kk-1)+2)./(pho*g);
                                Saturation{i,j}(kkk,:) = dtemp(:,n*(kk-1)+3);
                                Tracer1{i,j}(kkk,:) = dtemp(:,n*(kk-1)+4);
                                Tracer2{i,j}(kkk,:) = dtemp(:,n*(kk-1)+5);
                                Tracer3{i,j}(kkk,:) = dtemp(:,n*(kk-1)+6);
                                Qx{i,j}(kkk,:) = dtemp(:,n*(kk-1)+7);
                                Qy{i,j}(kkk,:) = dtemp(:,n*(kk-1)+8);
                                Qz{i,j}(kkk,:) = dtemp(:,n*(kk-1)+9);
                            end
                        end
                    end
                end
                clear dtemp;
                fclose(fid);
            end
        end
    end
end
clear indexset;
clear indextot;
% Time{68,1} = Time{67,1};
% Pressure{68,1} = Pressure{67,1};
% Head{68,1} = Head{67,1};
% Tracer1{68,1} = Tracer1{67,1};
% Tracer2{68,1} = Tracer2{67,1};
% Tracer3{68,1} = Tracer3{67,1};
% Qx{68,1} = Qx{67,1};
% Qy{68,1} = Qy{67,1};
for i = 1:max(size(wellname))
    wellt = wellname{i}(6:9);
    if i == 1
        iii = 1;
        jjj = 1;
        indexset{iii}(1) = i;
        indextot(jjj) = i;
        jj = 1;
        for j = 2:max(size(wellname))
            if wellname{j}(6:9)==wellt
                jj = jj+1;
                jjj = jjj+1;
                indexset{iii}(jj) = j;
                indextot(jjj) = j;
            end
        end
    else
        if (min(size(find(indextot == i)))==0)
            iii = iii + 1;
            jjj = jjj + 1;
            indexset{iii}(1) = i;
            indextot(jjj) = i;
            jj = 1;
            for j = (i+1):max(size(wellname))
                if wellname{j}(6:9) == wellt
                    jj = jj +1;
                    jjj = jjj + 1;
                    indexset{iii}(jj) = j;
                    indextot(jjj) = j;
                end
            end
        end
    end
end
for i = 1:iii
    wellnamegroup{i} = wellname{indexset{i}(1)}(1:9);
end

clear fluxavc1;
clear fluxavc2;
clear fluxavc3;
clear v1;
clear sumv1;
for i = 1:inputn
    for j = 1:realn
        for k = 1:iii
            clear v1;
            clear sumv1;
            fluxavc1{i,j}(k,1:max(size(Time{i,j}(indexset{k}(1),:)))) = 0;
            fluxavc2{i,j}(k,1:max(size(Time{i,j}(indexset{k}(1),:)))) = 0;
            fluxavc3{i,j}(k,1:max(size(Time{i,j}(indexset{k}(1),:)))) = 0;
            sumv1(1:max(size(Time{i,j}(indexset{k}(1),:)))) = 0;
            for l = 1:max(size(indexset{k}))
                v1 = sqrt(Qx{i,j}(indexset{k}(l),:).^2 + Qy{i,j}(indexset{k}(l),:).^2);
                sumv1 = sumv1 + v1;
                fluxavc1{i,j}(k,:) = fluxavc1{i,j}(k,:) + v1.*Tracer1{i,j}(indexset{k}(l),:);
                fluxavc2{i,j}(k,:) = fluxavc2{i,j}(k,:) + v1.*Tracer2{i,j}(indexset{k}(l),:);
                fluxavc3{i,j}(k,:) = fluxavc3{i,j}(k,:) + v1.*Tracer3{i,j}(indexset{k}(l),:);
            end
            fluxavc1{i,j}(k,:) = fluxavc1{i,j}(k,:)./sumv1;
            fluxavc2{i,j}(k,:) = fluxavc2{i,j}(k,:)./sumv1;
            fluxavc3{i,j}(k,:) = fluxavc3{i,j}(k,:)./sumv1;            
        end
    end
end
% openfolder = ('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Input_deck_Add_Well_2_10/pflotran1.in');
% %openfolder = ('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/Test_case_Input/Input_deck/pflotran.in');
% fid = fopen(openfolder,'r');
% i = 1;
% tline = fgetl(fid);
% A{i} = tline;
% while ischar(tline)&& i<=880
%     i = i+1;
%     tline = fgetl(fid);
%     A{i} = tline;
% end
% fclose(fid);
% for i = 233:4:877
%     for j = 1:welln
%         if max(size(strfind(A{i},wellname{j})))>0
%             well_values(j,1:3) = str2num(A{i+1}(15:end));
%         end
%     end
% end
% for i = 1:inputn
%     for j = 1:realn
%         for k = 1:welln
%             Head_1{i,j}(k,:) = Head{i,j}(k,:) + well_values(k,3) - 101325/(pho*g);
%         end
%     end
% end
% for i = 1:inputn
%     for j = 1:realn
%         for i1 = 1:max(size(wellnamegroup))
%             Head_well{i,j}(i1,:) = Head_1{i,j}(indexset{i1}(1),:);
%         end
%     end
% end
openfolder = ('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Input_deck_add_more_wells_around/pflotran1.in');
%openfolder = ('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Multiple simulations results material ID/Input_deck/pflotran1.in');
fid = fopen(openfolder,'r');
i = 1;
tline = fgetl(fid);
A{i} = tline;
while ischar(tline)&& i<=2200
    i = i+1;
    tline = fgetl(fid);
    A{i} = tline;
end
fclose(fid);
for i = 233:4:2165
    for j = 1:welln
        if max(size(strfind(A{i},wellname{j})))>0
            well_values(j,1:3) = str2num(A{i+1}(15:end));
        end
    end
end
for i = 1:inputn
    for k = 1:welln
        Head_1{i}(k,:) = Head{i}(k,:) + well_values(k,3) - 101325/(pho*g);
    end
end