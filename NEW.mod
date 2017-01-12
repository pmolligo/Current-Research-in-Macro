var 
piV xV rrstarV iV rV;

varexo  
e;

parameters 
beta phi theta rho my mr mbar mf_pi mf_x gamma;

beta  =0.99;    //Discount factor (=inverse nominal interest rate)
phi   =1;       //Inverse labor supply elasticity
theta =0.7;     //Calvo parameter price stickiness
rho   =0.5;     //AR(1) natural rate
my    =1;       //myopia about income innovations
mr    =0.2;     //myopia about int. rate innovations
mbar  =0.85;       //general inattention parameter 
mf_pi =1;       //firm myopia to inflation
mf_x  =0.2;     //firm myopia to output
gamma =1;       //relative risk aversion parameter

model;

#M=mbar/(1/beta-my*(1/beta-1));
#sigma=mr/(gamma*(1/beta)*(1/beta-(1/beta-1)*my));
xV=M*xV(+1)-sigma*(iV-piV(+1)-rrstarV);

#Mf=mbar*(theta+mf_pi*(1-theta)); 
#kap=(1/theta-1)*(1-beta*theta)*(gamma+phi)*mf_x;
piV=Mf*beta*piV(+1)+kap*xV;

iV-piV(+1)=rrstarV-e(-39); 

rV=iV-piV(+1);

rrstarV=rho*rrstarV(-1);

end;

initval;
piV=0;
xV=0;
rrstarV=0;
iV=0;
rV=0;
end;

steady;

check;

shocks;

var e;stderr 0.01;
end;

stoch_simul(irf=100);
