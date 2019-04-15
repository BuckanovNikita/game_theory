clear all;
close all;
capital0 = 40;
cost = 1;
price = 2;
priceSale = 1.5;
freeTime = 60;
storCost = 0.05;
preorderTime = 30;
delivCost = 10;
load('ducer_140508.mat');
N = length(enter);
Q = zeros(1,N+1);
Q(N+1) = last;
date(N+1) = dateLast;
q = quantity;
for i=N:-1:1
    if(enter(i))
        Q(i) = Q(i+1) - q(i);
    else
        Q(i) = Q(i+1) + q(i);
    end
end
figure;
plot(date,Q,date,0*date,'r');
title('State of warehouse');
grid on;
deliv = [];
% [deliv.day] = find(enter)';
% [deliv.q] = q(enter)';
profit = zeros(1,N+1);
[deliv.day] = date(1);
[deliv.q] = Q(1);
profit(1) = capital0 - delivCost - Q(1)*cost;
for i=2:N+1
    day = [deliv.day];
    sizeD = length(day);
    qDeliv = [deliv.q];
    I = ((date(i)-day)>freeTime) & (qDeliv>0);
    sum(qDeliv(I))*storCost*(date(i)-date(i-1))
    profit(i) = profit(i) - sum(qDeliv(I))*storCost*(date(i)-date(i-1));
    if(enter(i-1))
        profit(i) = profit(i) + profit(i-1) - delivCost - q(i-1)*cost;
        if(sizeD==0)
            day = date(i-1);
            qDeliv = q(i-1);
        else
            if(qDeliv(1)>0)
                qDeliv = [qDeliv q(i-1)];
                day = [day date(i-1)];
            else
                qDeliv(1) = qDeliv(1) + q(i-1);
                day(1) = date(i-1);
            end
        end
        [deliv.day] = day;
        [deliv.q] = qDeliv;
    else
        if Q(i-1)>0
            pr = price;
        else
            pr = priceSale;
        end
        profit(i) = profit(i) + profit(i-1) + q(i-1)*pr;
        if(sizeD==0)
            qDeliv = 0;
            day = date(i);
            sizeD = 1;
        end
        qDeliv(1) = qDeliv(1) - q(i-1);
        j=1;
        while qDeliv(j)<0
            j = j+1;
            if(j>sizeD)
                break;
            end
            qDeliv(j) = qDeliv(j) + qDeliv(j-1);
            qDeliv(j-1) = 0;
        end
        I = qDeliv==0;
        [deliv.day] = day(~I);
        [deliv.q] = qDeliv(~I);
    end
%     fprintf('Day: %f,',date(i));
%     fprintf('q: %f,',[deliv.q]);
%     fprintf('days: %f\n',[deliv.day]);
end
figure;
plot(date,profit);
grid on;    
title('Profit');

figure;
plot(date(~enter), quantity(~enter));
grid on;
title('Consumption');
% legend('Consumption','Deliveries');
temp = zeros(1,N+1);
temp(enter) = quantity(enter);
figure;
plot(date, temp);
grid on;
title('Deliveries');

countErr = true;
Q0 = 30;
ProcessConsumption(date(~enter),quantity(~enter),Q0,capital0,...
    price,priceSale,freeTime,cost,storCost,preorderTime,delivCost,countErr);
countErr = false;
ProcessConsumption(date(~enter),quantity(~enter),Q0,capital0,...
    price,priceSale,freeTime,cost,storCost,preorderTime,delivCost,countErr);
