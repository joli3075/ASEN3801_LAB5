function x_dot= AircraftEOM(time, aircraft_state, aircraft_surfaces, wind_inertial, aircraft_parameters)
    
    height = abs(aircraft_state(3)); %z 

    %angles
    phi = aircraft_state(4);
    theta = aircraft_state(5); 
    psi = aircraft_state(6); 
    
    %intertial velcoity
    u = aircraft_state(7); 
    v = aircraft_state(8); 
    w = aircraft_state(9); 
    
    %angular velocity
    p = aircraft_state(10);
    q = aircraft_state(11);
    r = aircraft_state(12); 

    density = stdatmo(height); 
    [Fa, Ma] = AeroForcesAndMoments(aicraft_state, aircraft_surfaces, wind_intertial, density, aircraft_parameters); 
    
    %pos_dot ----------------------

    c3 = cos(psi);  s3 = sin(psi);
    c2 = cos(theta);  s2 = sin(theta);
    c1 = cos(phi);  s1 = sin(phi);
    
    R1 = [c2*c3, s1*s2*c3 - c1*s3, c1*s2*c3 + s1*s3;
        c2*s3, s1*s2*s3 + c1*c3, c1*s2*s3 - s1*c3;
        -s2, s1*c2, c1*c2];
    
    pos_dot = R1 * [u; v; w]; 
    
    %angle_dot ----------------------

    R2 = [1, s1*tan(theta), c1*tan(theta);
          0, c1, -s1;
          0 s1*sec(theta), c1*sec(theta)]; 
    
    angle_dot = R2 * [p; q; r]; 
    
    % vel_dot ----------------------

    u_dot = (r*v - q*w) + g*(-s2) + (Fa(1)/m);
    v_dot = (p*w - r*u) + g*(c2*s1) + (Fa(2)/m); 
    w_dot = (q*u - p*v) + g*(c2*c1) + (Fa(3)/m);
    
    vel_dot = [u_dot; v_dot; w_dot]; 
    

    %omega_dot ----------------------

    Ix = aircraft_parameters.Ix; Iy = aircraft_parameters.Iy; Iz = aircraft_parameters.Iz; 
    Ixz = aircraft_parameters.Ixz; 
    
    gamma = Ix*Iz - (Ixz^2); 
    gamma1 = Ixz*(Ix - Iy + Iz) / gamma; gamma2 = (Iz*(Iz - Iy) + Ixz^2) / gamma; 
    gamma3 = Iz / gamma; gamma4 = Ixz / gamma; 
    gamma5 = (Iz - Ix) / Iy; gamma6 = (Ixz / Iy); 
    gamma7 = (Ix*(Ix - Iy) + Ixz^2)/gamma; gamma8 = Ix/gamma; 
    
    L = Ma(1); M = Ma(2); N = Ma(3); 
    
    p_dot = (gamma1*p*q - gamma2*q*r) + (gamma3*L + gamma4*N); 
    q_dot = (gamma5*p*r - (gamma6*(p^2 - r^2))) + (M/Iy); 
    r_dot = (gamma7*p*q - gamma1*q*r) + (gamma4*L + gamma8*N); 
    
    omega_dot = [p_dot; q_dot; r_dot]; 
    
    %final state vec
    x_dot = [pos_dot; angle_dot; vel_dot; omega_dot]; 

end

