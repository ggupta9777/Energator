    function out = U3(mat,mat_dot, mat_dotdot, a,b,c)
        out = eye(size(mat,1));
        if b<=a && c<=a
            if b==c
                for q=1:a
                    if q==b
                        out1 = mat_dotdot(:,:,q);
                    else
                        out1 = mat(:,:,q);
                    end
                    out = out*out1;
                end
            else
                for q=1:a
                    if q==b || q==c
                        out1 = mat_dot(:,:,q);
                    else
                        out1 = mat(:,:,q);
                    end
                    out = out*out1;
                end
            end
        else
            out = zeros(size(mat,1));
        end
    end
