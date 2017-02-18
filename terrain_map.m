function B = terrain_map()
close all;
tic
xmin = 0;
xmax = 4;
ymin = 0;
ymax = 4;
acc = 0.04;
X = xmin:acc:xmax;
Y = ymin:acc:ymax;
Xdata = ones(size(Y,2),1)*X;
Ydata = ones(size(X,2),1)*Y;
Ydata = Ydata';
Zdata = zeros(size(Xdata));

%range of obstacle
r_obs = round(0.2/acc);
r_grad = round(0.1*xmax/acc);
r = max(r_obs,r_grad);
%RAMP
x1 = 0.2*xmax/acc;   x2 = 0.3*xmax/acc;   x3 = 0.5*xmax/acc;   x4 =0.6*xmax/acc;    y1 = 0.3*ymax/acc;   y2 = 0.5*ymax/acc;   h1 =0;  h2=0.05;  h3 = 0;
Zdata = create_ramp(Zdata,x1,x2,y1,y2,h1,h2);
Zdata = create_ramp(Zdata,x2,x3,y1,y2,h2,h2);
Zdata = create_ramp(Zdata,x3,x4,y1,y2,h2,h3);

%Obstacle 1
x1 = 0.4*xmax/acc;   x2 = 0.5*xmax/acc;   y1 = 0.65*ymax/acc;    y2=0.85*ymax/acc;  h1 = 0.1;   h2 =0.1;
Zdata = create_ramp(Zdata,x1,x2,y1,y2,h1,h2);

%goal
x1 = 0.65*xmax/acc;  y1=0.4*ymax/acc;
goal = [x1 y1];
grad1 = gradient(Zdata);            grad2 = gradient(Zdata')';          grad = sqrt(grad1.^2+grad2.^2);
m = size(grad,1);                   n = size(grad,2);
U_rep = zeros(size(grad));      U_grad = U_rep;       U_att = U_rep;
eta_rep =1;                     rho_0 =sqrt(2*r_obs^2);         eps_att = 0.25;     eta_grad = 5;   rho_g = sqrt(2*r_grad^2);

for i=1:m
    for j=1:n
        for k=-r:r              %can improve computation using symmetry later on
            for l=-r:r
                if  i+k>0 && i+k<=m && j+l>0 && j+l<=n && k~=0 && l~=0
                    rho = norm([k l]);                    
                    if grad(i,j)>0.2*acc && rho < rho_0
                        U_rep(i+k,j+l) = max(U_rep(i+k,j+l),0.5*eta_rep*(1/rho - 1/rho_0)^2);
                    elseif grad(i,j)<=0.2*acc && grad(i,j)>0 && rho < rho_g
                        U_grad(i+k,j+l) = max(U_grad(i+k,j+l),eta_grad*grad(i,j)*exp(-norm(rho-rho_0)));
                    end
                end                
            end
        end
        U_att(i,j) = 0.5*eps_att*acc^2*norm(goal - [j i])^2;
    end
end
toc
%axis([xmin xmax ymin ymax -0.1 0.3]);
f1= figure;
view(45,45)
hold all;
surf(X,Y,U_att+U_rep);
line(acc*[x1 x1],acc*[y1 y1 ],[-0.2 2]);

f2 = figure;
view(45,45)
hold all;
surf(X,Y,Zdata);
line(acc*[x1 x1],acc*[y1 y1 ],[-0.2 0.5]);
end