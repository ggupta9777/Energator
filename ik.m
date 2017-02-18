function [outp1,outp2,outp3,outp4,flag] = ik(Xlf,Xrf,Xmh)

    function T = trans(alpha,a,d,theta)
        T = [cosd(theta) -sind(theta) 0 a;
            sind(theta)*cosd(alpha) cosd(theta)*cosd(alpha) -sind(alpha) -sind(alpha)*d;
            sind(theta)*sind(alpha) cosd(theta)*sind(alpha) cosd(alpha) cosd(alpha)*d;
            0 0 0 1];
    end

    function T = inv_trans(A)
        T = [A(1:3,1:3)' -A(1:3,1:3)'*A(1:3,4);0 0 0 1];
    end

    function out = ik_knee(a,b)
        d = norm(a(1:3)-b(1:3));
        gamma = acosd((l(4)^2-d^2+l(3)^2)/(2*l(4)*l(3)));
        out = 180-gamma;
    end

l_foot = 0.1+0.01;
w_foot = 0.06+0.01;
[~,l]=params;
h_foot = l(1);
l = [0 0 l(2) l(3) 0 0 l(4) 0 0 l(5) l(6) 0];

xl = Xlf(1);
yl = Xlf(2);
zl = Xlf(3);

xr = Xrf(1);
yr = Xrf(2);
zr = Xrf(3);

xh = Xmh(1);%(x1+x2)/2;
yh = Xmh(2);%(y1+y2)/2;
zh = Xmh(3);%0.9*(l(4)+l(3));

phi_left = Xlf(4);
phi_right = Xrf(4);
theta_left = Xlf(5);   %terrain
theta_right = Xrf(5);    %terrain
psi_left = Xlf(6);     %terrain, to be used in extended 2D
psi_right = Xrf(6);     %terrain, to be used in extended 2D
%inverse kinematics
Tl = euler1([xl;yl;zl],phi_left, theta_left,psi_left)*[0 0 1 0; 0 -1 0 0; 1 0 0 0; 0 0 0 1];
%euler is euler angle transformation, second one aligns eulerX with local Z
%and eulerZ with localX for TR00,TR12
Tr = euler1([xr;yr;zr],phi_right, theta_right,psi_right)*[0 0 1 0; 0 -1 0 0;1 0 0 0;0 0 0 1];
aj_left = Tl*[h_foot;0;0;1];
aj_right = Tr*[h_foot;0;0;1];

