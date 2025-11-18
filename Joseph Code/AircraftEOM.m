function x_dot= AircraftEOM(time, aircraft_state, aircraft_surfaces, wind_inertial, aircraft_parameters)
xE    = aircraft_state(1);
yE    = aircraft_state(2);
zE    = aircraft_state(3);
phi   = aircraft_state(4);
theta = aircraft_state(5);
psi   = aircraft_state(6);
uE    = aircraft_state(7);
vE    = aircraft_state(8);
wE    = aircraft_state(9);
p     = aircraft_state(10);
q     = aircraft_state(11);
r     = aircraft_state(12);

angles = [phi, theta, psi];
% Body velocity relative to air
V_inertial = [uE; vE; wE];
wind_body  = TransformFromInertialToBody(wind_inertial,angles);
disp("wind body = ");
disp(wind_body); 
disp("========================");
V_rel_body = V_inertial - wind_body;

u = V_rel_body(1);
v = V_rel_body(2);
w = V_rel_body(3);


h = -zE;  % height above ground [m]
rho = stdatmo(h);

[Fa, Ma] = AeroForcesAndMoments(aircraft_state, aircraft_surfaces, wind_inertial, rho, aircraft_parameters);
m = aircraft_parameters.m;
g = aircraft_parameters.m;

X = Fa(1);
Y = Fa(2);
Z = Fa(3);

L = Ma(1);
M = Ma(2);
N = Ma(3);



Ix  = aircraft_parameters.Ix;
Iy  = aircraft_parameters.Iy;
Iz  = aircraft_parameters.Iz;
Ixz = aircraft_parameters.Ixz;

gamma = Ix * Iz - Ixz^2;

% Compute each Gamma_i
gamma_1 = (Ixz * (Ix - Iy + Iz)) / gamma;
gamma_2 = (Iz * (Iz - Iy) + Ixz^2) / gamma;
gamma_3 = Iz / gamma;
gamma_4 = Ixz / gamma;
gamma_5 = (gamma - Ix) / Iy;
gamma_6 = Ixz / Iy;
gamma_7 = (Ix * (Ix - Iy) + Ixz^2) / gamma;
gamma_8 = Ix / gamma;




   % First term: cross-coupling due to body angular rates
    crossTerm = [ r*vE - q*wE;
                  p*wE - r*uE;
                  q*uE - p*vE ];

    % Gravity term expressed in body coordinates
    gravityTerm = g * [ -sin(theta);
                         cos(theta)*sin(phi);
                         cos(theta)*cos(phi) ];

    % Force term
    forceTerm = (1/m) * [ X; Y; Z ];

    % Total acceleration
    uvw_dot = crossTerm + gravityTerm + forceTerm;

% udot = (r*v - q*w)+ (g * ( - sin(theta)) + (1/m)*X);
% vdot = (p*w - r*u) + (g * (cos(theta) * sin(phi)) + (1/m)*Y);
% wdot = q*u - p*v + (g * (cos(theta) * cos(phi)) + (1/m)*Z);
% 

pdot = (gamma_1 * p * q) - (gamma_2 * q * r) + ((gamma_3 * L) + (gamma_4 * N));
qdot = (((gamma_5 * p * r) - (gamma_6 * (p^2 - r^2))) + ((1/Iy)*M));
rdot = ((gamma_7 * p * q) - (gamma_1 * q * r)) + ((gamma_4 * L) + (gamma_8 * N));


T_BE = [...
    cos(theta)*cos(psi),  sin(phi)*sin(theta)*cos(psi) - cos(phi)*sin(psi),  cos(phi)*sin(theta)*cos(psi) + sin(phi)*sin(psi);
    cos(theta)*sin(psi),  sin(phi)*sin(theta)*sin(psi) + cos(phi)*cos(psi),  cos(phi)*sin(theta)*sin(psi) - sin(phi)*cos(psi);
    -sin(theta),           sin(phi)*cos(theta),                              cos(phi)*cos(theta)];

% Translational kinematics
pos_dot = T_BE * [u; v; w];

%uvw dot
% uvw_dot = [udot; vdot; wdot];

% Euler angle rates
T_pqr = [...
    1,  sin(phi)*tan(theta),  cos(phi)*tan(theta);
    0,  cos(phi),            -sin(phi);
    0,  sin(phi)/cos(theta),  cos(phi)/cos(theta)];

euler_dot = T_pqr * [p; q; r];

pqr_dot = [pdot; qdot; rdot];

x_dot = [pos_dot; euler_dot; uvw_dot; pqr_dot];








end

