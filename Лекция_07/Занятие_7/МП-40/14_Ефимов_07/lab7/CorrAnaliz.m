function [P] = CorrAnaliz( T, h )

[ACF LAG] = xcorr(T);
ACF(ACF<0) = 0;
plot(LAG,ACF)
xlabel('LAG')
ylabel('ACF')
title('Автокорреляционная функция')
grid on
k = round(length(ACF)/2) + 1;
while(not((ACF(k-1) < ACF(k))&&(ACF(k+1)<ACF(k))))
   k = k + 1;
end
P = h * LAG(k);
end

