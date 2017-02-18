function threedwalk(Xi_left, Xi_right,actions)
close all;
%% Learning Data is loaded here
global ytrain_min ytrain_range xtrain_range xtrain_min xtrain ytrain mdl1 mdl2 mdl3 mdl4 mdl5 mdl6 mdl7 mdl8 nnet net_params prec Map Map_gradx Map_grady LR_params1 LR_params2 LR_params3 LR_params4 LR_params5 LR_params6 LR_params7 LR_params8

LR_params1 = importdata('LR_params1.mat');
LR_params2 = importdata('LR_params2.mat');
LR_params3 = importdata('LR_params3.mat');
LR_params4 = importdata('LR_params4.mat');
LR_params5 = importdata('LR_params5.mat');
LR_params6 = importdata('LR_params6.mat');
LR_params7 = importdata('LR_params7.mat');
LR_params8 = importdata('LR_params8.mat');

mdl1 = importdata('svr_params_gauss1.mat');
mdl2 = importdata('svr_params_gauss2.mat');
mdl3 = importdata('svr_params_gauss3.mat');
mdl4 = importdata('svr_params_gauss4.mat');
mdl5 = importdata('svr_params_gauss5.mat');
mdl6 = importdata('svr_params_gauss6.mat');
mdl7 = importdata('svr_params_gauss7.mat');
mdl8 = importdata('svr_params_gauss8.mat');
nnet = importdata('TrainedNet.mat');
%net_params = importdata('net_paramsnew.mat');
net_params = importdata('netParamsFinal.mat');
%% Walking and Figure Parameters set
prec = 0.005;
xmax = 4;
ymax = 4;
[Map, Map_gradx, Map_grady, ~] = get_Map(xmax,ymax, prec);
%Map = Map*prec;
sl = [actions(:,1) actions(:,2)]';
sl = sl(:);
turn_angles = ([actions(:,3) actions(:,3)]');
turn_angles = turn_angles(:);
N = size(sl,1);
% %% Figure Properties are set and a figure is created
% close all;
% 
 %fg = figure(1);
% 
% %surf(prec:prec:xmax,prec:prec:ymax,prec*Map','EdgeColor','none');
% %colormap summer;
% hold all;
% %title('ZMP')
% xlabel('X  (m)');
% ylabel('Y  (m)');
% 
fh=figure(1);
hold all;
set(fh,'Renderer','zbuffer');
set(gcf,'units','normalized','outerposition',[0 0 1 1]);
%axis([0 1.8 0 1 -0.3 0.3]);
axis([0 xmax 0 ymax prec*min(min(Map))-0.1 prec*max(max(Map))+0.2]);
view(-180,45);
surf(prec:prec:xmax,prec:prec:ymax,prec*Map','EdgeColor','none');
surf(prec:prec:xmax,prec:prec:ymax,prec*Map'-0.01);
colormap summer;

%title('Biped : Uneven Terrain');
xlabel('X component') % x-axis label
ylabel('Y component') % y-axis label
zlabel('Z component') % y-axis label
view(30,60);
global writerObj
writerObj = VideoWriter('resultxyz.avi');
open(writerObj);

%% Initialization
[~,l] = params();
l = [0 0 l(2) l(3) 0 0 l(4) 0 0 l(5) l(6) 0];
Xi_left = Xi_left';
Xi_right = Xi_right';
Xi_mh(1:2) = (Xi_left(1:2)+Xi_right(1:2))/2;
Xi_mh(3) = min(Xi_right(3),Xi_left(3))+ 0.9*(l(3)+l(4));
Xi_mh = Xi_mh';
W = zeros(1,N+1);
E = 0;

%%Plotting
%%
%
xgoal = [3.5 1.5];
line([xgoal(1) xgoal(1)],[xgoal(2) xgoal(2)],[min(min(Map)) 0.25],'color','r','linewidth',1.5);
line([(Xi_left(1) + Xi_right(1))/2 (Xi_left(1) + Xi_right(1))/2],[(Xi_left(2) + Xi_right(2))/2 (Xi_left(2) + Xi_right(2))/2],[0 0.25],'color','g','linewidth',1.5);

%%
for n=1:N
    sf = mod(n,2);                      %sf = 1 means right foot swings
    turn_angle = turn_angles(n);
    sl2 = sl(n);
    
    [X, ~, X_lfoot, X_rfoot, X_com, X_zmp, Xf_left, Xf_right, Xf_mh,tau, W(n)] = step_states(Xi_left, Xi_right,Xi_mh,sl2, turn_angle, sf);
%         if sf==0
%             tau = tau(end:-1:1,:);
%         end
%        save('Cterm.mat','tau');
%         if n==1
%             taup = tau;
%         else
%             taup = [taup tau];
%         end
    %save('tau.mat','taup');   
    %if n>=3
    fg=1;
    plot_all(X, X_lfoot, X_rfoot, X_com, X_zmp,fg,fh,n);
    %end
    Xi_left = Xf_left;
    Xi_right = Xf_right;
    Xi_mh = Xf_mh;
     E = E + W(n);
     %disp([E n]);
end

close(writerObj);
% figure;
% plot(1:51,taup(2,:));
% figure;
% hold all;
% title('Cumulative Energy Consumption');
% xlabel('Steps');
% ylabel('Energy (Joules)');
% plot(1:n+1,E,'linewidth',1.5);
% figure;
% hold all;
% title('Per-Step Energy Consumption ')
% xlabel('Steps');
% ylabel('Energy (Joules)');
% bar(1:n,W)
end