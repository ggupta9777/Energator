function out = pop2dec(pop,nvar)
[a, b]=size(pop);
l = b/nvar;
out = zeros(a,nvar);
for i=1:a
	for j=1:nvar
		temp = pop(i,(j-1)*l+1:j*l);
		out(i,j) = bin2dec(sprintf('%-1d',temp));
	end
end
end
