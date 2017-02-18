    function draw_axis(A)
    drawArrow = @(x,y,clr) quiver3( x(1),x(2),x(3),y(1)-x(1),y(2)-x(2),y(3)-x(3),1,'MaxHeadSize',0.5,'linewidth',1.5,'color',clr );
        a = A(1:3,4);
        p = A*[0.05 0 0 0; 0 0.05 0 0; 0 0 0.05 0; 0 0 0 1];
        p1 = A*[0.05;0;0;1];
        p2 = A*[0;0.05;0;1];
        p3 = A*[0;0;0.05;1];
        p1 = p1(1:3);
        p2 = p2(1:3);
        p3 = p3(1:3);
%         drawArrow(a,p1,'r');
%         drawArrow(a,p3,'b');
        for i=1:3
            line([a(1) p(1,1)],[a(2) p(2,1)],[a(3) p(3,1)],'color','r','linewidth',1.5);
            line([a(1) p(1,2)],[a(2) p(2,2)],[a(3) p(3,2)],'color','y','linewidth',1.5);
            line([a(1) p(1,3)],[a(2) p(2,3)],[a(3) p(3,3)],'color','b','linewidth',1.5);
        end
    end