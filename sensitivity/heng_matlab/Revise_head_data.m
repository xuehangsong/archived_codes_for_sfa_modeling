% openfolder = ('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/Test_case_Input/Input_deck/pflotran.in');
% fid = fopen(openfolder,'r');
% i = 1;
% tline = fgetl(fid);
% A{i} = tline;
% while ischar(tline)&& i<=860
%     i = i+1;
%     tline = fgetl(fid);
%     A{i} = tline;
% end
% fclose(fid);
% for i = 233:4:857
%     for j = 1:welln
%         if max(size(strfind(A{i},wellname{j})))>0
%             well_values(j,1:3) = str2num(A{i+1}(15:end));
%         end
%     end
% end
% for i = 1:100
%     for k = 1:157
%             Head_1{i}(k,:) = Head{i,j}(k,:) + well_values(k,3) - 101325/(1000*9.8);
%     end
% end
% for i = 1:inputn
%     for j = 1:realn
%         for i1 = 1:max(size(wellnamegroup))
%                 Head_well{i,j}(i1,:) = Head_1{i,j}(indexset{i1}(1),:);
%         end
%     end
% end

%Head_1 = Head_1 - 101325/(1000*9.8);
subplot(2,2,1);
plot(Time{1}(1,:),Head_1{1}(2,:));
xlabel('Time (h)');
ylabel('Hydraulic head (m)');
title(wellname{2});
subplot(2,2,2);
plot(Time{1}(1,:),Head_1{1}(11,:));
xlabel('Time (h)');
ylabel('Hydraulic head (m)');
title(wellname{11});
subplot(2,2,3);
plot(Time{1}(1,:),Head_1{1}(42,:));
xlabel('Time (h)');
ylabel('Hydraulic head (m)');
title(wellname{42});
subplot(2,2,4);
plot(Time{1}(1,:),Head_1{1}(157,:));
xlabel('Time (h)');
ylabel('Hydraulic head (m)');
title(wellname{157});
            
            