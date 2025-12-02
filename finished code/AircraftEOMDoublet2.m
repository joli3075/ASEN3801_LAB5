
function xdot = AircraftEOMDoublet2(time, aircraft_state, aircraft_surfaces, doublet_size,doublet_time, wind_inertial, aircraft_parameters)
delta_e_trim = 0.1079;
if time <= doublet_time
    delta_e = delta_e_trim + doublet_size;
elseif time <= 2*doublet_time
    delta_e = delta_e_trim - doublet_size;
else
    delta_e = delta_e_trim;
end

aircraft_surfaces(4) = delta_e; 

xdot = AircraftEOM(time, aircraft_state, aircraft_surfaces, wind_inertial, aircraft_parameters);


end
