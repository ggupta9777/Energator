function out = terrain()

% fileID = fopen('terrain_data.txt','r');
% sizeA = [3 Inf];
% formatSpec = '%f %f %f';
% a = fscanf(fileID,formatSpec,sizeA);
% fclose(fileID);
B = [0 0.4 0.8 1.1 1.3 1.7 2.5;
     0 -4 -10 -4 3 0 0;
     0 0 0 0 0 0 0];
 B(2,:)= tand(B(2,:));
a = B;
z = zeros(1,size(a,2));
for i=1:size(a,2)-1
    if a(2,i)==90 || a(2,i)==-90
        z(i+1) = z(i) + a(3,i);
    else
        z(i+1) = z(i) + a(2,i)*(a(1,i+1)-a(1,i));
    end
end
a(3,:) = z;
out = a;
end
