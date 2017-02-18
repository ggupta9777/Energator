function data_out = revnorm_data(data_in)
global ytrain_min ytrain_range
n = size(data_in,2);
m = size(data_in,1);

data_out = data_in.*ytrain_range + ytrain_min;
% for i=1:m
%     for j = 1:n
%     data_out(i,j) = data_in(i,j)*(max(data_in(:,j)) - min(data_in(:,j)))+  min(data_in(:,j));
%     end
% end

end