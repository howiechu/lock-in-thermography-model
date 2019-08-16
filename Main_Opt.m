clc
clearvars -except xbest
close all
format short g

global xbest Fobjbest ii
Fobjbest = 1e5;
iter = 0;
%    Cpel (1)      keff(3)        h1(4)       khat(5)     keref(6)      alfa_ke(7)      i0ref(8)      Ei0(9)
x0 = [2.323       54.4046       12.5019     0.3628       30.1876        3.7984          13.6344        30.8059];
lb = [1.000       2.00000       1.00000     0.0200       1.00000        1.0000          0.01000        1.00000];
ub = [10.00       200.000       40.0000     0.4000       60.0000        20.000          30.0000        50.0000];

options  = optimset('display','iter','MaxFunEvals',1000,'TolX',1e-4,'FinDiffRelStep',1e-2);
[x fval] = lsqnonlin(@ObjFunc,x0,lb,ub,options)