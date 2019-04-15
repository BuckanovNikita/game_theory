clc
close all
clear all
start_up = 30;
privoz = 10;
self_cost = 1;
i_hr = 0.05;
hran = 3;
[num text els]= xlsread('D:\Учеба\ТиГрио\ТИГРИО_7\Лекция_07\Data\DUCER_FUTURE.xls','Анализ');
date = text(:,3);
date = date(9103:9357);
tmp_dates = datenum(date, 'dd.mm.yyyy');
trend = num(9103:9357,6);
point = text(:,10);
point = point(9103:9357);
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
tau = sqrt(2*privoz/(hran * Q(1)));
%t = (max(tmp_dates) - min(tmp_dates))*tau + min(tmp_dates);
t =  min(tmp_dates)+10
q = sqrt(2*privoz*Q(1)/hran);
k = 0;
past = 1;
dni_dost = 0;
for i = 1:numel(trend)-1
    k = k + 1;
    if (i - 7 < 1)
    Q_sum = abs(sum(trend(1 : i)))/(i);
    else
     Q_sum = abs(sum(trend(i-7 : i)))/7;
    end
    if (Q(i) - Q_sum*30 <0)
        Q(i+1) = Q(i) + Q_sum*60;
        q = Q_sum*60;
        remember = i;
        res =  (tmp_dates(i) - tmp_dates(past))/3;
        past = i;
        fprintf('--------------------\n')
        fprintf('t_opt = %f\n',res);
        fprintf('q_opt = %f\n',Q_sum*60);
        if(k<60)
        profit(i+1) = profit(i) - privoz - self_cost*q;
        else
            profit(i+1) = profit(i) - privoz - self_cost*q - (k-60)*i_hr;
            k = 0;
        end
    else
    Q(i+1) = Q(i) + trend(i);
    if(Q(i)<0)
        cost = 1.5;
    else
        cost = 2;
    end
    if(k<60)
        profit(i+1) = profit(i) + abs(cost*trend(i));
    else
        profit(i+1) = profit(i) + abs(cost*trend(i)) - (k-60)*i_hr;
        k = 0;
    end
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
 