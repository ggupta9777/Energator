function out = select_params(feature,Xi_left, Xi_mh, Xi_right,n,step_length,step_height,step_angles)
[B,C]= opt_params();
k = dsearchn(C,feature);
f = B(k,:);
%f = [0.6984 0.9365 0.6825 0.9206 0.4921 0.4603 0.6190 0.2857 0.3810];
%out = fine_search(f,Xi_left, Xi_mh, Xi_right,n,step_length,step_height,step_angles);
out =f;
end