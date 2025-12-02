function [nat_freq, Tc, Damp] = Lat_NatFreq_Tc_Damp(aircraft_parameters, h, u0, theta0,rho)
% define constants and given parameters in question statement.
Cyb = aircraft_parameters.CYbeta;
Clb = aircraft_parameters.Clbeta;
Cnb = aircraft_parameters.Cnbeta;

Cyp = aircraft_parametes.CYp;
Clp = aircraft_parameters.Clp;
Cnp = aircraft_parameters.Cnp;

Cyr = aircraft_parameters.Cyr;
Clr = aircraft_parameters.Clr;
Cnr = aircraft_parameters.Cnr;


b = aircraft_parametes.b;
S = aircraft_parameters.S;
W = aircraft_parameters.m * aircraft_parameters.g;
Ix = aircraft_parameters.Ix;
Iz = aircraft_parameters.Iz;
Ixz = aircraft_parameters.Ixz;
% h = 3000; % given passed in 
% u0 = 275; passed in 
% theta0 = deg2rad(-3);  % deg to rad passed in 
g = aircraft_parameters.g;

% define initial known constants and base variables
% rho = stdatmo(h); passed in
q = 0.5 * rho * (u0^2);
m = aircraft_parameters.m;
%% 1.a
% Determine stability Derivates Y L N

% Stability Derivatives Y
Yb = 0.5 * rho * u0 *S * Cyb;
Yp = 0.25 * rho * u0 * b * S * Cyp;
Yr = 0.25 * rho * u0 * b * S * Cyr;

% Stability Derivatives L
Lb = 0.5 * rho * u0 * b * S * Clb;
Lp = 0.25 * rho * u0 * (b^2) * S * Clp;
Lr = 0.25 * rho * u0 * (b^2) * S * Clr;

% Stability Derivatives N
Nb = 0.5 * rho * u0 * b * S * Cnb;
Np = 0.25 * rho * u0 * (b^2) * S * Cnp;
Nr = 0.25 * rho * u0 * (b^2) * S * Cnr;

% Define the stability derivatives vector
Y = [Yb, Yp, Yr];
L = [Lb, Lp, Lr];
N = [Nb, Np, Nr];

disp("Y vector [Yb, Yp, Yr]:");
disp(Y);
disp("L vector [Lb, Lp, Lr]:");
disp(L);
disp("N vector [Nb, Np, Nr]:");
disp(N);


%% 1.b
% Calculate the Alat matrix


% define gamma
gamma = Ix * Iz - Ixz^2;
% gamma_1 = (Ixz * (Ix - Iy + Iz)) / gamma;
% gamma_2 = (Iz * (Iz - Iy) + Ixz^2) / gamma;
gamma_3 = Iz / gamma;
gamma_4 = Ixz / gamma;
% gamma_5 = (gamma - Ix) / Iy;
% gamma_6 = Ixz / Iy;
% gamma_7 = (Ix * (Ix - Iy) + Ixz^2) / gamma;
gamma_8 = Ix / gamma;

A_lat = [ ...
    Yb/m,                       Yp/m,                        (Yr/m) - u0,                  g*cos(theta0);
    gamma_3*Lb + gamma_4*Nb,    gamma_3*Lp + gamma_4*Np,     gamma_3*Lr + gamma_4*Nr,      0;
    gamma_4*Lb + gamma_8*Nb,    gamma_4*Lp + gamma_8*Np,     gamma_4*Lr + gamma_8*Nr,      0;
    0,                          1,                           tan(theta0),                  0 ...
    ];

disp("Alat Matrix:")
disp(A_lat);


%% 1.c
% Calculate the eigenvalues and eigenvectors of the Alat matrix
[eigenvectors, eigenvalues] = eig(A_lat);

eigenvalues = diag(eigenvalues);
% Display the eigenvalues
disp("Eigenvalues of the Alat Matrix:");
disp(eigenvalues);

% Display the eigenvectors
disp("Eigenvectors of the Alat Matrix:");
disp(eigenvectors);



%% 1.d Routh Stability

poly_coeffs = poly(A_lat);

disp("Characteristic polynomial coefficients:");
disp(poly_coeffs);

%% 1.e Natural Frequency and Time Constant Calculation

% Calculate natural frequencies (omega) from eigenvalues
natural_frequencies = sqrt(real(eigenvalues).^2 + imag(eigenvalues).^2);

% Calculate time constants (tau) for each mode
time_constants = 1 ./ abs(real(eigenvalues));

disp("Natural Frequencies (rad/s):");
disp(natural_frequencies);

disp("Time Constants (s):");
disp(time_constants);


nat_freq = natural_frequencies; 

Tc = time_constants; 

Damp = 0; 

end