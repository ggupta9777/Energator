function tau = lag_dyn(theta,omega,alpha,n,sf,T,tstep, r_com, a_com,T_swingi, T_swingf,td1,td2)

g = [0;0;-9.8;0];

T = T*[0 0 1 0; 0 -1 0 0; 1 0 0 0; 0 0 0 1];
mass = params();
M = sum(mass)-mass(1);
delr = r_com-T(1:3,4)-[0;0;0.032];
%thet1 = delr(1)/delr(3);
%thet2 = delr(2)/delr(3);
%tempt = cross(r_com-T(1:3,4)-[0;0;0.032],M*g(1:3));
F_f = zeros(3,1);
if tstep<=td1 || tstep>=td2
    F_f = -M*(g-[a_com;0])/2;
%     if tstep<=td1
%         F_f =T_swingi*F_f;
%     else
%         F_f =T_swingf*F_f;
%     end
    F_f(1) = -F_f(1);
    F_f = F_f(1:3);
    
%     for i=1:length(F_f)
%         if abs(F_f(i))==inf
%             F_f(i)=0;
%         end
%     end
    if tstep<=td1
        F_f = F_f*(td1-tstep)/(td1-1);
    elseif tstep>=td2 && tstep<=n
        F_f = F_f*(tstep-td2)/((n-td2));
    end
    %disp(F_f)
end
jac = jacobian(theta,sf,T);
[~,r] = params();
r_eq = (mass(4)*(r(4)/2)^2 + mass(5)*r(4)^2)/(mass(4)*r(4)/2 + mass(5)*r(4));
m_eq = (mass(4)*r(4)/2 + mass(5)*r(4))/r_eq;
r = [0 r(2) r(3) 0 0 r_eq 0 0 r(5) r(6) 0 0]';
mass = [0;mass(2);mass(3);0;0;m_eq;0;0;mass(6);mass(7);0;0];

if sf==0
    r(6) = -r(6);
end

[A,A_dot,A_dotdot] = h_trans(theta,sf);

N = size(omega,1);
tau = zeros(N,1);

g = T\g;

for i=1:N
    D=0;
    H=0;
    C=0;
    for k=1:N
        Dik=0;
        for j =max(i,k):N
            rj = [r(j);0;0;1];
            J = mass(j)*(rj*rj');
            Dik = Dik+ trace(U2(A,A_dot, j,k)*J*U2(A,A_dot,j,i)');
        end
         D = D+Dik*alpha(k);
        for m=1:N
            hikm = 0;
            for j=max(max(i,k),m):N
                rj = [r(j);0;0;1];
                J = mass(j)*(rj*rj');
                hikm = hikm + trace(U3(A,A_dot,A_dotdot,j,k,m)*J*U2(A,A_dot,j,i)');
            end
            H = H + hikm*omega(k)*omega(m);
        end
     end
    
    for j=i:N
        rj = [r(j);0;0;1];
        C = C -mass(j)*g'*U2(A,A_dot,j,i)*rj;
    end
    tau(i) = C+D+H;
end
tau = tau -jac'*F_f;
end
