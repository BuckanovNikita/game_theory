clc
clear
close all

my_num = 1460
filenames = 'D+Z_future.xls';
% my_num = 146;
% filenames = 'DUCER_future.xls';
sheets = 'Анализ';

result_nums = [];
result_dates = [];
result_delivery = [];
start = 60;

[a, b, c] = xlsread(filenames, sheets);

tmp_num = a(:, 1);
tmp_counts = a(:, 6);
tmp_dates = datenum(b(2 : end, 3), 'dd.mm.yyyy');
tmp = char(b(2 : end, 10));
tmp_in = (tmp(:, 1) == 'v');

count = sum(tmp_num == my_num);
 
num = zeros(1, count);
delivery = zeros(1, count);
consumption = zeros(1, count);
dates = zeros(1, count);

num = (tmp_num == my_num);
dates = tmp_dates(num);
delivery = tmp_counts(num);
consumption = tmp_counts(num);
temp_in = tmp_in(num);

for i = 1:count
   if ( temp_in (i) )
       consumption(i) = 0;
   else
       delivery(i) = 0;
   end
end

[f R mD CV v] = model(delivery, consumption, dates );
f = f(1:numel(dates));
R = R(1:numel(dates));

figure
plot(dates,f,dates(mD~=0),mD(mD~=0)./mD(mD~=0),'g*');
grid on
xlabel('время')
ylabel('состояние склада')
title('склад')
legend('наша модель','точики заказа')
figure
plot(dates,R);
grid on
xlabel('время')
ylabel('состояние бюджета')
title('бюджет')

figure
for i = 1:numel(v)-1
   if (v(i+1) == 0)
       v(i+1) = v(i);
   end
end
plot(dates,consumption,'r--', dates(1:numel(v)), v,'b');
grid on
xlabel('время')
ylabel('расходы')
title('расход')
legend('реальные расходы','наша модель')

 xyz(1,1:length(dates))=CV;
 xyz(2,1:length(dates))=R;
 date(1:length(dates))=b(num, 3);
 xlswrite(['my_' filenames],xyz','Лист1');
 xlswrite(['my_' filenames],date','Лист2');