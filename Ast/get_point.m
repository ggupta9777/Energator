function [m_out,z_out] = get_point(x,y)
global Map Map_gradx prec
x = round(x/prec);
y = round(y/prec);
if y <1
    y =1;
end
if x <1
    x =1;
end

x = min(x,size(Map,1));
y = min(y,size(Map,2));
m_out = Map_gradx(x,y);
z_out = Map(x,y)*prec;
end
