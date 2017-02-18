function [ Xf_left, Xf_right,T_swingi,T_swingf,flag, sl1,sl2,T,terrain_orient] = step_states(Xi_left, Xi_right,sl2, turn_angle, n)
% global net_params
% [~,l] = params();
% l = [0 0 l(2) l(3) 0 0 l(4) 0 0 l(5) l(6) 0];
% Xi_mh = zeros(3,1);
% Xf_mh = Xi_mh;
% Xi_mh(1:2) = (Xi_left(1:2)+Xi_right(1:2))/2;
% Xi_mh(3) = min(Xi_right(3),Xi_left(3))+ 0.95*(l(3)+l(4));

Xf_right = Xi_right;
Xf_left = Xi_left;
if n==0
    T = euler1(Xi_right(1:3),Xi_right(4),Xi_right(5),Xi_right(6));
    T_swingi = euler1(Xi_left(1:3),Xi_left(4),Xi_left(5),Xi_left(6));
    terrain_orient = Xi_right(6);
    Xf_right = Xi_right;
    sl1 = T\[Xi_left(1:3);1];
    sl1 = abs(sl1(1));
else
    T = euler1(Xi_left(1:3),Xi_left(4),Xi_left(5),Xi_left(6));
    T_swingi = euler1(Xi_right(1:3),Xi_right(4),Xi_right(5),Xi_right(6));
    terrain_orient = Xi_left(6);
    Xf_left = Xi_left;
    sl1 = T\[Xi_right(1:3);1];
    sl1 = abs(sl1(1));
end

[out,flag] = step_turn(Xi_left, Xi_right,n,sl2,turn_angle,T,T_swingi);

if n==0
    Xf_left=out;
    T_swingf = euler1(Xf_left(1:3),Xf_left(4),Xf_left(5),Xf_left(6));
    sl2 = T_swingf\[Xf_right(1:3);1];
    sl2 = abs(sl2(1));
else
    Xf_right=out;
    T_swingf = euler1(Xf_right(1:3),Xf_right(4),Xf_right(5),Xf_right(6));
    sl2 = T_swingf\[Xf_left(1:3);1];
    sl2 = abs(sl2(1));
end

% [m1,~] = get_point(T(1,4),T(2,4));
% [m2,~] = get_point(T_swingf(1,4),T_swingf(2,4));

% if sl1>0.1
%     Xf_mh(1:2) = (Xf_left(1:2)+Xf_right(1:2))/2;
%     Xf_mh(3) = min(Xf_right(3),Xf_left(3))+ 0.95*(l(3)+l(4));
%     state_current = [Xi_left  [Xi_mh;zeros(3,1)]  Xi_right];
%     state_current = local_frame(state_current,T);
%     
%     state_final = [Xf_left [Xf_mh;zeros(3,1)] Xf_right];
%     state_final = local_frame(state_final,T);
%     
%     m1 = atand(m1);
%     m1 = m1*cosd(terrain_orient);
%     
%     m2 = atand(m2);
%     m = (m1+m2)/2;
%     f = sim(net_params,[n,sl1,sl2,m1,turn_angle]');
%     f = f';
%     
%     zmpflag = step(state_current, state_final, n, T, T_swingi, T_swingf,f);
%     
%     if zmpflag==1
%         flag=1;
%     end
% end

end