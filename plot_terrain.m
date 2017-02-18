function plot_terrain()
yl= -0.5;
yu = 0.5;
a = terrain();
hold all;
for i=1:size(a,2)-1    
    if abs(a(2,i))==90
        m = 1;
    else
        m = abs(sin(atand(a(2,i))));
    end
    fill3([a(1,i) a(1,i) a(1,i+1) a(1,i+1)],[yl yu yu yl],[a(3,i) a(3,i) a(3,i+1)  a(3,i+1)], 1-8*m*[0.025 0.025 0.025]);   
    line([a(1,i) a(1,i)],[-0.5 0.5],[a(3,i) a(3,i)],'linewidth',1.5);
end
fill3([a(1,:) a(1,end:-1:1)], yl*ones(1,2*size(a,2)),[a(3,:) zeros(1,size(a,2))], 15*[0.025 0.025 0.025]);
fill3([a(1,:) a(1,end:-1:1)], yu*ones(1,2*size(a,2)),[a(3,:) zeros(1,size(a,2))], 15*[0.025 0.025 0.025]);
line([a(1,1) 2],[-0.5 -0.5],[a(3,1) a(3,1)],'linewidth',1.5);
line([a(1,1) 2],[0.5 0.5],[a(3,1) a(3,1)],'linewidth',1.5);
end