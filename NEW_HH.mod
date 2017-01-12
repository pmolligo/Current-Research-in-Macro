var 
piV xV rrstarV iV;

varexo  
e;

parameters 
beta phi phi_pi theta rho my mr mbar mf_pi mf_x gamma;

beta  =0.99;    
phi   =1;       
theta =0.7;     
rho   =0.5;     
my    =1;       
mr    =0.2;     
mbar  =1;       
mf_pi =1;
phi_pi=1.000001;     
mf_x  =0.2;     
gamma =1;       

model;

//#M=mbar/(1/beta-my*(1/beta-1));
#sigma=mr/(gamma*(1/beta)*(1/beta-(1/beta-1)*my));

xV=0.85*xV(+1)-sigma*(iV-piV(+1)-rrstarV);

#Mf=mbar*(theta+mf_pi*(1-theta)); 
#kap=(1/theta-1)*(1-beta*theta)*(gamma+phi)*mf_x;

piV=Mf*beta*piV(+1)+kap*xV;

iV=rrstarV+phi_pi*piV-e(-39); 

//rV=iV-piV(+1); 

rrstarV=rho*rrstarV(-1);

end;

initval;
piV=0;
xV=0;
rrstarV=0;
iV=0;
end;

steady;

check;

shocks;

var e;stderr 0.01;
end;

stoch_simul(irf=100);
