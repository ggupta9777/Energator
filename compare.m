function compare(in,out)
close all;
%netP = importdata('net_paramsnew.mat');
netP = importdata('netParamsFinal.mat');
%netP = importdata('net_rbf.mat');
mdl1 = importdata('svr_params_gauss1.mat');
mdl2 = importdata('svr_params_gauss2.mat');
mdl3 = importdata('svr_params_gauss3.mat');
mdl4 = importdata('svr_params_gauss4.mat');
mdl5 = importdata('svr_params_gauss5.mat');
mdl6 = importdata('svr_params_gauss6.mat');
mdl7 = importdata('svr_params_gauss7.mat');
mdl8 = importdata('svr_params_gauss8.mat');

LR_params1 = importdata('LR_params1.mat');
LR_params2 = importdata('LR_params2.mat');
LR_params3 = importdata('LR_params3.mat');
LR_params4 = importdata('LR_params4.mat');
LR_params5 = importdata('LR_params5.mat');
LR_params6 = importdata('LR_params6.mat');
LR_params7 = importdata('LR_params7.mat');
LR_params8 = importdata('LR_params8.mat');

    function out = svr_predict(feature)
        feature = feature';
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

    function out = lr_predict(feature)
        feature = feature';
        a = predict(LR_params1,feature);
        b = predict(LR_params2,feature);
        c = predict(LR_params3,feature);
        d = predict(LR_params4,feature);
        e = predict(LR_params5,feature);
        f = predict(LR_params6,feature);
        g = predict(LR_params7,feature);
        h = predict(LR_params8,feature);
        out = [a b c d e f g h]';
    end


m = size(in,1);
%[in_data,~] = normalize_data(in,out);
in_data = in;
data_nn = zeros(size(out));
data_svr = data_nn;
data_lr = data_svr;
n = size(out,2);
means = zeros(1,n);
for i=1:m
    features = (in_data(i,:))';
    featuresnn = (in(i,:))';
    fsvr = svr_predict(featuresnn);
    data_svr(i,:) = fsvr';
    fnn = sim(netP,featuresnn);

    data_nn(i,:) = fnn';
    flr = lr_predict(features);
    data_lr(i,:) = flr';
end
%data_nn = revnormalized_data(out,data_nn);
%data_svr = revnormalized_data(out,data_svr);
%data_lr = revnormalized_data(out,data_lr);


    error1 = sqrt(sum((data_svr - out).^2)/m);
    error2 = sqrt(sum((data_lr - out).^2)/m);
    error3 = sqrt(sum((data_nn - out).^2)/m);
    round(error1,2),round(error2,2),round(error3,2)
    mean(round(error1,2)),mean(round(error2,2)),mean(round(error3,2))

for i=1:8
    f1 = figure;
    axis([0 m 0 1]);
    hold all;
    title('Comparison of Various Regression Techniques');
    xlabel('Data Points');
    ylabel(strcat('Predicted and  True Values of f',num2str(i)));
    plot(1:m,out(:,i),'color','b','linewidth',1);
    plot(1:m,data_svr(:,i),'color','g','linewidth',1);
    plot(1:m,data_nn(:,i),'color','r','linewidth',1);
    plot(1:m,data_lr(:,i),'--','color','b','linewidth',1);
    legend('True Data','SVR','NN','Linear Regression');
    %saveas(f1,strcat('comparef',num2str(i),'.pdf'));
end
end
%f = revnorm_data(f');