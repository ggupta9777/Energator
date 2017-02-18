function out = zmp(A,B,t_halfstep,its,T,Tswingi,Tswingf,i,td1,td2)

%51 iterations of i are involved in one half step, i.e. 1 second approx.

h = t_halfstep/its;
g = 9.8;
m = B;

x = A(1,:,2);
xn = A(1,:,3);
xp = A(1,:,1);

y = A(2,:,2);
yn = A(2,:,3);
yp = A(2,:,1);

z = A(3,:,2);
zp = A(3,:,1);
zn = A(3,:,3);

xpp = (xn-2*x+xp)/h^2;
xpp = xpp(:);
x = x(:);
ypp = (yn-2*y+yp)/h^2;
ypp = ypp(:);
y = y(:);
zpp = (zn-2*z+zp)/h^2;
zpp = zpp(:);
z = z(:);

if i==1 || i==51
  xpp = zeros(size(A,2),1);
  ypp = xpp;
  zpp = ypp;
end

M = sum(m);
acc = [xpp ypp zpp]';
acc_com = acc*m/M;
pos = [xn(:) yn(:) zn(:)]';
Rgi = M*g*[0;0;-1] - M*acc_com;
fg = g*[0;0;-1]*m';
fi = -acc*diag(m);

function outzmp = localzmp(Tlocal)
pos_ref(:,1) = Tlocal(1,4)*ones(size(A,2),1);
pos_ref(:,2) = Tlocal(2,4)*ones(size(A,2),1);
pos_ref(:,3) = Tlocal(3,4)*ones(size(A,2),1);
pos_ref = pos_ref';
postemp = pos-pos_ref;

Mgi = cross(postemp,fg+fi);
Mgi = sum(Mgi')';
nlocal = Tlocal(1:3,1:3)*[0;0;1];
outzmp = cross(nlocal,Mgi)/(Rgi'*nlocal);
outzmp = outzmp + pos_ref(:,1);
outzmp = outzmp(1:3);
end
if i<=td1
    h = 0.5*(1 - (i-1)/td1);
    out1 = localzmp(Tswingi);
elseif i>=td2
    h = 0.5*(i-td2)/(its-td2);
    out1 = localzmp(Tswingf);
else
    out1 = localzmp(T);
end
    out2 = localzmp(T);

out = h*out1+(1-h)*out2;

%td1 represents only 0.5 of DSP, therefore hmax should be 0.5 and not 1
%same at the other end, make this change.

% n = T(1:3,1:3)*[0;0;1];
% out = cross(n,Mgi)/(Rgi'*n);
%Mgi = cross(pos_com,Rgi);
%out2 = cross(n,Mgi)/(Rgi'*n);
%xzmp = (g*x'*m -(m'*(z.*xpp - x.*zpp)))/(M*g + m'*zpp);
%yzmp = (g*y'*m +(m'*(y.*zpp - z.*ypp)))/(M*g + m'*zpp);
%zzmp = 0;
%[out [xzmp;yzmp;zzmp]]
%out = [xzmp;yzmp;zzmp];
end