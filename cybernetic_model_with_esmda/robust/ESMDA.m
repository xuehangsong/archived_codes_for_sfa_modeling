clear

obs.data = csvread('data.csv',2);
obs.time = obs.data(:,1);
obs.value = obs.data(:,[2 4 6 8]);
obs.sd = obs.data(:,[3 5 7 9]);
[ntime,nobs] = size(obs.value);

obs.value = reshape(obs.value,1,numel(obs.value));
obs.sd = reshape(obs.sd,1,numel(obs.sd));

nreaz = 1000;
nparm = 5;
T_ensemble = zeros(ntime+1,7,nreaz,ntime);
state.ensemble = zeros(nparm,nreaz);
niter = 10;

%initial parameters
pd = makedist('Normal','mu',0.25,'sigma',0.3);
t1 = truncate(pd,0,63.5/127.67);
randn('seed',12);
state.ensemble(1,:) = random(t1,nreaz,1);

randn('seed',23)
state.ensemble(2,:) = normrnd(3,1,[1 nreaz]);

randn('seed',35)
state.ensemble(3,:) = normrnd(-1,1,[1 nreaz]);

randn('seed',58)
state.ensemble(4,:) = normrnd(-1,1,[1 nreaz]);

pd = makedist('Normal','mu',0.25,'sigma',0.3);
t5 = truncate(pd,0,1);
randn('seed',813);
state.ensemble(5,:) = random(t5,nreaz,1);


%ntime = 1;
% nreaz =1;
% state.ensemble(:,1) = [0.497;log(25.04);log(12.82);log(0.532);0.126];
% state.ensemble(:,2) = [0.497;log(25.04);log(12.82);log(0.532);0.126];
% state.ensemble(:,2) = [0.4;log(20);log(12);log(0.5);0.1];
% nreaz=1;
%fileID = fopen('mean.txt','w');
iter=0;
dlmwrite('mean.txt',mean(state.ensemble,2)')
dlmwrite('var.txt',var(state.ensemble,0,2)');
dlmwrite(strcat('state.',int2str(iter),'.txt'),state.ensemble);
for iter=1:niter
 %   itime = 25;
    disp(iter)
    simu.ensemble = zeros(nobs*ntime,nreaz);
    for ireaz=1:nreaz
       
        
        para.f(1) = state.ensemble(1,ireaz);       %f1, 0.497
        para.f(2) = min(para.f(1)*127.67/63.5,1);       %f2, 0.999
        para.f(3) = min(para.f(1)*480/63.5,1);          %f3, 0.066
        
        para.kr(1) = exp(state.ensemble(2,ireaz));      %k1, 2.504e+01
        para.kr(2) = exp(state.ensemble(3,ireaz));      %k2, 1.782e+01
        para.kr(3) = 0;                           %k3
        
        para.kdeg = exp(state.ensemble(4,ireaz));       % cell death rate constant,5.32e-01
        para.fact = state.ensemble(5,ireaz);       % fraction of active biomass,0.126
        
        para.Kd = [
            0.25 % Kd1
            0.25 % Kd2
            0.25 % Kd3
            ];
        para.Ka = [
            0.001 % Ka1
            0.004 % Ka2
            0.001 % Ka3
            ];
        
        y0 = [
            61.13 % ch2o(OC)
            18.25 % no3
            0.00 % no2
            0 % n2
            1 % co2
            1 % c5h7o2n(BIOM)
            1 % o2
            ];
        
        options4ode = odeset('NonNegative',1:7);
%         tspan = [0 1e-8 obs.time([1:itime],1)'];
%         [T,Y] = ode15s(@miniCyberV1,tspan,y0,options4ode,para); 
%         simu.ensemble(:,ireaz)= Y(itime+1,[1 2 3 5]);
%         T_ensemble(1:itime+2,:,itime) = Y;
        
        tspan = [0 obs.time'];
        [T,Y] = ode15s(@miniCyberV1,tspan,y0,options4ode,para); 
        temp = Y(2:ntime+1,[1 2 3 5]);
        simu.ensemble(:,ireaz)= reshape(temp,1,numel(temp));
        clearvars temp
        T_ensemble(1:ntime+1,:,ireaz,iter) = Y;
        
        
    end
    %plot(T,Y)
    
    
    avai_data = find(isnan(obs.value)==0);   
    simu.ensemble = simu.ensemble(avai_data,:);
    var_obs = diag(obs.sd(avai_data).^2);
    
    for idata=1:length(avai_data)
        obs_perb(idata,:) = obs.value(avai_data(idata))'*ones(1,nreaz)+ ...
            normrnd(0,obs.sd(avai_data(idata))*niter^0.5,[1,nreaz]);
    end
    obs_perb = max(obs_perb,zeros(length(avai_data),nreaz));
    
    d_state_ensemble = state.ensemble-mean(state.ensemble,2)*ones(1,nreaz);
    d_simu_ensemble = simu.ensemble-mean(simu.ensemble,2)*ones(1,nreaz);
    cov_sd = d_state_ensemble*(d_simu_ensemble)'/(nreaz-1);
    cov_dd = d_simu_ensemble*(d_simu_ensemble)'/(nreaz-1);

    kalman = cov_sd*pinv(cov_dd+var_obs*niter);
    state.ensemble = state.ensemble + kalman*(obs_perb-simu.ensemble);
    
   % fprintf(fileID,'%f',state.ensemble);
%     
%     state.ensemble(1,:)=max(state.ensemble(1,:),eps*ones(1,nreaz));
%     state.ensemble(5,:)=max(state.ensemble(5,:),eps*ones(1,nreaz));
%     state.ensemble(1,:)=min(state.ensemble(1,:),63.5/127.67*(1-eps)*ones(1,nreaz));
%     state.ensemble(5,:)=min(state.ensemble(5,:),(1-eps)*ones(1,nreaz));    
%     
    randn('seed',iter+1000);
    bad1 = find(state.ensemble(1,:)<=0 | state.ensemble(1,:)>=63.5/127.67);
    state.ensemble(1,bad1) = random(t1,length(bad1),1);
    
    randn('seed',iter+2000);
    bad5 = find(state.ensemble(5,:)<=0 | state.ensemble(5,:)>=1);
    state.ensemble(5,bad5) = random(t5,length(bad5),1);
    
    dlmwrite('mean.txt',mean(state.ensemble,2)','-append');
    dlmwrite('var.txt',var(state.ensemble,0,2)','-append');
    dlmwrite(strcat('state.',int2str(iter),'.txt'),state.ensemble);
    for ireaz=1:nreaz
        dlmwrite(strcat('simu.','T',int2str(iter),'R',int2str(ireaz),'.txt'),...
            T_ensemble(1:ntime+1,:,ireaz,iter));
    end
    clearvars avai_data var_obs obs_perb d_state_ensemble 
    clearvars d_simu_ensemble cov_sd cov_dd kalman
 
end
% figure()

%fclose(fileID);



