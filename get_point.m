function [m_out,z_out] = get_point(x,y)
global Map Map_gradx prec
x = round(x/prec);
y = round(y/prec);
m_out = Map_gradx(x,y);
z_out = Map(x,y)*prec;
end
