function Map = create_obs(Map, X,Y,h)

y1 = max(1,round(Y(1)));
y2 = max(1,round(Y(2)));
x1 = max(1,round(X(1)));
x2 = max(1,round(X(2)));
Map(x1:x2,y1:y2) = h;
end