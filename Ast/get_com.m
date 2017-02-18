function out = get_com(current)
global prec
out = round([0.5*(current(:,1)+current(:,7)) 0.5*(current(:,2)+current(:,8))]/prec);
end
