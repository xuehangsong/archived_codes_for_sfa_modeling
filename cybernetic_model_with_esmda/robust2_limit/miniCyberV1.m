function dydt=miniCyberV1(t,y,para)

% y(1) = ch2o(OC)
% y(2) = no3
% y(3) = no2
% y(4) = n2
% y(5) = co2
% y(6) = c5h7o2n(BIOM)
% y(7) = o2

% index for OC and BIOM
iOC = 1; iBiom = 6; 

% parameter substitution
f = para.f; kr = para.kr; Kd = para.Kd; Ka = para.Ka; 
kdeg = para.kdeg; fact = para.fact;

% variable substitution
c=y(iBiom)*fact; % biomass


% stochiometry coefficients matrix
S = [...
    -0.250	-0.500	0.500	0.000	0.250	0.000 0
    -0.250	0.000	-0.333	0.167	0.250	0.000 0
    -0.250	0.000	0       0       0.250	0.000 -0.25
    -0.250	0.000	0.000	0.000	0.000	0.050 0
    ];
% combine respiration and biomass synthesis 
S(1,:) = f(1)*S(1,:)+(1-f(1))*S(4,:); % combinine the 1st and 3rd rows
S(2,:) = f(2)*S(2,:)+(1-f(2))*S(4,:); % combine the 2nd and 3rd rows
S(3,:) = f(3)*S(3,:)+(1-f(3))*S(4,:); % combine the 2nd and 3rd rows
S(4,:) = []; % delete the 3rd row
S = S'; % transpose
[ny,nr] = size(S); % ny = number of metabolites, nr = number of reactions 

% normalize stoichiometric coefficeints
for j=1:nr
    S(:,j) = S(:,j)/abs(S(1,j));
end

for i=1:ny
    if y(i)<0,y(i)=eps;end % if negative, force them to be zero
end

% kinetics for unregulated reaction rates 
rkin = zeros(nr,1); % initialization
rkin(1) = kr(1)*y(1)/(Kd(1)+y(1))*y(2)/(Ka(1)+y(2));
rkin(2) = kr(2)*y(1)/(Kd(2)+y(1))*y(3)/(Ka(2)+y(3));
rkin(3) = kr(3)*y(1)/(Kd(3)+y(1))*y(7)/(Ka(3)+y(7));

%added by xuehang song
rkin=rkin-kdeg*ones(length(rkin),1);

% calculate the cybernetic variables u1 and u2
roi=rkin; roi=max(roi,zeros(length(roi),1));
pu=max(roi,zeros(length(roi),1)); sumpu=sum(pu); 
if sumpu>0, u=pu/sumpu; else u=zeros(length(roi),1); end

% regulated reaction rates
ru=u.*rkin;

% mass balances 
dydt=S*ru*c;

% modification of BIOM and OC balances 
dydt(iBiom)=dydt(iBiom)/fact; % biomass degradation
dydt(iOC)=dydt(iOC); % increase of OC 