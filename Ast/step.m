function zmpflag = step(state_current1, state_final1, sf, T, T_swingi, T_swingf,f)
%function [X, X_mh, X_lfoot, X_rfoot, X_com, X_zmp, tau,W,zmpflag] = step(state_current1, state_final1, sf, T, T_swingi, T_swingf,f)
%l_foot=0.1;
zmpflag = 0;
n = 51;     %number of iterations/halfstep = 1second
X1 = zeros(3,n);
X2 = zeros(3,n);
X3 = zeros(3,n);
eul1 = zeros(3,n);
eul3 = zeros(3,n);
t_halfstep = 1;
pos_midpoints = zeros(3,7,n);
[mass_midpoints, ~] = params();
td1 = floor(2*n/10);
td2 = floor(8*n/10);
tm = floor(n/2);
ta = floor((td1+tm)/2);
tb = floor((td2+tm)/2);
pos_zmp = zeros(3,n);
W = 0;
if sf==0
    state_current = state_current1;
    state_final = state_final1;
else
    state_current = state_current1(:,[3,2,1]);
    state_final = state_final1(:,[3,2,1]);
end

step_length = norm(state_current(1:3,1) - state_final(1:3,1));

mh_zmax = 0.05;
f_zmax = 0.15;
f_zmin = 0.025;

f1xta = f(1);          %fraction of total step length by swing foot at half time step
f1xtb = f(2);          %fraction of maximum allowable step height at half time step
f1ztm = 1   ;          %fraction of maximum allowable step height at half time step
f2xta = f(3);          %fraction of total x-distance by mid hip
f2xtb = f(4);          %fraction of total x-distance by mid hip
f2ztm = f(5);          %fraction of height permissible above the max(z_mh_initial,z_mh_final)
f2ytd1 = f(7);         %fraction of total step-width at halftime step
f2ytm = f(6);          %fraction of total step-width at halftime step
f2ytd2 = f(8);         %fraction of total step-width at halftime step


Xi1 = state_current(1:3,1);
Xi2 = state_current(1:3,2);
Xi3 = state_current(1:3,3);

Xf1 = state_final(1:3,1);
Xf2 = state_final(1:3,2);

for i=1:n
    X3(:,i) = Xi3;
    if i<td1
        eul1(:,i) = state_current(4:6,1);
    elseif i>=td1 && i<=td2
        eul1(:,i) = state_current(4:6,1)+((i-td1)/(td2-td1))*(state_final(4:6,1)-state_current(4:6,1));
    else
        eul1(:,i) = state_final(4:6,1);
    end
    eul3(:,i) = state_current(4:6,3);
end

x1ta = Xi1(1)+(f1xta-0.5)*step_length;
x1tb = Xi1(1)+(1.5-f1xtb)*step_length;
z1tm = Xi1(3)+f_zmin+f_zmax*(1-f1ztm);
x2ta = Xi2(1) + (Xf2(1)-Xi2(1))*f2xta;
x2tb = Xi2(1) + (Xf2(1)-Xi2(1))*f2xtb;
y2tm = Xi2(2)+f2ytm*(Xi3(2)-Xi1(2));
y2td1 = Xi2(2)+f2ytd1*(Xi3(2)-Xi1(2));
y2td2 = Xi2(2)+f2ytd2*(Xi3(2)-Xi1(2));
z2tm = max(Xi2(3),Xf2(3))+(f2ztm-0.5)*mh_zmax;

X1(1,td1:td2) = traj_gen([td1 ta tb td2],[Xi1(1) x1ta x1tb Xf1(1)]);
X1(1,1:td1-1) = Xi1(1)*ones(1,td1-1);
X1(1,td2+1:n) = Xf1(1)*ones(1,n-td2);
X1(2,td1:td2) = traj_gen([td1 td2],[Xi1(2) Xf1(2)]);
X1(2,1:td1-1) = Xi1(2)*ones(1,td1-1);
X1(2,td2+1:n) = Xf1(2)*ones(1,n-td2);
X1(3,td1:td2) = traj_gen([td1 tm td2],[Xi1(3) z1tm Xf1(3)]);
X1(3,1:td1-1) = Xi1(3)*ones(1,td1-1);
X1(3,td2+1:n) = Xf1(3)*ones(1,n-td2);
X2(1,:) = traj_gen([1 ta tb n],[Xi2(1) x2ta  x2tb Xf2(1)]);
X2(2,:) = traj_gen([1 td1 tm td2 n],[Xi2(2) y2td1 y2tm y2td2 Xf2(2)]);
X2(3,:) = traj_gen([1 tm n],[Xi2(3) z2tm Xf2(3)]);


