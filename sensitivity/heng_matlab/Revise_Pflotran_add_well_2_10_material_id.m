openfolder = 'C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/Test_case_Input/Input_deck/pflotran.in';
fid = fopen(openfolder,'r');
i = 1;
tline = fgetl(fid);
A{i} = tline;
%B{i} = tline;
while ischar(tline)
    i = i+1;
    tline = fgetl(fid);
    A{i} = tline;
  %  B{i} = tline;
end
fclose(fid);
C = cell(1960,1);
for i = 1:283
    C{i} = A{i};
end
C{285} = 'REGION Well_2-10_1';
C{286} = '  COORDINATE  60.21  94.47 102.750';
C{287} = '/';
C{289} = 'REGION Well_2-10_2';
C{290} = '  COORDINATE  60.21  94.47 103.250';
C{291} = '/';
C{293} = 'REGION Well_2-10_3';
C{294} = '  COORDINATE  60.21  94.47 103.750';
C{295} = '/';
C{297} = 'REGION Well_2-10_4';
C{298} = '  COORDINATE  60.21  94.47 104.250';
C{299} = '/';
C{301} = 'REGION Well_2-10_5';
C{302} = '  COORDINATE  60.21  94.47 104.750';
C{303} = '/';
for i = 0:909
    C{305+i} = A{285+i};
end
%C{1143} = '  MATERIAL ../plot120x120x15_ngrid120x120x30_material.h5';

for i = 1:17
    C{1215+(i-1)*5}= 'OBSERVATION';
    C{1216+(i-1)*5}= sprintf('  REGION Well_2-10_%d',i);
    C{1217+(i-1)*5}= '  VELOCITY';
    C{1218+(i-1)*5} = '/';
end
for i = 0:720
    C{1240+i} = A{1195+i};
end
for j = 1:100
    C{1143} = sprintf('  MATERIAL ../Material%d.h5',j);
    fid = fopen(sprintf('C:/Users/daih524/Desktop/2015_Spring/Data_for_Test_Case/BC_Data_From_Chen/4heng/Input_deck_Add_Well_2_10_M_ID/pflotran%d.in',j), 'w');
    for i = 1:numel(C)
        if C{i+1} == -1
            fprintf(fid,'%s', C{i});
            break
        else
            fprintf(fid,'%s\n', C{i});
        end
    end
    fclose(fid);
end
