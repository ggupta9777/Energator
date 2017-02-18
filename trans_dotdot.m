function T = trans_dotdot(alpha, theta)
        T = [           -cosd(theta),            sind(theta), 0, 0;
             -cosd(alpha)*sind(theta), -cosd(alpha)*cosd(theta), 0, 0;
             -sind(alpha)*sind(theta), -sind(alpha)*cosd(theta), 0, 0;
                              0,                   0, 0, 0];
    end