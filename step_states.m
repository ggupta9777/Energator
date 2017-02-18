function [X, X_mh, X_lfoot, X_rfoot, X_com, X_zmp, Xf_left, Xf_right, Xf_mh,tau,W] = step_states(Xi_left, Xi_right,Xi_mh,sl2, turn_angle, n)
global net_params
Xf_right = Xi_right;
Xf_left = Xi_left;
Xf_mh = zeros(3,1);
[~,l] = params();
l = [0 0 l(2) l(3) 0 0 l(4) 0 0 l(5) l(6) 0];
if n==0
    T = euler1(Xi_right(1:3),Xi_right(4),Xi_right(5),Xi_right(6));
    T_swingi = euler1(Xi_left(1:3),Xi_left(4),Xi_left(5),Xi_left(6));
    turn_theta = Xi_right(6);
    Xf_right = Xi_right;
    sl1 = T\[Xi_left(1:3);1];
    sl1 = abs(sl1(1));
else
    T = euler1(Xi_left(1:3),Xi_left(4),Xi_left(5),Xi_left(6));
    T_swingi = euler1(Xi_right(1:3),Xi_right(4),Xi_right(5),Xi_right(6));
    turn_theta = Xi_left(6);
    Xf_left = Xi_left;
    sl1 = T\[Xi_right(1:3);1];
    sl1 = abs(sl1(1));
end

[out,~] = step_turn(Xi_left, Xi_right,n,sl2,turn_angle,T,T_swingi);

if n==0
    Xf_left=out;
    T_swingf = euler1(Xf_left(1:3),Xf_left(4),Xf_left(5),Xf_left(6));
else
    Xf_right=out;
    T_swingf = euler1(Xf_right(1:3),Xf_right(4),Xf_right(5),Xf_right(6));
end

Xf_mh(1:2) = (Xf_left(1:2)+Xf_right(1:2))/2;
Xf_mh(3) = min(Xf_right(3),Xf_left(3))+ 0.9*(l(3)+l(4));
state_current = [Xi_left  [Xi_mh;zeros(3,1)]  Xi_right];
state_current = local_frame(state_current,T);

state_final = [Xf_left [Xf_mh;zeros(3,1)] Xf_right];
state_final = local_frame(state_final,T);

[m1,~] = get_point(T(1,4),T(2,4));
m1 = atand(m1*cosd(turn_theta));
[m2,~] = get_point(T_swingf(1,4),T_swingf(2,4));
m2 = atand(m2);
m = (m1+m2)/2;
% hold all;
% set(gcf,'color','w');
% %title('Joint Angle Comparison: ANN, GA, SVR, LR');
% xlabel('time (s)');
% ylabel('Joint Angles (degrees)')
f = sim(net_params,[n,sl1,sl2,m1,turn_angle]');     %work done for sl=0.1m using NN is 0.645J and 0.6241J for GA based result%
f = f';
[X, X_mh, X_lfoot, X_rfoot, X_com, X_zmp, tau,W] = step(state_current, state_final, n, T, T_swingi, T_swingf,f,1);
%f = [0.6032	0.627	0.2698	0.7302	0.5159	0.381	0.2079	0.2746];
%[X, X_mh, X_lfoot, X_rfoot, X_com, X_zmp, tau,W] = step(state_current, state_final, n, T, T_swingi, T_swingf,f,2);
%f = svr_predict([n,sl1,sl2,m1,turn_angle]'); 
%[X, X_mh, X_lfoot, X_rfoot, X_com, X_zmp, tau,W] = step(state_current, state_final, n, T, T_swingi, T_swingf,f,3);
%f = lr_predict([n,sl1,sl2,m1,turn_angle]');
%[X, X_mh, X_lfoot, X_rfoot, X_com, X_zmp, tau,W] = step(state_current, state_final, n, T, T_swingi, T_swingf,f,4);

end