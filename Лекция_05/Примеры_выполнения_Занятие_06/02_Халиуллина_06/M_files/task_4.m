% Выполняет задание 4 из л.р. №6

clc; close all;  clear all;
%Выполняет задание 1 из лабораторной работы №5
tay = 90; S = 4/30; q = 140000/10; K = 700; V = 140000/30;
% Расход в единицу времени
Rashod = S*q/2 + K*V/q;
% Оптимизируем расход
Kol_vo = sqrt(2*K*V/S);
podvoz = Kol_vo/V;
Rashodi_optim = K*V/Kol_vo + S*Kol_vo/2;
% Состояние склада в оптимизированной модели
sklad(1) = Kol_vo;
den(1) = 1; m = 1;
dohod(1) = 0; stoim = 1; zavoz(1) = Kol_vo;
V_this_moment(1) = V;
alpha = 0.01; t_opt = 2;
for i = 2:tay
    V_1 = V + alpha*V*i;
    zavoz(i) = 0;
    podvoz = 0;
    if(round((i)/2) == (i)/2)
        podvoz = (V_1+ ((V_1 - V)/(i-1))*t_opt/0.02)*t_opt - sklad(i-1);
        zavoz(i) = podvoz;
    end
    sklad(i) = sklad(i-1) + podvoz - V_1;
    V_this_moment(i) = V_1;
    if (sklad(i) < 0)
        dohod(i) = dohod(i-1) - K + V_1*stoim;
    else
        dohod(i) = dohod(i-1) - S*sklad(i-1)- K + V_1*stoim;
    end
end
den = 1:tay;
hold
plot(den, sklad, 'r-');grid
plot(2:2:tay, sklad(2:2:tay),'bo')
xlabel('День'); ylabel('Кол-во товара на складе'); title('Количество товара на складе');
figure;
plot(den, V_this_moment);grid
xlabel('День'); ylabel('Скорость расходования товара'); title('Расход товара');
figure;
plot(den, dohod);grid
xlabel('День'); ylabel('Доход'); title('Прибыль предприятия');
% axis([0 60 0 14000])
figure
bar(den, zavoz, 'g');grid
xlabel('День'); ylabel('Кол-во'); title('Количество подвозимого товара');
