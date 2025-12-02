function [wn, zeta] = ShortTerm(aircraft_state, aircraft_parameters, x, deflections) 

% deflections; 

delta_t = deflections(4);

rho = stdatmo(-aircraft_state(3));
theta0 = aircraft_state(5);

uE    = aircraft_state(7);
m     = aircraft_parameters.m;      % mass
Iy    = aircraft_parameters.Iy;      % I_y
u0    = uE;      % trim speed
g     = aircraft_parameters.g;     % gravity

CD0 = aircraft_parameters.CD0;
CLa = aircraft_parameters.CLalpha;

S = aircraft_parameters.S;
b = aircraft_parameters.b;% wing area


Sprop = aircraft_parameters.Sprop;
Cprop = aircraft_parameters.Cprop;

delta_t0 = delta_t; % need
km = aircraft_parameters.kmotor;

CTu = 2 * (Sprop/S) * Cprop * (km/u0) * delta_t0 * ( 2*delta_t0 - 1 - (2*delta_t0*km)/u0 );


CL = aircraft_parameters.CL0;
Cza = CD0 - CLa;
Cw0 = CL; % need
Cxu = CTu; % need CTu =
Czu = 0; % M0, M = V/a, 0 except in transonic
Cma = aircraft_parameters.Cmalpha;
cbar = S / b; % mean aerodynamic chord, assuming b is the wingspan
Cmq = aircraft_parameters.Cmq;
Cmad = aircraft_parameters.Cmalphadot;


Zw    = 0.5 * rho * u0 * S * Cza;
Xu    = rho * u0 * S * Cw0 * sin(theta0) + 0.5 * rho * u0 * S * Cxu;

Zu    = -rho * u0 * S * Cw0 * cos(theta0) + 0.5 * rho * u0 * S * Czu;

Mw    = 0.5 * rho * u0 * S * Cma * cbar;
Mq    = 0.25 * rho * u0 * S * Cmq * (cbar^2);
Mwdot = 0.25 * rho * S * Cmad * (cbar^2);

A_sp = [  Zw/m,                          u0;
         (1/Iy)*(Mw + Mwdot*Zw/m),  (1/Iy)*(Mq + Mwdot*u0) ];

A_ph = [  Xu/m,         -g;
         -Zu/(m*u0),     0 ];




[eigVecShortyP, eigValShortyP] = eig(A_sp);
[eigVecPhuP, eigValPhuP] = eig(A_ph);

disp('Eigenvalues of Short Period Mode:');
disp(diag(eigValShortyP));
eigValShortyP = diag(eigValShortyP);

sigmaSP = real(eigValShortyP);
dSP = imag(eigValShortyP); 

Wn_SP = sqrt(sigmaSP.^2 + dSP.^2);
dampSP = - sigmaSP ./ Wn_SP;


disp('Eigenvalues of Phugoid Mode:');
disp(diag(eigValPhuP));
eigValPhuP = diag(eigValPhuP);


sigmaPH = real(eigValPhuP);
dPH = imag(eigValPhuP);

Wn_PH = sqrt(sigmaPH.^2 + dPH.^2);
dampPH = - sigmaPH ./ Wn_PH;



wn = [Wn_SP, Wn_PH];
zeta = [dampSP, dampPH];

disp('Natural Frequencies (wn):');
disp("Short period");
disp(Wn_SP);
disp("Phugoid");
disp(Wn_PH);

disp('Damping Ratios (zeta):');
disp("Short period");
disp(dampSP);
disp("Phugoid");
disp(dampPH);

end 
