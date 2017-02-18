function [out1,out2] = normalize_data(X,Y)
out1 = X;
out2 = Y;
%m = size(X,1);
n = size(X,2);
o = size(Y,2);
maxVals1 = zeros(1,n);
minVals1 = zeros(1,n);
maxVals2 = zeros(1,o);
minVals2 = zeros(1,o);
for i=1:n
    maxVals1(i) = max(X(:,i));
    minVals1(i) = min(X(:,i));
    out1(:,i) = (out1(:,i)-minVals1(i))/(maxVals1(i)-minVals1(i));
end
for i=1:o
    maxVals2(i) = max(Y(:,i));
    minVals2(i) = min(Y(:,i));
    out2(:,i) = (out2(:,i)-minVals2(i))/(maxVals2(i)-minVals2(i));
end
end