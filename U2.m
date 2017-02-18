    function out = U2(mat,mat_dot, a,b)
        out = eye(4);
        if b<=a
            for q=1:a
                if q==b
                    out1 = mat_dot(:,:,q);
                else
                    out1 = mat(:,:,q);
                end
                out = out*out1;
            end
        else
            out = zeros(4);
        end
    end
