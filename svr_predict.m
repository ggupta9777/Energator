function out = svr_predict(feature)
feature = feature';
global mdl1 mdl2 mdl3 mdl4 mdl5 mdl6 mdl7 mdl8
a = predict(mdl1,feature);
b = predict(mdl2,feature);
c = predict(mdl3,feature);
d = predict(mdl4,feature);
e = predict(mdl5,feature);
f = predict(mdl6,feature);
g = predict(mdl7,feature);
h = predict(mdl8,feature);
out = [a b c d e f g h]';
end