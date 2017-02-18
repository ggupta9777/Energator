function T = tform(alpha,a,d,theta)
        T = [cos(theta) -sin(theta) 0 a;
            sin(theta)*cos(alpha) cos(theta)*cos(alpha) -sin(alpha) -sin(alpha)*d;
            sin(theta)*sin(alpha) cos(theta)*sin(alpha) cos(alpha) cos(alpha)*d;
            0 0 0 1];
end
%    
% [   sin(t4)*sin(t6) - cos(t4)*cos(t6)*sin(t5), cos(t6)*sin(t4) + cos(t4)*sin(t5)*sin(t6), cos(t4)*cos(t5), l4]
% [ - cos(t4)*sin(t6) - cos(t6)*sin(t4)*sin(t5), sin(t4)*sin(t5)*sin(t6) - cos(t4)*cos(t6), cos(t5)*sin(t4),  0]
% [                             cos(t5)*cos(t6),                          -cos(t5)*sin(t6),         sin(t5),  0]
% [                                           0,                                         0,               0,  1]