function [Xf_left, Xf_right, gscore] = plot_steps(Xi_left, Xi_right,actions)
prec = 0.01;
xmax = 4;
ymax = 4;
[Map, ~, ~, ~] = get_Map(xmax,ymax, prec);
Map = Map*prec;
sl = actions(:,1:2)';
sl = sl(:);
turn_angles = ([actions(:,3) actions(:,3)]');
turn_angles = turn_angles(:);
Xi_left = Xi_left';
Xi_right = Xi_right';


N = size(sl,1);

gscore = 0;
l_foot = 0.1;
w_foot = 0.06;
figure;
axis([0 xmax 0 ymax 0 0.25])
hold all;
surf(prec:prec:xmax,prec:prec:ymax,Map','EdgeColor','none');
colormap summer

for n=1:N
    sf = mod(n,2);          %sf = 1 means right foot swings
    turn_angle = turn_angles(n);
    
    
    if sf==1
        T = euler1(Xi_left(1:3),Xi_left(4),Xi_left(5),Xi_left(6));
        T_swingi = euler1(Xi_right(1:3),Xi_right(4),Xi_right(5),Xi_right(6));
    else
        T_swingi = euler1(Xi_left(1:3),Xi_left(4),Xi_left(5),Xi_left(6));
        T = euler1(Xi_right(1:3),Xi_right(4),Xi_right(5),Xi_right(6));
    end
    
    sl2 = sl(n);
    Xf1 = T*[l_foot/2 l_foot/2 -l_foot/2 -l_foot/2;w_foot/2 -w_foot/2 -w_foot/2 w_foot/2; 0 0 0 0; 1 1 1 1];
    Xf2 = T_swingi*[l_foot/2 l_foot/2 -l_foot/2 -l_foot/2;w_foot/2 -w_foot/2 -w_foot/2 w_foot/2; 0 0 0 0; 1 1 1 1];
    
    
    [Xf_left, Xf_right, T_swingf,tf] = step_states(Xi_left, Xi_right,sl2, turn_angle, sf);
    
    Xi_left = Xf_left;
    Xi_right = Xf_right;
    hold all;
    plot3([Xf1(1,:) Xf1(1,1)],[Xf1(2,:) Xf1(2,1)],[Xf1(3,:) Xf1(3,1)],'linewidth',2,'color','b');
    plot3([Xf2(1,:) Xf2(1,1)],[Xf2(2,:) Xf2(2,1)],[Xf2(3,:) Xf2(3,1)],'linewidth',2,'color','b');
end
Xf_left = Xf_left';
Xf_right = Xf_right';
end