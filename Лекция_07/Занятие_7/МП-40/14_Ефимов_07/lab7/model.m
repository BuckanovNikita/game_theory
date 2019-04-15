function [f R CD CV v] = model(D, C, date )
% f состояние склада
% R бюджет в текущий момент
% CD даты поставок
% CV величины поставок
% D доставка товара
% C расход товара
% date даты событий
% s стоимсоть хранения единицы товара после 60 дней хранения
s = 0.05;
% p цена реализации товара
p = 2;
% pz цена реализации товара, в условиях дефицита
pz = 2;
% r цена закупки товара
r = 1;
% cost  стоимость одной поставки
cost = 10;
% freq время задержки поставки от момента заказа
freq = 30;
% T время отложенного платежа
T = 60;

delivary_nums = numel(date);
R = zeros(1,delivary_nums+T);
f = zeros(1,delivary_nums+T);
mD = zeros(1,delivary_nums+T);
consignment_times = zeros(1,delivary_nums+T);
consignment_dates = zeros(1,delivary_nums+T);
consignment = zeros(1,delivary_nums+T);
CV = zeros(1,delivary_nums);
consignment_nums = 1;

f(1) = 0;
f(2) = 0;
v(1) = C(1);
CV(1) = 0;
freq0 = 15;
k = 1;
debet = 0;

for t = 2:numel(date)
    if (f(t-1) >= C(t))
        cur_price = p;
        R(t) = R(t) + C(t)*cur_price;
        f(t) = f(t-1) - C(t);
        [consignment consignment_times] = TakeFromStock(consignment, consignment_times, C(t));        
    else
        cur_price = pz;
        R(t) = R(t) + (C(t) - f(t-1))*cur_price;
        debet = debet + C(t) - f(t-1);
        [consignment consignment_times] = TakeFromStock(consignment, consignment_times, C(t));   
    end
    
    if (k < freq0)
        temp_price(k) = C(t);
        temp_dates(k) = date(t);
        k = k + 1;
    else
        consignment_dates(t) = date(t);
        [a b] = MMS(temp_price,temp_dates);
        period = freq;
        v(t) = a*(date(t + period/2)) + b;
        consignment(t) = debet + round(v(t)*freq)*2;
        CV(t) = consignment(t);
        freq0 = freq;
        f(t + freq) = f(t + freq) + consignment(t);
        R(t + T) = R(t + T) + cost + consignment(t)*r;
        debet = 0;
        temp_price = 0;
        temp_dates = 0;
        k = 1;
        consignment_nums = consignment_nums + 1;
    end
    
    consignment_times(consignment > 0) = consignment_times(consignment > 0) +1;
    R(t) = R(t) + sum(consignment(consignment_times > 60))*s;
end
    CD = consignment_dates;
end

