function out = revnormalized_data(yin, ypredict)
out = ypredict;
o = size(yin,2);
maxVals = zeros(1,o);
minVals = zeros(1,o);
for i=1:o
    maxVals(i) = max(yin(:,i));
    minVals(i) = min(yin(:,i));
    out(:,i) = out(:,i)*(maxVals(i)-minVals(i))+minVals(i);
end
end