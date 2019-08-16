function ResT = ObjFunc(x)

global xbest Fobjbest

tf          = 2500;
Cpel        = x(1)*1e6;
Cpcc        = x(1)*1e6;
keff        = x(2);
h1          = x(3);
ku        = x(4);
keref       = x(5);
alfa_ke     = x(6);
i0ref       = x(7);
Ei0         = x(8);
DS          = -0.07; 
Vinit       = 3.219;

%% Ambient Temperatures for Different Experiments
Tinf     = 23.8495;

%% Run COMSOL Model
LIT_A123_v1_0(Tinf,Cpel,Cpcc,keff,h1,ku,keref,alfa_ke,i0ref,Ei0,DS,Vinit)

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

tModel      = Run1(:,1);
Tavg_mod    = Run1(:,3);
Tmax_mod    = Run1(:,2);
Tmin_mod    = Run1(:,4);
VcellModel  = Run1(:,5);

%% Calculate RESIDUALS
Res1        = (Tavg_mod-Tavg_data)./Tavg_mod;
Res2        = (Tmax_mod-Tmax_data)./Tmax_mod;
Res3        = (Tmin_mod-Tmin_data)./Tmin_mod;
Res4        = (VcellModel-Vcell_data)./VcellModel;
Res         = vertcat(Res1,Res2,Res3,Res4);
   
ResT        = Res(:);
Fobj        = sum(ResT.^2);

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
xlim([0 tf])
title(['x =' num2str(x)],'fontsize',16)
figure('Position', [10, 0, 600, 600])
plot(tModel,VcellModel,'-g',tData,Vcell_data,'-b','linewidth',2)
xlabel('Time(sec)','fontsize',16)
ylabel('Voltage(V)','fontsize',16)
xlim([0 tf])
title(['Res = ' num2str(Fobj)],'fontsize',16)
x
Fobj
pause(0.1)