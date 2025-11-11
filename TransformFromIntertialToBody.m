function wind_body = TransformFromIntertialToBody(wind_inertial, angles)
    
  phi = angles(1); theta = angles(2); psi = angles(3); 

  c3 = cos(psi);  s3 = sin(psi);
  c2 = cos(theta);  s2 = sin(theta);
  c1 = cos(phi);  s1 = sin(phi);

  Rb_e = [c2*c3, c2*s3, -s2;
          s1*s2*c3 - c1*s3; s1*s2*s3 + c1*c3, s1*c2;
          c1*s2*c3 - s1*s3, c1*s2*s3 - s1*c3, c1*c2]; 

  wind_body = Rb_e * wind_inertial; 


end



