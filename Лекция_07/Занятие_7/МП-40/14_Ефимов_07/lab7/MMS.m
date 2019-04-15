function [k b error] = MMS( Y , X)
mid = @(X) sum(X)/length(X); 
k = (mid(Y.*X) - mid(X)*mid(Y))/(mid(X.^2) - mid(X)^2);
b = mid(Y) - k*mid(X);

if (length(X) == 2)
   error = 1;
else
   error = sum((Y - k*X -b).^2)/(length(X) - 2);
end
%result  = mid(a + b*X);
end

