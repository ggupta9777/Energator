function data_out = norm_data(data_in)
global xtrain_min xtrain_range
n = size(data_in,2);
m = size(data_in,1);
data_out = zeros(size(data_in));
data_out = (data_in - xtrain_min)./xtrain_range; 
% for i=1:m
%     for j = 1:n
%     data_out(i,j) = (data_in(i,j) - min(data_in(:,j)))/(max(data_in(:,j)) - min(data_in(:,j)));
%     end
% end

end