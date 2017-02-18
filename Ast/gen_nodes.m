
function out = gen_nodes(A,goal)
global  sl_max netE Eflag hE hP prec Map
T = euler1(A(1:3),A(4),A(5),A(6));
XR = T\[A(7:9)';1];
sl_turn = abs(XR(1));

com_goal = get_com(goal);
out1 = zeros(36, size(A,2));
out2 = zeros(16, size(A,2));
k = 0;
sls = [0.0 0.025 0.05 0.075 0.1 0.125];
turn_angles = [0 5 -5 -15 15];

for i=1:6
    for j=1:6
        k=k+1;
        turn_angle = turn_angles(1);
        sl = [sls(i) sls(j)];
        [Xf_left, Xf_right, gscore] = get_state(A(1:6), A(7:12), sl, turn_angle);
        out1(k,1:12) = [Xf_left Xf_right];
        out1(k,13:15) = [sl turn_angle];
        out1(k,16) = gscore + A(16);
        if gscore<10e4
            com_now = get_com(out1(k,:));
            z_now = Map(max(1,com_now(1)), max(1,com_now(2)));
            %angle1 = atan2d(com_goal(2)-com_now(2),com_goal(1)-com_now(1));
            %angle2 = (out1(k,6)+out1(k,12))/2;
            %delta_angle = mod(abs(angle1-angle2),360);
            %steps2turn = delta_angle/15;
            %grad_now = (goal(3) -0.5*(out1(3)+out1(9)))/(prec*norm(com_now-com_goal));
            grad_now = (goal(3) - prec*z_now)/(prec*norm(com_now-com_goal));
            grad_now = atand(grad_now);
            
            %turn_cost = steps2turn*(sim(netE,[1 0.075 0.075 grad_now 15]')+sim(netE,[0 0.075 0.075 grad_now 15]'));
            dis2go = prec*norm([com_now z_now] - [com_goal goal(3)/prec] );
            steps2go = floor(dis2go/sl_max);
            turn_cost = 0;
            if Eflag==1
                out1(k,17) = hE*(steps2go*sim(netE,[1 sl_max sl_max grad_now 0]')+turn_cost);
            else
                out1(k,17) = hP*prec*norm(com_now-com_goal);% + abs(theta_goal-theta_here)/norm(com_now-com_goal);
            end
            out1(k,18) = out1(k,16)+out1(k,17);
        end
        if gscore>=10e4 || (i==1 && j==1)
            k = k-1;
        end
    end
end
out1 = out1(1:k,:);
k=0;
for j=2:5
    k = k +1;
    turn_angle = turn_angles(j);
    
    if sl_turn>=0.025 && sl_turn<=0.1
        sl = [sl_turn sl_turn];
        [Xf_left, Xf_right, gscore] = get_state(A(1:6), A(7:12), sl, turn_angle);
    else
        sl = [0 0];
        Xf_left = zeros(1,6);
        Xf_right = Xf_left;
        gscore = 10e9;
    end
    if gscore<10e4
        out2(k,1:12) = [Xf_left Xf_right];
        out2(k,13:15) = [sl turn_angle];
        
        out2(k,16) = gscore + A(16);
        com_now = get_com(out2(k,:));
        z_now = Map(max(1,com_now(1)), max(1,com_now(2)));
        dis2go = prec*norm([com_now z_now]  - [com_goal goal(3)/prec]);
        steps2go = floor(dis2go/sl_max);
        %grad_now = (goal(3) -0.5*(out1(3)+out1(9)))/(prec*norm(com_now-com_goal));
        grad_now = (goal(3) - prec*z_now)/(prec*norm(com_now-com_goal));
        grad_now = atand(grad_now);
        
        %angle1 = atan2d(com_goal(2)-com_now(2),com_goal(1)-com_now(1));
        %angle2 = (out2(k,6)+out2(k,12))/2;
        %delta_angle = mod(abs(angle1-angle2),360);
        %steps2turn = delta_angle/15;
        %turn_cost = steps2turn*(sim(netE,[1 0.075 0.075 grad_now 15]')+sim(netE,[0 0.075 0.075 grad_now 15]'));
        %turn_cost = delta_angle*pi/180;
        turn_cost = 0;
        if Eflag==1
            out2(k,17) = hE*(steps2go*sim(netE,[1 sl_max sl_max grad_now 0]')+turn_cost);
        else
            out2(k,17) = hP*prec*norm(com_now-com_goal);% + abs(theta_goal-theta_here)/norm(com_now-com_goal);
        end
        
        out2(k,18) = out2(k,16)+out2(k,17);
    end
    if gscore>=10e4
        k = k-1;
    end
end
out2 = out2(1:k,:);
out = [out1;out2];
end