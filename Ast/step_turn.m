function [out,flag,terrain_theta] = step_turn(Xi_left, Xi_right,sf,sl2,theta,T,T_swingi)
flag = 0;
[~,l]=params();
a = l(4);
xil = T\[Xi_left(1:3); 1];
xir = T\[Xi_right(1:3); 1];
sl1 = abs(xil(1)-xir(1));
sl_max = 2*sl2;
if theta~=0
    R = abs((sl_max/2)/sind(theta/2));
    r = R - a;
    if R>r+norm(xil-xir)
        flag=1;
    end
    if theta>0
        pts = intersectCircles([xil(1:2)' r],[xir(1:2)' R]);
    else
        pts = intersectCircles([xil(1:2)' R],[xir(1:2)' r]);
    end
    
    if abs(pts(1,1))<abs(pts(1,2))
        C = pts(1:2,1);
    else
        C = pts(1:2,2);
    end
    if sf==0
        temp1 = xil(1:2)-C;
        th1 = atan2d(temp1(2),temp1(1));
        if theta>0
            out = [C;0]+[r*cosd(th1+theta);r*sind(th1+theta);0];
        else
            out = [C;0]+[R*cosd(th1+theta);R*sind(th1+theta);0];
        end
        angles = [Xi_left(4:5); Xi_left(6)+theta];
    else
        temp1 = xir(1:2)-C;
        th1 = atan2d(temp1(2),temp1(1));
        if theta>0
            out = [C;0]+[R*cosd(th1+theta);R*sind(th1+theta);0];
        else
            out = [C;0]+[r*cosd(th1+theta);r*sind(th1+theta);0];
        end
        angles = [Xi_right(4:5); Xi_right(6)+theta];
    end
    out = T*[out;1];
    [terrain_theta, z] = get_point(out(1),out(2));
    angles(2) = -atand(terrain_theta);
    if norm(out(3)-z)>0.001
        flag=1;
    end
    out = [out(1:3);angles];    
    
else
    pos_projected =  T_swingi*[sl1+sl2;0;0;1];
    x = pos_projected(1);
    y = pos_projected(2);
    [terrain_theta, z] = get_point(x,y);
    terrain_theta = atand(terrain_theta);
    if sf==1
        out = [x;y;z;Xi_right(4);-terrain_theta;Xi_right(6)];
    else
        out = [x;y;z;Xi_left(4);-terrain_theta;Xi_left(6)];
    end
end
end