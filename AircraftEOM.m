function xdot = AircraftEOM(time, aircraft_state, aircraft_surfaces, wind_inertial, aircraft_parameters)
%% Variables <>
%-StateVariables----------
pos = aircraft_state(1:3);
angle = aircraft_state(4:6);
vel = aircraft_state(7:9);
aVel = aircraft_state(10:12);

density = stdatmo(abs(pos(3)));
[aero_forces, aero_moments] = AeroForcesAndMoments(aircraft_state,aircraft_surfaces, wind_inertial, density, aircraft_parameters);

[X,Y,Z] = transpose(aero_forces);
[L,M,N] = transpose(aero_moments);

% -Inertias-----------------
Ix = aircraft_parameters.Ix;
Iy = aircraft_parameters.Iy;
Iz = aircraft_parameters.Iz;
Ixz = aircraft_parameters.Ixz;


gamma = Ix*Iz - Ixz^2;
gamma_1 =Ixz*(Ix - Iy + Iz)/ gamma;
gamma_2 =(Iz*(Iz - Iy)+Ixz^2) / gamma;
gamma_3 =Iz /gamma;
gamma_4 =Ixz/gamma;
gamma_5 =(Iz - Ix) / Iy;
gamma_6 =Ixz/Iy;
gamma_7 = (Ix*(Ix - Iy) + Ixz^2)/gamma;
gamma_8 = Ix/gamma;

%% Rotation Matrices and Angle Defs <>
% 3-2-1 rotation matrix
c_3 = cos(angle(3));  s_3 = sin(angle(3));
c_2 = cos(angle(2));  s_2 = sin(angle(2));
c_1 = cos(angle(1));  s_1 = sin(angle(1));
tan_2 = tan(angle(2));  sec_2 = sec(angle(2));
euler321 = [
   c_2*c_3,      s_2*s_1*c_3 - c_2*s_3,      c_1*s_2*c_3 + s_1*s_3;
    c_2*s_3,      s_2*s_1*s_3 + c_2*c_3,      c_1*s_2*s_3 - s_1*c_3;
    -s_2,                     s_1*c_2,                    c_1*c_2
    ];

% kinematics angle rotation matrix
angle_matrix = [
    1,         s_1*tan_2,     c_1*tan_2;
    0,            c_1,                  -s_1;
    0,         s_1*sec_2,        c_1*sec_2
];

%% EOM's and final statevector <>
% Kinematics
% Rate of change of inertial position
posDot = euler321 * vel;   % matrix of position derivatives  [Xdot; Ydot; Zdot]

% Rate of change of euler angles
angleDot = angle_matrix*aVel;  % matrix of angle derivatives      [phiDot; ThetaDot; psiDot]

% Dynamics
%Inertial Velocity derivatives - body frame
velDot(1,1) = (aVel(3)*vel(2) - aVel(2)*vel(3)) + (g*-s_2) + (1/m) *X;       %Ue
velDot(2,1) = (aVel(1)*vel(3) - aVel(3)*vel(1)) + (g*c_2*s_1) + (1/m)*Y;  %Ve
velDot(3,1) = (aVel(2)*vel(1) - aVel(1)*vel(2)) + (g*c_2*c_1) + (1/m)*Z;  %We

%Angular acceleration rates of each euler angle
omegaDot(1,1)= gamma_1*aVel(1)*aVel(2) - gamma_2 * aVel(2) *aVel(3) + gamma_3 * L + gamma_4 * N;  %p
omegaDot(2,1)= gamma_5*aVel(1)*aVel(3) - gamma_6 * (aVel(1)^2-aVel(3)^2) + (1/Iy)* M;      %q
omegaDot(3,1)= gamma_7*aVel(1)*aVel(2) - gamma_1 *  aVel(2) *aVel(3) + gamma_4 * L + gamma_8 * N;  %r

% Assemble the state derivative vector
xdot = [posDot; angleDot; velDot; omegaDot];

 end
