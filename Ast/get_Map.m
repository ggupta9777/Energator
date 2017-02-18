function [Map, Map_gradx, Map_grady, Map_grad2x] = get_Map(maxx,maxy, prec)
xrange = maxx/prec;
yrange = maxy/prec; 
Map = zeros(xrange,yrange);
%Map = importdata('Mapditch.mat');
x0 = .001/prec;
x1 = .5/prec;%*xrange;
x2 = 1.0/prec;%*xrange;
x3 = 1.5/prec;%*xrange;
x4 = 2.0/prec;%*xrange;
x5 = 2.50/prec;%*xrange;
x6 = 3.00/prec;%*xrange;

y1 = 0.001/prec;%0.001*yrange;
y2 = 3.0/prec;%1.00*yrange;

h1 = 0;
h2 = -0.04/prec;
h3 = -0.10/prec;
h4 = -0.12/prec;
h5 = -0.10/prec;
h6 = -0.04/prec;
h7 = -0.00/prec;

h = [h1 h2 h3 h4 h5 h6 h7];
x = [x0 x1 x2 x3 x4 x5 x6];
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

