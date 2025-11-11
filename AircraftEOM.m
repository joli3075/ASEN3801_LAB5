function xdot = AircraftEOM(time, aircraft_state, aircraft_surfaces, wind_inertial, aircraft_parameters)
pos = aircraft_state(1:3);
angle = aircraft_state(4:6);
vel = aircraft_state(7:9);
aVel = aircraft_state(10:12);

%% Rotation Matrices and Angle Defs
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

%% EOM's and final statevector
% Kinematics
% Rate of change of inertial position
pos_dot = euler321 * vel;   % matrix of position derivatives

% Rate of change of euler angles
angle_dot = angle_matrix*aVel;  % matrix of angle derivatives

% Dynamics

%Inertial Velocity derivatives - body frame
vel_dot(1,1) = (aVel(3)*vel(2) - aVel(2)*vel(3)) + (g*-s_2) + (1/m) *a_f(1);
vel_dot(2,1) = (aVel(1)*vel(3) - aVel(3)*vel(1)) + (g*c_2*s_1) + (1/m)*a_f(2);
vel_dot(3,1) = (aVel(2)*vel(1) - aVel(1)*vel(2)) + (g*c_2*c_1) + (1/m)*a_f(3);

%Angular acceleration rates of each euler angle
omega_dot(1,1)= 
omega_dot(2,1)= 
omega_dot(3,1)= 

% Assemble the state derivative vector
var_dot = [pos_dot; angle_dot; vel_dot; omega_dot];

 end



end