simn = 100;
welln = max(size(wellname));
timen = 192;
for k = 1:simn
    for j = 1:timen
        for i = 1:welln
            if Qx{k}(i,j)>0 && Qy{k}(i,j)>0
                x(i,(k-1)*timen+j) = atan(Qx{k}(i,j)/Qy{k}(i,j))*(180/pi);
            elseif Qx{k}(i,j)>0 && Qy{k}(i,j)<0
                x(i,(k-1)*timen+j) = 360 + atan(Qx{k}(i,j)/Qy{k}(i,j))*(180/pi);
            elseif Qx{k}(i,j)<0 && Qy{k}(i,j)>0
                x(i,(k-1)*timen+j) = 180 + atan(Qx{k}(i,j)/Qy{k}(i,j))*(180/pi);
            else
                x(i,(k-1)*timen+j) = 180 + atan(Qx{k}(i,j)/Qy{k}(i,j))*(180/pi);
            end
            velocity((k-1)*timen+j,i) = sqrt(Qy{k}(i,j).^2 + Qx{k}(i,j).^2);
            if x(i,(k-1)*timen+j)<=55
                degree((k-1)*timen+j,i) = 55-x(i,(k-1)*timen+j);
            elseif x(i,(k-1)*timen+j)> 55 && x(i,(k-1)*timen+j) < 325
                degree((k-1)*timen+j,i) = 415-x(i,(k-1)*timen+j);
            elseif x(i,(k-1)*timen+j) > 325
                degree((k-1)*timen+j,i) = 415-x(i,(k-1)*timen+j);
            end
        end
    end
end