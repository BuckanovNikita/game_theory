clc
close all
clear all
start_up = 30;
privoz = 10;
self_cost = 1;
% k = 
[num text]= xlsread('D:\Учеба\ТиГрио\ТИГРИО_7\Лекция_07\Data\DUCER_14.05.08.xls','Продажи');
date = text(:,3);
date = date(6002:6216);
tmp_dates = datenum(date, 'dd.mm.yyyy');
trend = num(6001:6215,6);
point = text(:,10);
point = point(6002:6216);
for i =1:numel(trend)
    switch point{i}
        case 'vvod'
            trend(i) = trend(i);
        otherwise
            trend(i) = - trend(i);
    end
end
l = 1;
i = 1;
Q(1) = start_up;
profit(1) = 100;
for i = 1:numel(trend)-1
    Q(i+1) = Q(i) + trend(i);
    if(Q(i)<0)
        cost = 1.5;
    else
        cost = 2;
    end
    if(trend(i)<0)
        profit(i+1) = profit(i) + abs(cost*trend(i));
    else
        profit(i+1) = profit(i) - privoz - self_cost*trend(i);
    end
end
t = 1:numel(Q);
 plot(tmp_dates,Q);
 xlabel('дни')
 ylabel('товар на складе')
 grid on
 figure
 plot(tmp_dates,profit)
 xlabel('дни')
 ylabel('доход')
 grid on
 