function out = traj_gen(T,X)
n = size(X,2);
A = zeros(n+4,n+4);
P = [X zeros(1,4)]';
for i=1:n+4
    for j=1:n+4
        if i<=n
            A(i,j) = T(i)^(n+4-j);
        end
        if i==n+1
            A(i,j) = (n+4-j)*(T(1))^(max(0,n+3-j));
        end
        if i==n+2
            A(i,j) = (n+4-j)*(T(end))^(max(0,n+3-j));
        end
        if i==n+3
            
            A(i,j) = (n+4-j)*(n+3-j)*(T(1))^(max(0,n+2-j));
        end
        if i==n+4
            A(i,j) = (n+4-j)*(n+3-j)*(T(end))^(max(0,n+2-j));
        end
    end
end

A = A\P;
t = T(1):T(end);
t = t';
m = size(t,1);
time = zeros(m,n+4);
for i=1:n+4
    time(:,i) = t.^(n+4-i);
end
out = time*A;
out=out';
end