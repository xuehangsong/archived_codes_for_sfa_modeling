function [Time,Head_1,fluxavc1,fluxavc2,wellname,wellnamegroup] = Read_observation_well_data_uncertainty(openfolder1)
% Read data for uncertainty calculation
randcpu = 160;
inputn = 100;
%realn = 1;
pho = 996.877;
g = 9.81;
%Number of data types for one well.
n = 8;
for i = 1:inputn
    %    for j = 1:realn
    welln = 0;
    clear wellname_temp;
    for k = 1:randcpu
        openfolder = sprintf([openfolder1...
            '/pflotran1R%d-obs-%d.tec'],i,k);
        if exist(openfolder,'file');
            fid = fopen(openfolder,'r');
            tline = fgetl(fid);
            indexnum = find(tline == '"');
            numofwells = ((max(size(indexnum))/2)-1)/n;
            welln = welln + numofwells;
            wellindex = find(tline =='W');
            for jj = 1:numofwells
                wellname_temp{welln-numofwells+jj} = tline(wellindex((jj-1)*8+1):wellindex((jj-1)*8+1)+10);
                if (i == 1)
                    wellname{welln-numofwells+jj} = tline(wellindex((jj-1)*8+1):wellindex((jj-1)*8+1)+10);
                end
            end
            ii = 1;
            while (ischar(tline))
                tline = fgetl(fid);
                if (ischar(tline))
                    dtemp(ii,:) = str2num(tline);
%                   disp(i);
%                    disp(k);
%                    disp(ii);
                end
                ii = ii+1;
            end
            %                Time_temp(1:max(size(dtemp(:,1)))) = dtemp(:,1);
            %                Time{i,j}(1:max(size(Time_temp))) = Time_temp(:);
            for kk = 1:numofwells
                if (i==1)
                    Time{i}(welln-numofwells+kk,:) = dtemp(:,1);
                    Pressure{i}(welln-numofwells+kk,:) = dtemp(:,n*(kk-1)+2);
                    Head{i}(welln-numofwells+kk,:) = dtemp(:,n*(kk-1)+2)./(pho*g);
                    Saturation{i}(welln-numofwells+kk,:) = dtemp(:,n*(kk-1)+3);
                    Tracer1{i}(welln-numofwells+kk,:) = dtemp(:,n*(kk-1)+4);
                    Tracer2{i}(welln-numofwells+kk,:) = dtemp(:,n*(kk-1)+5);
                    Tracer3{i}(welln-numofwells+kk,:) = dtemp(:,n*(kk-1)+6);
                    Qx{i}(welln-numofwells+kk,:) = dtemp(:,n*(kk-1)+7);
                    Qy{i}(welln-numofwells+kk,:) = dtemp(:,n*(kk-1)+8);
                    Qz{i}(welln-numofwells+kk,:) = dtemp(:,n*(kk-1)+9);
                else
                    for kkk = 1:numel(wellname)
                        if(wellname_temp{welln-numofwells+kk}==wellname{kkk})
                            Time{i}(kkk,:) = dtemp(:,1);
                            Pressure{i}(kkk,:) = dtemp(:,n*(kk-1)+2);
                            Head{i}(kkk,:) = dtemp(:,n*(kk-1)+2)./(pho*g);
                            Saturation{i}(kkk,:) = dtemp(:,n*(kk-1)+3);
                            Tracer1{i}(kkk,:) = dtemp(:,n*(kk-1)+4);
                            Tracer2{i}(kkk,:) = dtemp(:,n*(kk-1)+5);
                            Tracer3{i}(kkk,:) = dtemp(:,n*(kk-1)+6);
                            Qx{i}(kkk,:) = dtemp(:,n*(kk-1)+7);
                            Qy{i}(kkk,:) = dtemp(:,n*(kk-1)+8);
                            Qz{i}(kkk,:) = dtemp(:,n*(kk-1)+9);
                        end
                    end
                end
            end
            clear dtemp;
            fclose(fid);
        end
    end
end
clear indexset;
clear indextot;
% Time{68} = Time{67};
% Pressure{68} = Pressure{67};
% Head{68} = Head{67};
% Tracer1{68} = Tracer1{67};
% Tracer2{68} = Tracer2{67};
% Tracer3{68} = Tracer3{67};
% Qx{68} = Qx{67};
% Qy{68} = Qy{67};
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
% for i = 1:max(size(wellname))
%     wellname{i} = strrep(wellname{i},'_','-');
% end
for i = 1:iii
    wellnamegroup{i} = wellname{indexset{i}(1)}(1:9);
end

clear fluxavc1;
clear fluxavc2;
clear fluxavc3;
clear v1;
clear sumv1;
for i = 1:inputn
    for k = 1:iii
        clear v1;
        clear sumv1;
        fluxavc1{i}(k,1:max(size(Time{i}(indexset{k}(1),:)))) = 0;
        fluxavc2{i}(k,1:max(size(Time{i}(indexset{k}(1),:)))) = 0;
        fluxavc3{i}(k,1:max(size(Time{i}(indexset{k}(1),:)))) = 0;
        sumv1(1:max(size(Time{i}(indexset{k}(1),:)))) = 0;
        for l = 1:max(size(indexset{k}))
            v1 = sqrt(Qx{i}(indexset{k}(l),:).^2 + Qy{i}(indexset{k}(l),:).^2);
            sumv1 = sumv1 + v1;
            fluxavc1{i}(k,:) = fluxavc1{i}(k,:) + v1.*Tracer1{i}(indexset{k}(l),:);
            fluxavc2{i}(k,:) = fluxavc2{i}(k,:) + v1.*Tracer2{i}(indexset{k}(l),:);
            fluxavc3{i}(k,:) = fluxavc3{i}(k,:) + v1.*Tracer3{i}(indexset{k}(l),:);
        end
        fluxavc1{i}(k,:) = fluxavc1{i}(k,:)./sumv1;
        fluxavc2{i}(k,:) = fluxavc2{i}(k,:)./sumv1;
        fluxavc3{i}(k,:) = fluxavc3{i}(k,:)./sumv1;
    end
end
openfolder = ('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Input_deck_add_more_wells_around/pflotran1.in');
%openfolder = ('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Multiple simulations results material ID/Input_deck/pflotran1.in');
fid = fopen(openfolder,'r');
i = 1;
tline = fgetl(fid);
A{i} = tline;
while ischar(tline)&& i<=880
    i = i+1;
    tline = fgetl(fid);
    A{i} = tline;
end
fclose(fid);
for i = 233:4:880
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
% for i = 1:inputn
%     for i1 = 1:max(size(wellnamegroup))
%         Head_well{i}(i1,:) = Head_1{i}(indexset{i1}(1),:);
%     end
% end