X2 = global_frame(X2,T);
X3 = global_frame(X3,T);
X1 = global_frame(X1,T);

o2 = zeros(3,6,n);
o3 = zeros(3,5,n);
o4 = o3;

if sf==0
    Xlf = [X1;eul1];
    Xrf = [X3;eul3];
else
    Xrf = [X1;eul1];
    Xlf = [X3;eul3];
end

X_mh = X2;
pos_t = zeros(3,7,3);
p_com = zeros(3,n);
theta = zeros(12,n);
tau = zeros(12,n);
angles = zeros(12,n);
%h = t_halfstep/n;
poly_zmp = zeros(3,4,n);
for i=1:n
    [o1, o2(:,:,i),o3(:,:,i),o4(:,:,i),~] = ik(Xlf(:,i),Xrf(:,i),X_mh(:,i));
    pos_t(:,:,1) = pos_t(:,:,2);
    pos_t(:,:,2) = pos_t(:,:,3);
    [pos_midpoints(:,:,i),p_com(:,i)] = draw_com(o2(:,:,i));
    pos_t(:,:,3) = pos_midpoints(:,:,i);
    pos_zmp(:,i) = zmp(pos_t,mass_midpoints,t_halfstep,n,T,T_swingi,T_swingf,i,td1,td2);
    if sf==1
        o1(7:end) = -o1(7:end);     %if right leg swings, angles are la-lk-lh-rh-rk-ra
        angles(:,i) = o1;
    else
        o1(1:6) = -o1(1:6);
        angles(:,i) = o1;
        o1 = o1(end:-1:1);          %if left leg swings, angles are ra-rk-rh-lh-lk-la
    end
    %finally, angles are obtained from ankle of stance leg,to knee,to hip
    %of stance, then to hip-knee-ankle of swing leg
    theta(:,i) = o1;
    %%%%%%%%ZMP TEST %%%%%%%%%%%%%%%%%
    if sf==0
        poly_zmp(:,:,i) = o4(:,2:end,i);
    else
        poly_zmp(:,:,i) = o3(:,2:end,i);
    end
    %%%%%%%ZMP TEST%%%%%%%%%%%%%%%%%%%%
end
% omega = (pi/180)*[zeros(12,1) (diff(theta'))']/h;
% alpha = (pi/180)*[zeros(12,2) (diff(diff(theta')))']/h^2;
% a_com = [zeros(3,2) (diff(diff(p_com')))']/h^2;

for i=1:n
    %ZMP TEST
    Xp = poly_zmp(1,:,i);
    Yp = poly_zmp(2,:,i);
    Xzmp = pos_zmp(1,i);
    Yzmp = pos_zmp(2,i);
    if i>td1 && i<td2 && inpolygon(Xzmp,Yzmp,Xp,Yp)==0
        zmpflag=1;
        break;
        %disp([state_current state_final]);
    end
    %ZMP TEST
    
    %tau(:,i) = lag_dyn(theta(:,i),omega(:,i),alpha(:,i),n,sf,T,i, p_com(:,i), a_com(:,i), T_swingi, T_swingf,td1,td2);
%     if i>2
%         W = W + sum(abs(tau(:,i).*omega(:,i))*h);
%     end
end

% pos_zmp(:,2) = (pos_zmp(:,3)+pos_zmp(:,1))/2;
% pos_zmp(:,50) = (pos_zmp(:,51)+pos_zmp(:,49))/2;
% X = o2;
% X_lfoot = o3;
% X_rfoot = o4;
% X_zmp = pos_zmp;
% X_com = pos_midpoints;
end
