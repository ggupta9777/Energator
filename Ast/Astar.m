function Astar()
%close all;
%add the cost better and use better heuristic
cmap = [1 1 1; ...
    0 0 0; ...
    0 1 0; ...
    1 0 0; ...
    0 0 1; ...
    1 1 0;...
    1 0 1;...
    0 1 1];

%close all;
global Map Map_gradx Map_grady Map_grad2x prec CMap netE Emax sl_max Eflag hE hP net_params xmax ymax balance_matrix
balance_matrix = zeros(6,1);
hE0 = 1.15;
hP0 = 1.02;
hE = hE0;
hP = hP0;
Eflag = 0;
sl_max = 0.111;
%netE = importdata('netEastar.mat');
netE = importdata('netEnergyFinal.mat');
%net_params = importdata('net_paramsnew.mat');
net_params = importdata('netParamsFinal.mat');
prec = 0.005;
xmax = 3;
ymax = 3;
[Map, Map_gradx, Map_grady, Map_grad2x] = get_Map(xmax,ymax, prec);
% surf(Map','edgecolor','none');
% return;
%view(0,0);
tic
CMap = Cspace(Map, Map_gradx, Map_grady, Map_grad2x);
%CMap = importdata('Cmapditch.mat');
% image(5*abs(CMap'));
% set(gca,'YDir','normal');
toc
xrange = round(xmax/prec);
yrange = round(ymax/prec);

eps = 1/(50*prec);            %tolerance for reaching the goal
%in the form of [Xi_left,Xi_right, gscore, hscore, fscore]
lt = 0.085;

xs1 = 0.25;  ys1 = 0.75;  xs2 = xs1;    ys2 = ys1-lt;     xg = 2.2;   yg =2.5;
start = [xs1 ys1 0 0 0 0 xs2 ys2 0 0 0 0 0 0 0 0 Inf Inf];

OS = start;
com = get_com(OS);
goal = [xg yg 0 0 0 0 xg yg 0 0 0 0 0 0 0 Inf Inf Inf];
goal(3) = prec*Map(round(xg/prec),round(yg/prec));
com_goal = get_com(goal);

Emax = sim(netE,[1 sl_max sl_max 0 0]');

closed_set = zeros(xrange,yrange);
open_set = closed_set;
fscore = Inf(xrange,yrange);


OS(5) = -atand(Map_gradx(com(1),com(2)));
OS(11) = OS(5);

%  disp(OS);
%  return;

open_set(com(1),com(2)) = 1;

if Eflag==1
    grad_now = (goal(3) -prec*Map(com(1),com(2)))/(prec*norm(com-com_goal));
    grad_now = atand(grad_now);
    z_now = Map(max(1,com(1)), max(1,com(2)));
    dis2go = prec*norm([com z_now]  - [com_goal goal(3)/prec]);
    angle1 = atan2d(com_goal(2)-com(2),com_goal(1)-com(1));
    angle2 = (start(1,6)+start(1,12))/2;
    delta_angle = mod(abs(angle1-angle2),360);
    steps2turn = delta_angle/15;
    steps2go = floor(dis2go/sl_max);
    
    turn_cost = steps2turn*(sim(netE,[1 0.075 0.075 grad_now 15]')+sim(netE,[0 0.075 0.075 grad_now 15]'));
    turn_cost = 0;
    fscore(com(1),com(2)) = hE*(steps2go*sim(netE,[1 sl_max sl_max grad_now 0]')+turn_cost);
else
    fscore(com(1),com(2)) = hP*prec*norm(com - get_com(goal));
end

OS(1,end) = fscore(com(1),com(2));
parent = zeros(xrange,yrange);
parent_action = zeros(xrange,yrange,3);
count = 1;

tic
f1 = figure;
count = 0;
while(size(OS,1)~=0)

    [~, ind_min] = min(OS(:,end));            %look for smallest f values in OS
    current = OS(ind_min,:);                      %current node
    if norm(get_com(current)-get_com(goal))<=eps
        goal_new = get_com(current);
        saveas(gcf,'test.pdf');
        break;
    else
        X = get_com(current);
        xc = X(1);
        yc = X(2);
        open_set(xc,yc) = 0;                 %remove ind_min from OS and open_set
        OS(ind_min,:) = [];
        closed_set(xc,yc) = 1;               %add the visited node to closed_set
        neighbours = gen_nodes(current, goal);
        [OS, open_set, fscore, parent, parent_action] = add2open(OS, open_set, closed_set, fscore, neighbours, current, parent, parent_action);
        count = count+1;
        colormap1 = 4*closed_set + 3*open_set;
        colormap1(round(xg/prec)-10:round(xg/prec)+10,round(yg/prec)-10:round(yg/prec)+10) = 5;
        colormap1(com(1)-10:com(1)+10,com(2)-10:com(2)+10) = 6;
        colormap1 = colormap1+ abs(CMap)+1;
        image(colormap1');
        colormap(cmap);
        set(gca,'YDir','normal');
        pause(0.0001);
    end
end
close(f1);
dest_node = goal_new(1:2);
dest_node = sub2ind([xrange,yrange],dest_node(1),dest_node(2));
pa = [0 0 0]';
route = [dest_node];

while (parent(route(1)) ~= 0)
    route = [parent(route(1)), route];
end
R = zeros(size(route,2),2);
for i=1:size(route,2)
    [m,n] = ind2sub([xrange,yrange],route(i));
    pa = [pa [parent_action(m,n,1);parent_action(m,n,2);parent_action(m,n,3)] ];
    CMap(m-5:m+5,n-5:n+5) = 3;
    R(i,:) = [m n];
end
% image(20*abs(CMap)');
% set(gca,'YDir','normal');
% figure;
% hold all;
% axis([0 xrange 0 yrange]);
%surf(prec*[1:xrange],prec*[1:yrange],prec*Map','EdgeColor','none');
%scatter(R(:,1),R(:,2));
%image(Map');
toc
pa = pa(:,3:end);
pa'
%save('actionsditch','pa');
plot_steps(start(1:6),start(7:12),pa');
end
