//preliminary model simulation (Gabaix)
//based off of stoch simul code


//Endogenous variables
var 
piV xV RV rrstarV;

//Exogenous variables
varexo  
eps;

//Parameters
parameters 
beta phi xip rpi rx rho sig my mr mbar mf;


//Inialization of parameter values
beta  =0.99;  //Discount factor (=inverse nominal interest rate)
phi   =0.2;   //Inverse labor supply elasticity
xip   =0.75;  //Calvo parameter price stickiness
rpi   =1.5;   //Taylor rule: feedback on expected inflation
rx    =0.2;   //Taylor rule: feedback on output gap
rho   =0.9;   //AR(1) natural rate
sig   =.005;//Std natural rate
my    =1;    //myopia about income innovations
mr    =1;    //myopia about int. rate innovations
mbar  =0.7;  //general inattention parameter 
mf    =0.7;  //firm myopia
//gamma =1; // relative risk aversion parameter

//model equations
model;

//First, without Fiscal Policy (b and d)

//Phillips curve
#kap=(1-beta*xip)*(1-xip)/xip*(1+phi);
//#mkap=(1/xip-1)*(1-beta*xip)*(gamma+phi)*mf;
#Mf=mbar*(xip+(1-xip)*((1-beta*xip)/(1-beta*xip*mbar))*mf); // use xip instead of theta (gabaix)
piV=Mf*beta*piV(+1)+kap*xV;  //insert Mf and new kappa   
                                 
//IS equation
#M=mbar/(1/beta-my*(1/beta-1)); //define M 
#sigma=mr/((1/beta)*(1/beta-(1/beta-1)*my)); //define sigma
xV=M*xV(+1)-sigma*(RV-piV(+1)-rrstarV); //insert M and sigma

//Taylor rule
RV=rpi*piV+rx*xV;
 
//Natural real interest rate
rrstarV=rho*rrstarV(-1)-eps;

end;

//steady state values
initval;  
piV=0; 
xV=0; 
RV=0; 
rrstarV=0; 
end;

//calc. and check steady state
steady;

//check eigenvalues
check;

//standard deviations of shocks
shocks;
var eps=sig^2; 
end;


//stochastic simulation
stoch_simul(order=1,irf=40); 