dir_left = Tl(1:3,1:3)*[0;0;1];   %z direction of ankle_left
dir_left = dir_left(1:2);
% ang1 = atan2d(dir_left(2),dir_left(1));
% if ang1<0
%     ang1 = ang1+360;
% end
dir_right = Tr(1:3,1:3)*[0;0;1];   %z direction of ankle_right
% ang2 = atan2d(dir_right(2),dir_right(1));
% if ang2<0
%     ang2 = ang2 + 360;
% end
%mean of circular angles here
ang = atan2d((dir_left(2)+dir_right(2))/2,(dir_left(1)+dir_right(1))/2);
%ang = (mod(ang2+ang1,360))/2;
hj_left = trans(0,0,0,ang)*[0;l(7)/2;0;1] + [xh;yh;zh;0];
hj_right = trans(0,0,0,ang)*[0;-l(7)/2;0;1] + [xh;yh;zh;0];
hj_theta = atan2d(hj_right(2)-hj_left(2),hj_right(1)-hj_left(1));
    function [out1,out2] = get_theta(TR00,aj,hj)

        theta = zeros(6,1);
        %inverse kinematics to get knee positions
        T = TR00*trans(0,h_foot,0,0);   %moving the coordinate frame to ankle joint, was previously at the sole
        hj_local = inv_trans(T)*hj;
        theta(1) = atan2d(hj_local(2),hj_local(1));
        theta(3) = ik_knee(aj,hj);
        T = T*trans(0,l(1),0,theta(1));
        hj_local = inv_trans(T)*hj;
        circle2 = [hj_local(1) hj_local(3) l(4)];
        circle1 = [0 0 l(3)];
        pts = intersectCircles(circle1, circle2);
        if pts(2,1)>=pts(2,2)
            kj_local = [pts(1,1);0;pts(2,1);1];
        else
            kj_local = [pts(1,2);0;pts(2,2);1];
        end
        flag =  isreal(kj_local);
        if flag==0
            out1 = zeros(6,1);
            out2 = zeros(4,3);
            return
        end
        theta(2) = atan2d(-kj_local(3),kj_local(1));
        
        kj = T*kj_local;
        T = T*trans(-90, l(2),0,theta(2))*trans(0, l(3),0,theta(3));
        rot_m = [cosd(hj_theta) -sind(hj_theta) 0; sind(hj_theta) cosd(hj_theta) 0; 0 0 1];
        T_hj = [rot_m hj(1:3);0 0 0 1];
        T_local = inv_trans(T)*T_hj;
        theta(5) = asind(T_local(3,3));
        if cosd(theta(5))~=0
            st4 = T_local(2,3);
            ct4 = T_local(1,3);
            theta(4) = atan2d(st4/cosd(theta(5)),ct4/cosd(theta(5)));
            theta(6) = acosd(T_local(3,1)) - theta(5);
            %theta(6) = acosd(T_local(3,1)/cosd(theta(5)));            
            %theta(4) = acosd(T_local(1,3)/cosd(theta(5)));
        else
            theta(6) = 0;
            theta(4) = asind(T_local(1,2));
        end
        theta(4) = -(theta(2)+theta(3));
        %theta(5) = -theta(1);
        out1 = theta;
        out2 = [aj kj hj];
        %T = T*trans(0, l(4),0,theta(4))*trans(90, l(5),0,90+theta(5))*trans(90, l(6),0,theta(6));
    end


[out1,out2] = get_theta(Tl,aj_left,hj_left);
jointangles = out1;
joints = out2;
[out1,out2] = get_theta(Tr,aj_right,hj_right);
out1 = out1(end:-1:1);
jointangles = [jointangles; out1];
joints = [joints out2(:,end:-1:1)];
%joint angles are reported from la-lk-lh-rh-rk-ra

f_left(:,1) = Tl*[0;0;0;1];
f_left(:,2)= Tl*[0;w_foot/2;l_foot/2;1];
f_left(:,3) = Tl*[0;w_foot/2;-l_foot/2;1];
f_left(:,4) = Tl*[0;-w_foot/2;-l_foot/2;1];
f_left(:,5) = Tl*[0;-w_foot/2;l_foot/2;1];

f_right(:,1) = Tr*[0;0;0;1];
f_right(:,2)= Tr*[0;w_foot/2;l_foot/2;1];
f_right(:,3) = Tr*[0;w_foot/2;-l_foot/2;1];
f_right(:,4) = Tr*[0;-w_foot/2;-l_foot/2;1];
f_right(:,5) = Tr*[0;-w_foot/2;l_foot/2;1];

outp1 = jointangles;
outp2 = joints(1:3,:);
outp3 = f_left(1:3,:);
outp4 = f_right(1:3,:);
end

% TR = zeros(4,4,12);
% TR(:,:,1) = trans(0, l(1),0,theta(1));
% TR(:,:,2) = trans(-90, l(2),0,theta(2));
% TR(:,:,3) = trans(0, l(3),0,theta(3));
% TR(:,:,4) = trans(0, l(4),0,theta(4));
% TR(:,:,5) = trans(90, l(5),0,90+theta(5));
% TR(:,:,6) = trans(90, l(6),0,theta(6));
% TR(:,:,7) = trans(0, l(7),0,180+theta(7));
% TR(:,:,8) = trans(90, l(8),0,-90+theta(8));
% TR(:,:,9) = trans(90, l(9),0,theta(9));
% TR(:,:,10) = trans(0, l(10),0,theta(10));
% TR(:,:,11) = trans(0, l(11),0,theta(11));
% TR(:,:,12) = trans(-90, l(12),0,theta(12));
