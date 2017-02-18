function [TR1, TR2, TR3] = h_trans(theta,sf)
[~,l]=params();
l = [0 0 l(2) l(3) 0 0 l(4) 0 0 l(5) l(6) 0];
TR1 = zeros(4,4,12);
TR2 = TR1;
TR3 = TR2;

TR1(:,:,1) = trans(0, l(1),0,theta(1));
TR1(:,:,2) = trans(-90, l(2),0,theta(2));
TR1(:,:,3) = trans(0, l(3),0,theta(3));
TR1(:,:,4) = trans(0, l(4),0,theta(4));
TR1(:,:,5) = trans(90, l(5),0,90+theta(5));
TR1(:,:,6) = trans(90, l(6),0,theta(6));
if sf==0
    TR1(:,:,7) = trans(0, -l(7),0,theta(7));
else
    TR1(:,:,7) = trans(0, l(7),0,theta(7));
end
TR1(:,:,8) = trans(-90, l(8),0,90+theta(8));
TR1(:,:,9) = trans(90, l(9),0,theta(9));
TR1(:,:,10) = trans(0, l(10),0,theta(10));
TR1(:,:,11) = trans(0, l(11),0,theta(11));
TR1(:,:,12) = trans(-90, l(12),0,theta(12));


TR2(:,:,1) = trans_dot(0, theta(1));
TR2(:,:,2) = trans_dot(-90,theta(2));
TR2(:,:,3) = trans_dot(0,theta(3));
TR2(:,:,4) = trans_dot(0,theta(4));
TR2(:,:,5) = trans_dot(90,90+theta(5));
TR2(:,:,6) = trans_dot(90,theta(6));
if sf==0
    TR2(:,:,7) = trans_dot(0,theta(7));
else
    TR2(:,:,7) = trans_dot(0,theta(7));
end
TR2(:,:,8) = trans_dot(-90,90+theta(8));
TR2(:,:,9) = trans_dot(90,theta(9));
TR2(:,:,10) = trans_dot(0, theta(10));
TR2(:,:,11) = trans_dot(0,theta(11));
TR2(:,:,12) = trans_dot(-90,theta(12));


TR3(:,:,1) = trans_dotdot(0, theta(1));
TR3(:,:,2) = trans_dotdot(-90,theta(2));
TR3(:,:,3) = trans_dotdot(0,theta(3));
TR3(:,:,4) = trans_dotdot(0,theta(4));
TR3(:,:,5) = trans_dotdot(90,90+theta(5));
TR3(:,:,6) = trans_dotdot(90,theta(6));
if sf==0
    TR3(:,:,7) = trans_dotdot(0,theta(7));
else
    TR3(:,:,7) = trans_dotdot(0,theta(7));
end
TR3(:,:,8) = trans_dotdot(-90,90+theta(8));
TR3(:,:,9) = trans_dotdot(90,theta(9));
TR3(:,:,10) = trans_dotdot(0, theta(10));
TR3(:,:,11) = trans_dotdot(0,theta(11));
TR3(:,:,12) = trans_dotdot(-90,theta(12));