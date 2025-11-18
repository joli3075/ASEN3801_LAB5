% Lab extras

Cxu = -0.108; 
Czu = -0.1060; 
Cmu = 0.1043;
Cxa = 0.2193; 
Cza = -4.92; 
Cma = -1.023;
Cxq = 0; 
Czq = -5.921; 
Cmq = -23.92;
Cxad = 0; 
Czad = 5.896; 
Cmad = -6.314;

% X
Xu = rho * u0 * S * Cw0 * sin(theta0) + 0.5 * rho * u0 * S * Cxu;
Xw = 0.5 * rho * u0 * S * Cxa;
Xq = 0.25 * rho * u0 * S * Cxq * cdash;
Xwd = 0.25 * rho * S * Cxad * cdash;
% Z
Zu = -rho * u0 * S * Cw0 * cosd(theta0) + 0.5 * rho * u0 * S * Czu;
Zw = 0.5 * rho * u0 * S * Cza;
Zq = 0.25 * rho * u0 * S * Czq * cdash;
Zwd = 0.25 * rho * S * Czad  * cdash;
% M
Mu = 0.5 * rho * u0 * S * Cmu * cdash;
Mw = 0.5 * rho * u0 * S * Cma * cdash;
Mq = 0.25 * rho * u0 * S * Cmq * (cdash^2);
Mwd = 0.25 * rho * S * Cmad * (cdash^2);

A_lon = [
                     Xu/m                                          ,                    Xw/m                                         ,                                       0                                                 ,                       -g * cos(theta0)                                                  ;
              Zu / (m - Zwd)                                  ,                Zw / (m - Zwd)                              ,              (Zq + m * u0) / (m - Zwd)                                  ,                    (-m * g * sin(theta0)) / (m - Zwd)                          ;
   (1 / Iy) * (Mu + (Mwd * Zu) / (m - Zwd))  ,  (1 / Iy) * (Mw + (Mwd * Zw) / (m - Zwd)) ,   (1 / Iy) * (Mq + (Mwd * (Zq + m * u0)) / (m - Zwd))  ,          (1 / Iy) * (-Mwd * m * g * sind(theta0)) / (m - Zwd)       ;
                                     0                               ,                  0                                  ,                                             1                                          ,                      0                                                                               ];
disp(A_lon);