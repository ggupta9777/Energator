function T = trans_dot(alpha, theta)
        T = [           -sind(theta),            -cosd(theta), 0, 0;
             cosd(alpha)*cosd(theta), -cosd(alpha)*sind(theta), 0, 0;
             sind(alpha)*cosd(theta), -sind(alpha)*sind(theta), 0, 0;
                              0,                   0, 0, 0];