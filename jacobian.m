function out = jacobian(theta, sf,T)
%JAC'*fEXT WILL GIVE THE TORQUE ACTING ON THE SYSTEM DUE TO EXTERNAL FORCE
%MOTOR NEEDS TO APPLY OPPOSITE TORQUE TO BALANCE THIS ONE
%T = [0 0 1 0; 0 -1 0 0; 1 0 0 0; 0 0 0 1];
[~,l] = params();
l = l(1);
out = zeros(4,1);
[A,A_dot,~] = h_trans(theta,sf);
n = size(theta,1);
for i=1:n
    temp = T*U2(A,A_dot,n,i)*[l;0;0;1];
    out = [out temp];
end
out = out(1:3,2:end);
end