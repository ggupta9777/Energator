
    function out = lr_predict(feature)
    global LR_params1 LR_params2 LR_params3 LR_params4 LR_params5 LR_params6 LR_params7 LR_params8
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