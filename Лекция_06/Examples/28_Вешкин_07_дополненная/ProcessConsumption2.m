function [dateNet st profit delOpt] = ProcessConsumption2(dateCons,consumption,Q0,capital0,...
    price,priceSale,freeTime,cost,storCost,preorderTime,delivCost,countErr,k,analyzePeriod)
% Q0 = 30;
% M = ceil(date(end)-date(1));
M = ceil(dateCons(end)-dateCons(1));
st = zeros(1,M+1);
dateNet = 0:M;
delOpt(1) = Q0;
delDate(1) = dateNet(1);
% dateCons = date(~enter)';
% consumption = quantity(~enter);
st(1) = delOpt(1);
I = dateCons<=dateNet(1);
% analyzePeriod = 55;
st(1) = st(1) - consumption(I);
profit = zeros(1,M+1);
profit(1) = capital0 + price*consumption(I) - delOpt(1)*cost - delivCost;
error = 0;
% countErr = true;
for i=2:M+1
    ICons = (dateCons>dateNet(i-1)) & (dateCons<=dateNet(i));
    IDel = (delDate>dateNet(i-1)) & (delDate<=dateNet(i));
    st(i) = st(i-1) + sum(delOpt(IDel));
%     start = dateNet(i)-analyzePeriod;
%     if start<1
%         start = dateNet(1);
%     end
    start = dateNet(1);

    I = (dateCons>=start) & (dateCons<dateNet(i));
    vm = k*sum(consumption(I))/(dateNet(i)-start);
    if(sum(IDel)~=0)
        if(countErr)
            error = (st(i) - vm*freeTime);
        end
    end
    st(i) = st(i) - sum(consumption(ICons));
    if(dateNet(i)-start<analyzePeriod)
        continue;
    end
    I = delDate>dateNet(i);
    if sum(I)==0
        prediction = st(i)-vm*preorderTime;
        if (prediction <= 0)
%             preorder = [preorder (vm*freeTime - prediction)]
%             delOpt = [delOpt preorder(end)];
%             delOpt = [delOpt (vm*freeTime - prediction - error)];
            delOpt = [delOpt (vm*analyzePeriod - prediction - error)];
            delDate = [delDate (dateNet(i)+preorderTime - 1)];
        end
    end
%     fprintf('Date: %f , vm: %f\n',dateNet(i),vm);
end

[deliv.day] = delDate(1);
[deliv.q] = delOpt(1);
for i=2:M+1
    day = [deliv.day];
    sizeD = length(day);
    qDeliv = [deliv.q];
    I = ((dateNet(i)-day)>freeTime) & (qDeliv>0);
    profit(i) = profit(i-1) - sum(qDeliv(I))*storCost*(dateNet(i)-dateNet(i-1));
    ICons = (dateCons>dateNet(i-1)) & (dateCons<=dateNet(i));
    IDel = (delDate>dateNet(i-1)) & (delDate<=dateNet(i));
    profit(i) = profit(i) - delivCost*(sum(IDel)) - sum(delOpt(IDel))*cost;
    if(st(i-1)>0)
        pr = price;
    else
        pr = priceSale;
    end
    profit(i) = profit(i) + pr*sum(consumption(ICons));
    if sum(IDel)~=0
        if(sizeD==0)
            day = delDate(IDel);
            qDeliv = delOpt(IDel);
            sizeD = length(delDate);
        else
            if(qDeliv(1)>0)
                qDeliv = [qDeliv delOpt(IDel)];
                day = [day delDate(IDel)];
            else
                qDeliv = [(qDeliv(1)+delOpt(IDel(1))) delOpt(IDel(2:end))];
                day = delDate(IDel);
            end
            sizeD = length(delDate);
        end
    end
    
    if sum(ICons)~=0
        if(sizeD==0)
            qDeliv = 0;
            day = dateNet(i);
            sizeD = 1;
        end
        qDeliv(1) = qDeliv(1) - sum(consumption(ICons));
        j=1;
        while qDeliv(j)<0
            j = j+1;
            if(j>sizeD)
                break;
            end
            qDeliv(j) = qDeliv(j) + qDeliv(j-1);
            qDeliv(j-1) = 0;
        end
    end
    I = qDeliv==0;
    [deliv.day] = day(~I);
    [deliv.q] = qDeliv(~I); 
end

figure;
plot(dateNet,st,dateNet,dateNet*0,'r');
grid on;
title('State (optimized)');
figure;
plot(delDate,delOpt,delDate,delOpt,'r*');
grid on;
title('Optimized deliveries');
figure;
plot(dateCons, consumption,dateCons, consumption,'r*');
grid on;
title('Consumption');
figure;
plot(dateNet,profit);
grid on;
title('Profit(optimized)');
