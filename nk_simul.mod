//Log-Linearized CGG Model
//All variables expressed in percent deviations from steady state

//stochastic simulation of negative shock to natural real rate

//Mathias Trabandt (mathias.trabandt@gmail.com)


//Endogenous variables
var 
piV xV RV rrstarV;

//Exogenous variables
varexo  
eps;

//Parameters
parameters 
beta phi xip rpi rx rho sig;


//Inialization of parameter values
beta  =0.99;  //Discount factor (=inverse nominal interest rate)
phi   =0.2;   //Inverse labor supply elasticity
xip   =0.75;  //Calvo parameter price stickiness
rpi   =1.5;   //Taylor rule: feedback on expected inflation
rx    =0.2;   //Taylor rule: feedback on output gap
rho   =0.9;   //AR(1) natural rate
sig   =.005*2;//Std natural rate


//model equations
model;

//Phillips curve
#kap=(1-beta*xip)*(1-xip)/xip*(1+phi);
piV=beta*piV(+1)+kap*xV;     
                                 
//IS equation
xV=xV(+1)-(RV-piV(+1)-rrstarV);

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
var eps;
periods 1:1;
values 0.01; 
end;


// simulation
simul(periods=200); 


//plot solution
figure;
for j=1:1:4
    subplot(2,2,j)
    plot(oo_.endo_simul(j,1:40));
    title(M_.endo_names(j,:));  
end