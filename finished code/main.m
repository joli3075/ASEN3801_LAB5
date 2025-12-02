clc; clear; clear all; close; close all;
% Main script for aircraft simulation plotting

%% LOAD AIRCRAFT PARAMETERS
% Load aircraft_parameters via ttwistor
run('ttwistor.m');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% 2.1 

% The aircraft initial state and control inputs all set to zero except the inertial velocity component in
% the body 𝑥𝑥-direction is set to the airspeed 𝑉𝑉 = 21 m/s and the height is set to ℎ = 1609.34 m (1 mile =
% Boulder, CO!). The main purpose of this simulation is to verify that your simulation works, since the
% aircraft should stay near the trim flight condition. Why should we not expect this to be a trim
% condition?

time = [0, 100]; % Example time span from 0 to 100 seconds
Aircraft_State0 = [0; 0; -1609.34; 0; 0; 0; 21; 0; 0; 0; 0; 0 ]; %  Example initial state (position and velocity)

% Define wind_inertial as a constant vector representing the wind in the inertial frame
wind_inertial = [0; 0; 0]; % Wind vector [u_wind; v_wind; w_wind]

% Define Aircraft Surface Controls
aircraft_surfaces = [0; 0; 0; 0]; % given as u0 in problem


% Call the ODE solver for the aircraft equations of motion
[t, state_vector1] = ode45(@(t, y) AircraftEOM(time, y, aircraft_surfaces, wind_inertial, aircraft_parameters), time, Aircraft_State0);

% call PlotAircraftSim
fig = [211,212,213,214,215,216];

state_vector1 = state_vector1';
PlotAircraftSim(t, state_vector1, repmat(aircraft_surfaces, 1, numel(t)), fig, '-r');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% 2.2 TRIM 
time = [0, 200]; % Example time span from 0 to 100 seconds
Aircraft_State0 = [ 0; 0; -18000; 0; 0.2780; 0; 20.99; 0; 0.5837; 0; 0; 0];

% Define wind_inertial as a constant vector representing the wind in the inertial frame
wind_inertial = [0; 0; 0]; % Wind vector [u_wind; v_wind; w_wind]

% Define Aircraft Surface Controls
aircraft_surfaces = [0.1079;0;0;0.3182]; % given as u0 in problem


% Call the ODE solver for the aircraft equations of motion
[t, state_vector2] = ode45(@(t, y) AircraftEOM(time, y, aircraft_surfaces, wind_inertial, aircraft_parameters), time, Aircraft_State0);

% call PlotAircraftSim
fig = [221,222,223,224,225,226];

state_vector2 = state_vector2';
PlotAircraftSim(t, state_vector2, repmat(aircraft_surfaces, 1, numel(t)), fig, '-b');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 2.3 DISTURBANCE 
time = [0, 200]; % Example time span from 0 to 100 seconds
Aircraft_State0 = [ 0; 0; -18000; deg2rad(15); deg2rad(-12); deg2rad(270); 19; 3; -2; deg2rad(0.08); deg2rad(-0.2); 0];
aircraft_state_array = Aircraft_State0; 

% Define wind_inertial as a constant vector representing the wind in the inertial frame
wind_inertial = [0; 0; 0]; % Wind vector [u_wind; v_wind; w_wind]

% Define Aircraft Surface Controls
aircraft_surfaces = [deg2rad(5);deg2rad(2);deg2rad(-13);(0.3)]; % given as u0 in problem


% Call the ODE solver for the aircraft equations of motion
[t, state_vector3] = ode45(@(t, y) AircraftEOM(time, y, aircraft_surfaces, wind_inertial, aircraft_parameters), time, Aircraft_State0);

% call PlotAircraftSim
fig = [231,232,233,234,235,236];

state_vector3 = state_vector3';
PlotAircraftSim(t, state_vector3, repmat(aircraft_surfaces, 1, numel(t)), fig, '-b');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% TASK 3

%% short term
time = [0, 3]; % Example time span from 0 to 100 seconds
Aircraft_State0 = [0; 0; -1800; 0; 0.02780; 0; 20.99; 0; 0.5837; 0; 0; 0];
wind_inertial = [0; 0; 0]; % Wind vector [u_wind; v_wind; w_wind]
aircraft_surfaces = [0.1079; 0; 0; 0.3182]; % given as u0 in problem % given as u0 in problem
% given as u0 in problem


doublet_size = deg2rad(15); 

doublet_time = 0.25; 

[t,x] = ode45(@(t,x) AircraftEOMDoublet(time, x, aircraft_surfaces, doublet_size,doublet_time, wind_inertial, aircraft_parameters), time, Aircraft_State0);

% Call PlotAircraftSim for the doublet response
fig = [311, 312, 313, 314, 315, 316];
x = x';
PlotAircraftSim(t, x, repmat(aircraft_surfaces, 1, numel(t)), fig, '-m');
close all
[wn, zeta] = ShortTerm(Aircraft_State0, aircraft_parameters, x, aircraft_surfaces);


%% Long Term
time = [0, 100]; % Example time span from 0 to 100 seconds
Aircraft_State0 = [0; 0; -1800; 0; 0.02780; 0; 20.99; 0; 0.5837; 0; 0; 0];
wind_inertial = [0; 0; 0]; % Wind vector [u_wind; v_wind; w_wind]
aircraft_surfaces = [0.1079; 0; 0; 0.3182]; % given as u0 in problem
% given as u0 in problem


doublet_size = deg2rad(15);

doublet_time = 0.25; 

[t,x] = ode45(@(t,x) AircraftEOMDoublet2(time, x, aircraft_surfaces, doublet_size,doublet_time, wind_inertial, aircraft_parameters), time, Aircraft_State0);

% Call PlotAircraftSim for the doublet response
fig = [321, 322, 323, 324, 325, 326];
x = x';
PlotAircraftSim(t, x, repmat(aircraft_surfaces, 1, numel(t)), fig, '-m');

% Calculate natural frequency and damping ratio for the long-term case
% Extract the relevant state variables for analysis
% {TODO: ALAT LONG PERIOD} 


% lambda^2 - lambda(Xu/m) - (Zu*g)/(m*u0) = 0;
%Aircraft_State0 = [0; 0; -1800; 0; 0.02780; 0; 20.99; 0; 0.5837; 0; 0; 0];

% dominant U vector





% Automatically close all plots after 30 seconds

% SaveFigs; 

close all;




