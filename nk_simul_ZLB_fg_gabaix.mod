//Log-Linearized CGG Model
//All variables expressed in percent deviations from steady state

//stochastic simulation of negative shock to natural real rate

//Mathias Trabandt (mathias.trabandt@gmail.com)


//Endogenous variables
var 
piV xV RV rrstarV;

//Exogenous variables
varexo  
eps epsR;

//Parameters
parameters 
beta phi xip rpi rx rho sig my mr mbar mf gamma;


//Inialization of parameter values
beta  =0.99;  //Discount factor (=inverse nominal interest rate)
phi   =0.2;   //Inverse labor supply elasticity
xip   =0.75;  //Calvo parameter price stickiness
rpi   =1.5;   //Taylor rule: feedback on expected inflation
rx    =0.2;   //Taylor rule: feedback on output gap
rho   =0.9;   //AR(1) natural rate
sig   =.005*2; //Std natural rate
my    =0.7; //1     //myopia about income innovations
mr    =0.7; //1    //myopia about int. rate innovations
mbar  =0.7; //1  //general inattention parameter 
mf    =0.7; //1  //firm myopia
gamma =1; //relative risk aversion parameter


//model equations
model;

//Phillips curve
#mkap=(1/xip-1)*(1-beta*xip)*(gamma+phi)*mf; // new definition of kappa with firm myopia
#Mf=mbar*(xip+(1-xip)*((1-beta*xip)/(1-beta*xip*mbar))*mf); // use xip instead of theta (gabaix)
piV=Mf*beta*piV(+1)+mkap*xV; // behavioral phillips curve

//#kap=(1-beta*xip)*(1-xip)/xip*(1+phi); //old definition of kappa
//piV=beta*piV(+1)+kap*xV;  // old phillips curve   
                                 
                                 
//IS equation
#M=mbar/(1/beta-my*(1/beta-1)); //define M 
#sigma=mr/((1/beta)*(1/beta-(1/beta-1)*my)); //define sigma
xV=M*xV(+1)-sigma*(RV-piV(+1)-rrstarV); // behavioral IS

//xV=xV(+1)-(RV-piV(+1)-rrstarV); // old IS


//Taylor rule with ZLB implementation
RV=max(log(beta), rpi*piV+rx*xV+epsR); //keep shock in the max operator

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
//var eps;
//periods 1:1;
//values 0.01; 

var epsR;
periods 1      2     3    4     5      6      7     8     9     10;   //  11   12  13  14  15  16   17  18  19  20;
values -1       -1   -1   -1   -1      -1      -1     -1    -1    -1; //    -1   -1  -1  -1  -1  -1   -1  -1  -1  -1;
end;


//simulation
simul(periods=200); 


//plot solution
figure;
for j=1:1:4
    subplot(2,2,j)
    plot(oo_.endo_simul(j,1:40));
    title(M_.endo_names(j,:));
end


//calculate announced policy shocks
annshocks=RV-rpi*piV-rx*xV //diff. between RV and Taylor rule expression



