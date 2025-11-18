%% main to test response:


clc; clear; clear all; close; close all;
% Main script for aircraft simulation plotting

%% LOAD AIRCRAFT PARAMETERS
% Load aircraft_parameters via ttwistor
run('ttwistor.m');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% 2.3 DISTURBANCE 
time = [0, 5]; % Example time span from 0 to 100 seconds
StateTest0 = [ 0, 0 , -18000, deg2rad(15) , deg2rad(-12) , deg2rad(270) , 19 , 3 , -2 , deg2rad(0.08) , deg2rad(-0.2) ,0];
StateTest_array = StateTest0; 

% Define wind_inertial as a constant vector representing the wind in the inertial frame
wind_inertial = [0;0;0]; % Wind vector [u_wind; v_wind; w_wind]

% Define Aircraft Surface Controls
% aircraft_surfaces = [deg2rad(5);deg2rad(2);deg2rad(-13);(0.3)]; % given as u0 in problem

aircraft_surfaces = deg2rad([5;2;-13;0.3]); % given as u0 in problem

% Call the ODE solver for the aircraft equations of motion
[t, state_vector3] = ode45(@(t, y) AircraftEOM(time, StateTest_array, aircraft_surfaces, wind_inertial, aircraft_parameters), time, StateTest0);

% call PlotAircraftSim
fig = [231,232,233,234,235,236];

state_vector3 = state_vector3';
PlotAircraftSim(t, state_vector3, repmat(aircraft_surfaces, 1, numel(t)), fig, '-b');



% output all the stuff to test with.
% state vector
StateTest = state_vector3; 

disp(StateTest); 

    xE    = StateTest(1, :);
    yE    = StateTest(2, :);
    zE    = StateTest(3, :);
    phi   = StateTest(4, :);
    theta = StateTest(5, :);
    psi   = StateTest(6, :);
    uE    = StateTest(7, :);
    vE    = StateTest(8, :);
    wE    = StateTest(9, :);
    p     = StateTest(10, :);
    q     = StateTest(11, :);
    r     = StateTest(12, :);



