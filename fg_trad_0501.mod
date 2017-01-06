//Log-Linearized CGG Model
//All variables expressed in percent deviations from steady state

//Endogenous variables
var 
piV xV rV rrstarV iV;

//Exogenous variables
varexo  
eps epsR;

//Parameters
parameters 
beta phi theta rho my mr mbar mf_pi mf_x gamma;


//parameter values
beta  =0.99;  //Discount factor (=inverse nominal interest rate)
phi   =1;     //Inverse labor supply elasticity
theta =0.7;   //Calvo parameter price stickiness
rho   =0.5;   //AR(1) natural rate
my    =1;     //myopia about income innovations
mr    =1;     //myopia about int. rate innovations
mbar  =1;     //general inattention parameter 
mf_pi =1;     //firm myopia to inflation
mf_x  =1;     //firm myopia to output
gamma =1;     //relative risk aversion parameter


//model equations
model;

//IS curve
#M=mbar/(1/beta-my*(1/beta-1)); //define M 
#sigma=mr/(gamma*(1/beta)*(1/beta-(1/beta-1)*my)); //define Sigma
xV=M*xV(+1)-sigma*(iV-piV(+1)-rrstarV); // Behavioral IS

//Phillips curve
#Mf=mbar*(theta+mf_pi*(1-theta)); // define Mf
#kap=(1/theta-1)*(1-beta*theta)*(gamma+phi)*mf_x; // define Kappa
piV=Mf*beta*piV(+1)+kap*xV; // Behavioral Phillips curve       

//nominal interest rate
iV=rV+piV(+1);

//"Naive" monetary policy rule for REAL interest rate
rV=rrstarV+epsR; 

//Natural real interest rate
rrstarV=rho*rrstarV(-1)-eps;

end;

//steady state values
initval;  
piV=0; 
xV=0; 
rV=0;
rrstarV=0; 
iV=0;
end;

//calc. and check steady state
steady;

//check eigenvalues
check;

//standard deviations of shocks
shocks;
//var eps;
//periods 1:40;
//values 0.01;

var epsR;
periods 40;
values -0.01;   // negative 1% shock to real interest rate in period 40
end;


//simulation
simul(periods=200); 


//plot solution
figure;
for j=1:1:4
    subplot(2,2,j)
    plot(oo_.endo_simul(j,1:70));
    title(M_.endo_names(j,:));
end
