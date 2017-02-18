function flag = zmp_test(pos_zmp, poly_zmp,i,n)

if i>n/10 && i<9*n/10
    flag = inpolygon(pos_zmp(1),pos_zmp(2),poly_zmp(1,:),poly_zmp(2,:));
else
    flag = 1;
end
end