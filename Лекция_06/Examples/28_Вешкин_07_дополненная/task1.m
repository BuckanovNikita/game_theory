clear all;
close all;

price = 10;
K = 700;
S = 4/(30*24);
pm = 140000;
ps = pm/30;
ph = ps/24;
pmin = ph/60;
longperiod = 3*30*24;
qopt = 7000;
cycle = 36;
period = 10*cycle;
period_1 = period+1;
t = 1:(period_1);
Q(1:cycle:period_1) = qopt;
plot(t,Q);
grid on;
title('Deliveries (constant rate)');

vt = ph + .4*t;
SKT = zeros(1,period_1);
SKT(1) = Q(1);
vtemp = vt;
for i=2:period_1
    SKT(i) = SKT(i-1) + Q(i)-vt(i);
    if(SKT(i)<0)
        SKT(i)=0;
        vtemp(i) = SKT(i-1);
    end
end
figure;
I = SKT==0;
plot(t,SKT,t(I),SKT(I),'r*');
grid;
title('State of warehouse (with trend)');
legend('State','Dead time');

benefT = zeros(1,period_1);
profitT = zeros(1,period_1);
for i=1:period_1
    profitT(i) = price*sum(vtemp(1:i))-S*sum(SKT(i))-K*sum(length(find(Q(1:i))));
    benefT(i) = profitT(i)/sum(vtemp(1:i));
end
figure;
plot(t,benefT);
grid;
title('Profit per unit of product (with trend)');
figure;
plot(t,profitT);
grid;
title('Whole profit (with trend)');

figure;
plot(t,vt);
grid;
title('rate of consumption of the product (with trend)');

vs = ph*(1+0.5*sin(pi*t/36));
SKS = zeros(1,period_1);
SKS(1) = Q(1);
vtemp = vs;
for i=2:period_1
    SKS(i) = SKS(i-1) + Q(i)-vs(i);
    if(SKS(i)<0)
        SKS(i)=0;
        vtemp(i) = SKS(i-1);
    end
end
figure;
I = SKS==0;
plot(t,SKS,t(I),SKS(I),'r*');
grid;
title('State of warehouse (seasonal fluctuations)');
legend('State','Dead time');

figure;
plot(t,vs);
grid;
title('rate of consumption of the product (seasonal fluctuations)');

benefS = zeros(1,period_1);
profitS = zeros(1,period_1);
for i=1:period_1
    profitS(i) = price*sum(vtemp(1:i)) - S*sum(SKS(1:i)) - K*length(find(Q(1:i)));
    benefS(i) = profitS(i)/sum(vtemp(1:i));
end
figure;
plot(t,benefS);
grid;
title('Profit per unit of product (seasonal fluctuations)');
figure;
plot(t,profitS);
grid;
title('Whole profit(seasonal fluctuations)');

stdV = 25;
v = ph + stdV*randn(1,period_1) + ph*0.4*sin(pi*t/36)+...
     .4*t;
SK = zeros(1,period_1);
SK(1) = Q(1);
vtemp = v;
for i=2:period_1
    SK(i) = SK(i-1) + Q(i)-v(i);
    if(SK(i)<0)
        SK(i)=0;
        vtemp(i) = SK(i-1);
    end
end
figure;
I = SK==0;
plot(t,SK,t(I),SK(I),'r*');
grid on;
title('State of warehouse (with all troubles)');
legend('State','Dead time');
mv = mean(v);
stdv = std(v);
fprintf('Mean of rate: %f\n',mv);
fprintf('Standart deviation: %f\n',stdv);
figure;
plot(t,v);
grid;
title('rate of consumption of the product(with all troubles)');

benef = zeros(1,period_1);
profit = zeros(1,period_1);
for i=1:period_1
    profit(i) = price*sum(vtemp(1:i)) - S*sum(SK(1:i))-K*length(find(Q(1:i)));
    benef(i) = profit(i)/sum(vtemp(1:i));
end
figure;
plot(t,benef);
grid;
title('Profit per unit of product (with all troubles)');
figure;
plot(t,profit);
grid;
title('Whole profit(with all troubles)');

vps(1:10) = v(1:10);
for i=11:period_1
    vps(i) = sum(v(i-10:i-1))/10;
end
figure;
plot(t,vps);
grid;
title('sliding rate of consumption of the product');
SKPS = zeros(1,period_1);
SKPS(1) = Q(1);
for i=2:period_1
    SKPS(i) = SKPS(i-1) + Q(i)-vps(i);
end

vTemp = vps;
SKTemp = SKPS;
% iNeg = SKPS<=0;
% vTemp(iNeg) = 0;
for i=2:period_1
    SKTemp(i) = SKTemp(i-1) + Q(i)-vTemp(i);
    if(SKTemp(i)<0)
        vTemp(i) = SKTemp(i-1);
        SKTemp(i) = 0;
    end
end
benefps = zeros(1,period_1);
profitps = zeros(1,period_1);
for i=1:period_1
    profitps(i) = price*sum(vTemp(1:i)) - S*sum(SKTemp(1:i)) - K*length(find(Q(1:i)));
    benefps(i) = profitps(i)/sum(vTemp(1:i));
end
figure;
I = SKTemp==0;
plot(t,SKTemp,t(I),SKTemp(I),'r*');
grid on;
title('State of warehouse (sliding rate)');
legend('State','Dead time');
figure;
plot(t,benefps);
grid;
title('Profit per unit of product (sliding rate)');
figure;
plot(t,profitps);
grid;
title('Whole profit(sliding rate)');

QPS = zeros(1,period_1);
QPS(1) = qopt;
SKA = zeros(1,period_1);
SKA(1) = QPS(1);
benefA = zeros(1,period_1);
profitA = zeros(1,period_1);

profitA(1) = price*vps(1) - S*SKA(1) - K;
benefA(1) = profitA(1)/vps(1);
for i=2:period_1
   SKA(i) = SKA(i-1) - vps(i);
   if SKA(i)<0
       QPS(i) = qopt - SKA(i);
       SKA(i) = SKA(i) + QPS(i);
   else
       QPS(i) = 0;
   end
   profitA(i) = price*sum(vps(1:i)) - S*sum(SKA(1:i)) - K*length(find(QPS(1:i)));
   benefA(i) = profitA(i)/sum(vps(1:i));
end
figure;
plot(t,SKA);
title('State of warehouse (adaptive)');
grid on;

figure;
plot(t,QPS);
title('Adaptive deliveries');
grid on;

figure;
plot(t,benefA);
title('Profit per unit of product (adaptive)');
grid on;
figure;
plot(t,profitA);
title('Whole profit (adaptive)');
grid on;

IA = find(QPS);
QA = QPS(IA);
meanQA = mean(QA);
stdQA = std(QA);
TA = diff(IA);
meanTA = mean(TA);
stdTA = std(TA);
fprintf('mean of deliveries: %f\n',meanQA);
fprintf('standard deviation of deliveries: %f\n',stdQA);
fprintf('mean of time between deliveries: %f\n',meanTA);
fprintf('standard deviation of time between deliveries: %f\n',stdTA);

% fprintf('Profit per unit (with trend), mean =  %f\n',...
%     mean(benefT));
% fprintf('Profit per unit (seasonal fluctuations), mean =  %f\n',...
%     mean(benefS));
% fprintf('Profit per unit (trend, seasons, randomnicity), mean =  %f\n',...
%     mean(benef));
fprintf('Profit per unit (seasons, trend, randomnicity), mean =  %f\n',...
    mean(benefps));
fprintf('Profit per unit (adaptive), mean =  %f\n',...
    mean(benefA));
