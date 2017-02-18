function [gscore,gscore2] = eval_score(Xi_left, Xi_right, Xf_left, Xf_right, T_swingf,sl1,sl2,sf,terrain_theta,turn_angle)
global prec Map CMap netE
lf = 0.11;
wf = 0.07;
if sf==1
    terrain_theta = atand(tand(terrain_theta)*cosd(Xi_left(6)));
else
    terrain_theta = atand(tand(terrain_theta)*cosd(Xi_right(6)));
end

com_move = norm(get_com([Xi_left' Xi_right']) - get_com([Xf_left' Xf_right']));
    function flag = critical_check()
        p1 = round(T_swingf*[lf/2;wf/2;0;1]/prec);
        p2 = round(T_swingf*[lf/2;-wf/2;0;1]/prec);
        p3 = round(T_swingf*[-lf/2;-wf/2;0;1]/prec);
        p4 = round(T_swingf*[-lf/2;wf/2;0;1]/prec);
        
        p1z = Map(p1(1),p1(2));
        p2z = Map(p2(1),p2(2));
        p3z = Map(p3(1),p3(2));
        p4z = Map(p4(1),p4(2));
        
        if p1(3)-p1z >= 0.01 || p2(3)-p2z >= 0.01 || abs(p3(3)-p3z) >= 0.01 || abs(p4(3)-p4z) >= 0.01
            flag=1;
        else
            flag=0;
        end
        
    end

% xl = round(Xf_left(1:2)/prec);
% xr = round(Xf_right(1:2)/prec);
% mp = (Xf_left(1:2)+Xf_right(1:2))/2;
% mp = round(mp/prec);
    gscore2 =  prec*com_move;
    gscore= sim(netE,[sf,sl1,sl2,terrain_theta,turn_angle]');
    

% if CMap(mp(1),mp(2))==-1
%     gscore = 10e6;
%     return;
% elseif CMap(xl(1),xl(2))==-2 || CMap(xr(1),xr(2))==-2
%     flag = critical_check();
%     if flag==1;
%         gscore = 10e5;
%     else
%         gscore2 =  prec*com_move;
%         gscore = sim(netE,[sf,sl1,sl2,terrain_theta,turn_angle]');
%     end
%     return;
% else
%     gscore2 =  prec*com_move;
%     gscore= sim(netE,[sf,sl1,sl2,terrain_theta,turn_angle]');
% end
end