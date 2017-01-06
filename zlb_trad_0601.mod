//Log-Linearized CGG Model
//All variables expressed in percent deviations from steady state

//Endogenous variables
var 
piV xV iV;

//Exogenous variables
varexo  
rrstarV;

//Parameters
parameters 
beta phi theta my mr mbar mf_pi mf_x gamma;


//parameter values
beta  =0.99;    //Discount factor (=inverse nominal interest rate)
phi   =1;       //Inverse labor supply elasticity
theta =0.7;     //Calvo parameter price stickiness
my    =1;       //myopia about income innovations
mr    =0.2;     //myopia about int. rate innovations
mbar  =1;       //general inattention parameter 
mf_pi =1;       //firm myopia to inflation
mf_x  =0.2;     //firm myopia to output
gamma =1;       //relative risk aversion parameter


//model equations
model;

//IS curve
#M=mbar/(1/beta-my*(1/beta-1)); //define M 
#sigma=mr/(gamma*(1/beta)*(1/beta-(1/beta-1)*my)); //define Sigma
xV=M*xV(+1)-sigma*(iV-piV(+1)-rrstarV); // Behavioral IS curve

//Phillips curve
#Mf=mbar*(theta+mf_pi*(1-theta)); // define Mf
#kap=(1/theta-1)*(1-beta*theta)*(gamma+phi)*mf_x; // define Kappa
piV=Mf*beta*piV(+1)+kap*xV; // Behavioral Phillips curve       

//nominal interest rate
iV=max(0, rrstarV);


end;

//steady state values
initval;  
piV=0; 
xV=0; 
//rV=0;
//rrstarV=0; 
iV=0;
end;

//calc. and check steady state
steady;

//check eigenvalues
check;

//standard deviations of shocks
shocks;

var rrstarV;
periods 1:40 41:200;
values -0.015 0.01;
end;

//simulation
simul(periods=200); 


//plot solution
figure;
for j=1:1:4
    subplot(2,2,j)
    plot(oo_.endo_simul(j,1:90));
    title(M_.endo_names(j,:));
end;
