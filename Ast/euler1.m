
    function T = euler1(x,phi,theta,psi)
        D = [1 0 0; 0 cosd(phi) sind(phi); 0 -sind(phi) cosd(phi)];
        C = [cosd(theta) 0 sind(theta); 0 1 0; -sind(theta) 0 cosd(theta)];
        B = [cosd(psi) -sind(psi) 0; sind(psi) cosd(psi) 0; 0 0 1];
        T = [D*C*B [x(1);x(2);x(3)]; 0 0 0 1];          %WATCH THIS, rotation about local frame, 
    end