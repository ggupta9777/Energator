function zmpflag = check_balance(Xi_left,Xi_right,Xf_left, Xf_right, T_swingi,T_swingf, sl1,sl2,T,terrain_orient,turn_angle,n)
global net_params balance_matrix
index = round(sl2/0.025) + 1;
if balance_matrix(index)==0
    [~,l] = params();
    l = [0 0 l(2) l(3) 0 0 l(4) 0 0 l(5) l(6) 0];
    [m1,~] = get_point(T(1,4),T(2,4));
    [m2,~] = get_point(T_swingf(1,4),T_swingf(2,4));
    Xi_mh = zeros(3,1);
    Xf_mh = Xi_mh;
    Xi_mh(1:2) = (Xi_left(1:2)+Xi_right(1:2))/2;
    Xi_mh(3) = min(Xi_right(3),Xi_left(3))+ 0.95*(l(3)+l(4));
    
    Xf_mh(1:2) = (Xf_left(1:2)+Xf_right(1:2))/2;
    Xf_mh(3) = min(Xf_right(3),Xf_left(3))+ 0.95*(l(3)+l(4));
    state_current = [Xi_left  [Xi_mh;zeros(3,1)]  Xi_right];
    state_current = local_frame(state_current,T);
    
    state_final = [Xf_left [Xf_mh;zeros(3,1)] Xf_right];
    state_final = local_frame(state_final,T);
    
    m1 = atand(m1);
    m1 = m1*cosd(terrain_orient);
    
    m2 = atand(m2);
    m = (m1+m2)/2;
    f = sim(net_params,[n,sl1,sl2,m1,turn_angle]');
    f = f';
    
    zmpflag = step(state_current, state_final, n, T, T_swingi, T_swingf,f);
    if zmpflag==1
        balance_matrix(index)= -1;
    else
        balance_matrix(index)= 1;
    end
elseif balance_matrix(index) ==1
    zmpflag=0;
else
    zmpflag = 1;
end
end