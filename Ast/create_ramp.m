function Map = create_ramp(Map, X,Y,Z)

m = size(X,2);
y1 = round(Y(1));
y2 = round(Y(2));
if y1<1
    y1 = 1;
end
if X(1)<1
    X(1) = 1;
end
for i=1:m-1
    x1 = round(X(i));
    x2 = round(X(i+1));
    h1 = round(Z(i));
    h2 = round(Z(i+1));
    slope = (h2-h1)/(x2-x1);
    xrange = (0:x2-x1)';
    Map(x1:x2,y1:y2) =  h1+xrange*slope*ones(1,y2-y1+1);
end
end