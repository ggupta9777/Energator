function [n,step_length,step_height,step_angles,f] = motion_gen(nnet, Xi_left,Xi_mh,Xi_right,sl_pref)

%assuming no turn! 
sl_max = 0.240;
a = terrain();

l_foot = 0.11;

Tl = euler1(Xi_left(1:3),Xi_left(4),Xi_left(5),Xi_left(6));
xir_lf = local_frame(Xi_right,Tl);

if xir_lf(1)<=0
    n=1;
else
    n=0;
end

sl1 = abs(xir_lf(1));       %this needs to be looked at again

if n==0
    T = euler1(Xi_right(1:3),Xi_right(4),Xi_right(5),Xi_right(6));
    T_swingi = euler1(Xi_left(1:3),Xi_left(4),Xi_left(5),Xi_left(6));
    m = -Xi_right(5);
else
    T = euler1(Xi_left(1:3),Xi_left(4),Xi_left(5),Xi_left(6));
    T_swingi = euler1(Xi_right(1:3),Xi_right(4),Xi_right(5),Xi_right(6));
    m = -Xi_left(5);
end

%the followig line of code permits movement in ONLY forward direction
ix = find(a(1,:)>T(1,4),1);

if abs(a(2,ix))-90==0
    T_cr = euler1([a(1,ix+1);0;a(3,ix+1)],0,-atand(a(2,ix+1)),0);
    indx = ix+1;
else
    T_cr = euler1([a(1,ix);0;a(3,ix)],0,-atand(a(2,ix)),0);
    indx = ix;
end

pt_cr = [a(1,indx);0;a(3,indx)];
pt_cr_local = T\([pt_cr;1]);

if pt_cr_local(1)>=(sl_pref+l_foot)/2    
    swingf = T*[sl_pref/2;0;0;1];
    sl2 = sl_pref/2;
    pos_final = [swingf(1);asind(T(1,3));swingf(3)];
elseif sl_max/2 >= pt_cr_local(1)+l_foot/2    
    swingf = T_cr*[sl_max/2 - pt_cr_local(1);0;0;1];
    pos_final = [swingf(1);asind(T_cr(1,3));swingf(3)];
    sl2 = sl_max - sl1;
else    
    swingf = T*[pt_cr_local(1)-l_foot/2;0;0;1];
    pos_final = [swingf(1);asind(T(1,3));swingf(3)]; 
    sl2 = pt_cr_local(1)-l_foot/2-sl1;
end

step_length = pos_final(1) - T_swingi(1,4);
step_height = pos_final(3) - T_swingi(3,4);
step_angle = (pos_final(2) - (asind(T_swingi(1,3))));
step_angles = [0;step_angle;0];

features = norm_data([n;sl1;sl2;m;0]')';
%f = svr_predict(features);
f = sim(nnet,features);
 f = revnorm_data(f');
end
%f = select_params([l1 l2 h1 h2 Ncr1 Ncr2 M],Xi_left, Xi_mh, Xi_right,n,step_length,step_height,step_angles);
