function [out1,out2] = draw_com(X)
X = [X(:,1:3) (X(:,3)+X(:,4))/2 X(:,4:6)];
mass = params();
out2 = zeros(3,1);
n= size(X,2);
out1 = zeros(3,n);
out1(:,1) = X(1:3,1);
for i=2:n	
  out1(:,i) = X(1:3,i);
  out2 = out2 + out1(:,i)*mass(i);
end
out2 = out2/(sum(mass)-mass(1));
end