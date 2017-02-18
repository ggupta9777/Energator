function [Xf_left, Xf_right, gscore] = get_state(Xi_left, Xi_right, sl, turn_angle)

Xi_left = Xi_left';
Xi_right = Xi_right';
T = euler1(Xi_left(1:3),Xi_left(4),Xi_left(5),Xi_left(6));
xir = T\[Xi_right(1:3);1];
sl10 = abs(xir(1));

N = 2;
gscore = 0;
for n=1:N
    sf = mod(n,2);          %sf = 1 means right foot swings
    sl2 = sl(n);
    [Xf_left, Xf_right, T_swingi,T_swingf,tf, sl1,sl2,T,terrain_orient] = step_states(Xi_left, Xi_right,sl2, turn_angle, sf);
    if turn_angle~=0
        sl1 = sl10;
        sl2= sl10;
    end
    
    
    [m,~] = get_point(T(1,4),T(2,4));
    terrain_theta = atand(m);
    gscore1 = check_score(Xi_left, Xi_right, Xf_left, Xf_right, T_swingf,sl1,sl2,sf,terrain_theta,turn_angle);
    if tf==1
        gscore1=10e5;
    end
    
    if gscore1<=10e4
        if sl1>0.1
            zmpflag = check_balance(Xi_left,Xi_right,Xf_left, Xf_right, T_swingi,T_swingf,sl1,sl2,T,terrain_orient,turn_angle,sf);
            gscore1 = gscore1+zmpflag*10e5;
        end
    end
    
    if gscore1>=10e4
        gscore = gscore1;
        Xf_left = Xf_left';
        Xf_right = Xf_right';
        return;
    end
    gscore = gscore+gscore1;
    Xi_left = Xf_left;
    Xi_right = Xf_right;
end
Xf_left = Xf_left';
Xf_right = Xf_right';
end