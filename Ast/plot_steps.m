function [Xf_left, Xf_right, gscore] = plot_steps(Xi_left, Xi_right,actions)
%close all;
prec = 0.005;
xmax = 3;
ymax = 3;
[Map,  Map_gradx, ~, ~] = get_Map(xmax,ymax, prec);
Map = Map*prec;


sl = actions(:,1:2)';
sl = sl(:);
turn_angles = ([actions(:,3) actions(:,3)]');
turn_angles = turn_angles(:);
Xi_left = Xi_left';
Xi_right = Xi_right';

%Xi_left(5) = -atand(Map_gradx(com(1),com(2)));
%Xi_right(5) = Xi_left(5);

N = size(sl,1);
gscore = 0;
l_foot = 0.105;
w_foot = 0.065;
%figure;
hold all;
axis([0 xmax 0 ymax min(min(Map))-0.1 max(max(Map))+0.1])
view(-45,45)
surf(prec:prec:xmax,prec:prec:ymax,Map','Edgecolor','none');
 surf(prec:prec:xmax,prec:prec:ymax,Map'-0.01);
 colormap summer
 xlabel('x (m)');
 ylabel('y (m)');
 zlabel('z (m)');
 
xgoal = [2.2 2.5];
%
x1 =0.55/xmax; x2 = .8/xmax; x3 =1.05/xmax; x4=2.0/xmax; x5=2.25; x6=2.5;x7=2.75; x0=0.0; y1=0.01/ymax; y2 =2.0/ymax; h0=0;h1=0; h2=-0.03; h3=0; h4=0;h5=-h2; h6=-h2;h7=0;
x = [x1 x2 x3 ]; h = [h1 h2 h3 ];
%line(xmax*[x x(end:-1:1) x1],ymax*[y1*ones(1,size(x,2)) y2*ones(1,size(x,2)) y1],[h h(end:-1:1) h1],'linewidth',2,'color','b');
%line(xmax*[x1 x2 x2 x1],ymax*[y1 y1 y2 y2],[h1 h2 h2 h1],'linewidth',2,'color','b');
%line(xmax*[x2 x3 x3 x2],ymax*[y1 y1 y2 y2],[h2 h3 h3 h2],'linewidth',2,'color','b');
%line(xmax*[x1 x2 x3 x4],ymax*[y2 y2 y2 y2],[h1 h2 h3 h4],'linewidth',2,'color','b');
%line(xmax*[x1 x2 x3 x4],ymax*[y2 y2 y2 y2],[0.001 0.001 0.001 0.001],'linewidth',2,'color','b');
%line(xmax*[x x(end:-1:1) x1],ymax*[y1*ones(1,size(x,2)) y2*ones(1,size(x,2)) y1],[zeros(1,size(x,2)) zeros(1,size(x,2)) 0],'linewidth',2,'color','b');
% 
%line([0 xmax xmax 0 0],[0 0 ymax ymax 0],[0 0 0 0 0]);
 x1 = 1.2; x2 = 1.25; y1 = 0.55; y2 = 0.65; h=0.1;
 %line([x1 x2 x2 x1 x1],[y1 y1 y2 y2 y1],[0.001 0.001 0.001 0.001 0.001],'linewidth',2,'color','b');
 %line([x1 x2 x2 x1 x1],[y1 y1 y2 y2 y1],[h h h h h],'linewidth',2,'color','b');
 %line([x1 x1 x2 x2],[y1 y1 y1 y1],[0 h h 0],'linewidth',2,'color','b'); 
 %line([x1 x1 x2 x2],[y2 y2 y2 y2],[0 h h 0],'linewidth',2,'color','b');
  x1 = 1.55; x2 = 1.6; y1 = 1.101; y2 = 1.2; h=0.1;
 %line([x1 x2 x2 x1 x1],[y1 y1 y2 y2 y1],[0.001 0.001 0.001 0.001 0.001],'linewidth',2,'color','b');
 %line([x1 x2 x2 x1 x1],[y1 y1 y2 y2 y1],[h h h h h],'linewidth',2,'color','b');
%line([x1 x1 x2 x2],[y1 y1 y1 y1],[0 h h 0],'linewidth',2,'color','b'); 
 %line([x1 x1 x2 x2],[y2 y2 y2 y2],[0 h h 0],'linewidth',2,'color','b');
% 
%  x1 = xmax*0.6; x2 = xmax*0.65; y1 = ymax*0.5; y2 = 0.6*ymax; h=0.07;
%  line([x1 x2 x2 x1 x1],[y1 y1 y2 y2 y1],[0.001 0.001 0.001 0.001 0.001],'linewidth',2,'color','b');
%  line([x1 x2 x2 x1 x1],[y1 y1 y2 y2 y1],[h h h h h],'linewidth',2,'color','b');
%  line([x1 x1 x2 x2],[y1 y1 y1 y1],[0 h h 0],'linewidth',2,'color','b');
%  line([x1 x1 x2 x2],[y2 y2 y2 y2],[0 h h 0],'linewidth',2,'color','b');

line([xgoal(1) xgoal(1)],[xgoal(2) xgoal(2)],[min(min(Map)) 0.25],'color','r','linewidth',1.5);
line([(Xi_left(1) + Xi_right(1))/2 (Xi_left(1) + Xi_right(1))/2],[(Xi_left(2) + Xi_right(2))/2 (Xi_left(2) + Xi_right(2))/2],[0 0.25],'color','g','linewidth',1.5);
%%
gscore =0;
movescore = 0;
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
    
    
    %[Xf_left, Xf_right, T_swingf,~, sl1,sl2,T] = step_states(Xi_left, Xi_right,sl2, turn_angle, sf);
    [ Xf_left, Xf_right,~,T_swingf,~, sl1,sl2,T,~] = step_states(Xi_left, Xi_right,sl2, turn_angle, sf);
    %T(1,4),T(2,4)
    [m,~] = get_point(T(1,4),T(2,4));
    
    terrain_theta = atand(m);
    [gscore1,gscore2] = eval_score(Xi_left, Xi_right, Xf_left, Xf_right, T_swingf,sl1,sl2,sf,terrain_theta,turn_angle);
    gscore = gscore + gscore1;
    movescore = movescore + gscore2;
    Xi_left = Xf_left;
    Xi_right = Xf_right;
    %hold all;
     %plot3([Xf1(1,:) Xf1(1,1)],[Xf1(2,:) Xf1(2,1)],[Xf1(3,:) Xf1(3,1)],'linewidth',1,'color','k');
     %plot3([Xf2(1,:) Xf2(1,1)],[Xf2(2,:) Xf2(2,1)],[Xf2(3,:) Xf2(3,1)],'linewidth',1,'color','k');
end
Xf_left = Xf_left';
Xf_right = Xf_right';
gscore, movescore
end