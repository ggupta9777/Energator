function CMap = Cspace(Map, Map_gradx, Map_grady, Map_grad2x)
global prec
prec = 0.005;
[m,n] = size(Map);
CMap = zeros(m,n);
r = ceil(0.125/prec);       %radius of collison
lf = ceil(0.5*0.11/prec);     %for critical points

for i=1:m
    for j=1:n
        if abs(Map_grad2x(i,j))>=0.005        %to identify the critical points
            CMap(max(1,i-lf):min(i+lf,m),max(j-lf,1):min(j+lf,n)) = -2;
        end
    end
end

for i=1:m
    for j=1:n
        
        
        if abs(Map_gradx(i,j))>=0.2   || abs(Map_grady(i,j))>=0.2     %max allowable slope in xdirection
            m1 = max(1,i-r);
            m2 = min(i+r,m);
            n1 = max(j-r,1);
            n2 = min(j+r,n);
            for o=m1:m2
                for p=n1:n2
                    if norm([o p]-[i j])<=r
                        CMap(o,p) = -1;
                    end
                end
            end
            
        end
    end
end

CMap(1:r,:) = -1;
CMap(end-r:end,:) = -1;
CMap(:,1:r) = -1;
CMap(:,end-r:end) = -1;
end


