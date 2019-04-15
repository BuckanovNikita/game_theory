clear all;
close all;

 load('ducer_future.mat');
capital0 = 40;
cost = 1;
price = 2;
priceSale = 1.5;
freeTime = 60;
storCost = 0.05;
preorderTime = 30;
delivCost = 10;
Q0 = 60;
countErr = false;
ProcessConsumption(date,quantity,Q0,capital0,...
    price,priceSale,freeTime,cost,storCost,preorderTime,delivCost,countErr);
countErr = true;
ProcessConsumption(date,quantity,Q0,capital0,...
    price,priceSale,freeTime,cost,storCost,preorderTime,delivCost,countErr);
load('DZ_future.mat');
Q0 = 65;

countErr = false;
ProcessConsumption(date,quantity,Q0,capital0,...
    price,priceSale,freeTime,cost,storCost,preorderTime,delivCost,countErr);
countErr = true;

ProcessConsumption(date,quantity,Q0,capital0,...
    price,priceSale,freeTime,cost,storCost,preorderTime,delivCost,countErr);

freeTime = 260;
countErr = false;
ProcessConsumption2(date,quantity,Q0,capital0,...
    price,priceSale,freeTime,cost,storCost,preorderTime,delivCost,countErr,1,30);
countErr = true;

ProcessConsumption2(date,quantity,Q0,capital0,...
    price,priceSale,freeTime,cost,storCost,preorderTime,delivCost,countErr,1,30);
