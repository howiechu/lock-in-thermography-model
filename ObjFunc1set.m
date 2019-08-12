function ResT = ObjFunc1set(x)

global xbest Fobjbest ii

tf          = 2500;
Cpel        = x(1)*1e6;
Cpcc        = x(1)*1e6;
keff        = x(2);
h1          = x(3);
khat        = x(4);
keref       = x(5);
alfa_ke     = x(6);
i0ref       = x(7);
Ei0         = x(8);
DS          = -0.07; 
Vinit       = 3.219; % 3.219 for 4c, 3.243 for 2c, 3.239 for 4c50

%% Ambient Temperatures for Different Experiments
Tinf     = 23.8495; %4c100s
% Tinf     = 23.703; %2c100s
% Tinf     = 23.580; %4c50s
%% Run COMSOL Model

tic
A123_091018(Tinf,Cpel,Cpcc,keff,h1,khat,keref,alfa_ke,i0ref,Ei0,DS,Vinit)
toc

%% Load EXPERIMENTAL Data
load SRun4c.mat

RunM(tf+1:end,:) = [];

tData            = RunM(:,1);
Tavg_data        = RunM(:,3);
Tmax_data        = RunM(:,2);
Tmin_data        = RunM(:,4);
Vcell_data       = RunM(:,5);

%% Load SIMULATION Results
Run1 = load('Run_4c_100s.txt');
close all

Run1(1,:) = [];
Run1(:,1) = Run1(:,1)-1; 

filename = sprintf("SimAnimate_%02.f"+".mat",ii);
save(filename,'Run1')
ii=ii+1;

tModel      = Run1(:,1);
Tavg_mod    = Run1(:,3);
Tmax_mod    = Run1(:,2);
Tmin_mod    = Run1(:,4);
VcellModel  = Run1(:,5);

%% Calculate RESIDUALS

h90 = (mean(Tavg_data(2201:2500))-Tavg_data(1))*0.9+Tavg_data(1)-0.36;
hidx = find(Tavg_data<h90);

for i = 9:50
    Env(i) = Run1(i*50-1,5)-RunM(i*50-1,5);
end

Env = Env';

Res         = [(Run1(:,3)-Tavg_data)./Tmax_data ...
                ((Run1(:,2)-Run1(:,4))-(Tmax_data-Tmin_data))./Tmax_data ...
                    (VcellModel-Vcell_data)];

Res1        = (Tavg_mod(2201:2500)-Tavg_data(2201:2500))./Tavg_mod(2201:2500);
% Res2        = ((Tmax_mod(2201:2500)-Tavg_mod(2201:2500))-(Tmax_data(2201:2500)-Tavg_data(2201:2500)))./(Tmax_mod(2201:2500)-Tavg_mod(2201:2500));
Res2        = (Tmax_mod(2201:2500)-Tmax_data(2201:2500))./Tmax_mod(2201:2500);
% Res3        = ((Tavg_mod(2201:2500)-Tmin_mod(2201:2500))-(Tavg_data(2201:2500)-Tmin_data(2201:2500)))./(Tavg_mod(2201:2500)-Tmin_mod(2201:2500));
Res3        = (Tmin_mod(2201:2500)-Tmin_data(2201:2500))./Tmin_mod(2201:2500);
Res4        = (Tavg_mod(1:hidx(end))-Tavg_data(1:hidx(end)))./Tavg_mod(1:hidx(end));
Res5        = (VcellModel-Vcell_data)./VcellModel;
Res         = vertcat(Res1,Res2,Res3,Res4,Res5);
   
ResT        = Res(:);
Fobj        = sum(ResT.^2);
Fobj        = Fobj + sum(Env.^2);

if Fobj<Fobjbest
    xbest    = x;
    Fobjbest = Fobj;
    save('last_res','xbest','Fobjbest')
end

%% PLOT EXP and SIM Results
figure('Position', [10, 1000, 600, 600])
plot(tData,Tavg_data,'-b',tData,Tmax_data,'-b',tData,Tmin_data,'-b',...
    tModel,Run1(:,2:end-2),'-g','linewidth',2)
ylabel('Temp(C)','fontsize',16)
% axis([0 tf 25 45])
xlim([0 tf])
title(['x =' num2str(x)],'fontsize',16)
figure('Position', [10, 0, 600, 600])
plot(tModel,VcellModel,'-g',tData,Vcell_data,'-b','linewidth',2)
xlabel('Time(sec)','fontsize',16)
ylabel('Voltage(V)','fontsize',16)
% xlim([2000 tf])
xlim([0 tf])
title(['Res = ' num2str(Fobj)],'fontsize',16)
x
Fobj
pause(0.1)