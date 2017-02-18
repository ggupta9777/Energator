function out = local_frame(A, T)

its = size(A,2);
out = zeros(size(A));
for i=1:its
    a = [A(1:3,i);1];
    a = T\a;
    a = a(1:3);
    out(:,i) = [a;A(4:6,i)];
end
end
