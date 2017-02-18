function [Map, Map_gradx, Map_grady, Map_grad2x] = get_Map(maxx,maxy, prec)
xrange = maxx/prec;
yrange = maxy/prec; 
Map = zeros(xrange,yrange);

x1 = 1.25/prec;%*xrange;
x2 = 1.50/prec;%*xrange;
x3 = 1.75/prec;%*xrange;
x4 = 2.00/prec;%*xrange;
x5 = 2.25/prec;
x6 = 2.50*xrange;
x7 = 2.75*xrange;

y1 = 0.6/prec;%0.001*yrange;
y2 = 3.7/prec;%1.00*yrange;

h1 = 0;
h2 = 0.039/prec;
h3 = h2;
h4 = 0;
h5 = -h2;
h6 = -h2;
h7 = 0;
h = [h1 h2 h3 h4];
x = [x1 x2 x3 x4];
Map  = create_ramp(Map, x, [y1 y2], h);

[Map_grady, Map_gradx] = gradient(Map);
Map_gradx(:,[1,2,end-1,end]) = 20;
Map_gradx([1,2,end-1,end],:) = 20;
Map_grady(:,[1,2,end-1,end]) = 20;
Map_grady([1,2,end-1,end],:) = 20;
[~, Map_grad2x] = gradient(Map_gradx);
%  hold all;
%  axis([1 xrange 1 yrange 0 xrange/5]);
 
% view(0,0)
%  surf(1:xrange,1:yrange,Map');
%  colormap summer
end

