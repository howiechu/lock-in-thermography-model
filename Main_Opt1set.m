clc
clearvars -except xbest
close all
format short g

% load('Bestfit_160218')
% load('last_res')
global xbest Fobjbest ii
Fobjbest = 1e5;
iter = 0;
ii=0;
%    Cpel (1)      keff(3)        h1(4)       khat(5)     keref(6)      alfa_ke(7)      i0ref(8)      Ei0(9)
x0 = xbest;
% x0 = [1.7512       183.7291       13.0000     0.098       12.392        5.0138          7.0862        30.0321];
lb = [1.0000       2.000000       1.00000     0.020       1.0000        1.0000          0.0100        1.00000];
ub = [10.000       200.0000       40.0000     0.400       60.000        20.000          30.000        50.0000];

options  = optimset('display','iter','MaxFunEvals',1000,'TolX',1e-4,'FinDiffRelStep',1e-2);
[x fval] = lsqnonlin(@ObjFunc1set,x0,lb,ub,options)


% Starting voltage  h1
% 4c100s - 3.19   12.4563
% 2c100s - 3.243  9.5