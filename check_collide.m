function out = check_collide(P,a)
ix = find(a(1,:)>P(1),1);
m = a(2,ix-1);
x1 = a(1,ix-1);
z1 = a(3,ix-1);
c = z1-m*x1;
sign1 = m*x1+c +1;
sign2 = m*P(1)+c -P(2);
if abs(sign2)<=0.001
    out =0;
    return;
end
if sign1*sign2<=0
    out= 0;
else
    out =1;
end
end