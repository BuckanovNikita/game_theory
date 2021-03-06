clc
clear
close all

my_num = 1460
filenames = 'D+Z_14.05.08.xls';
% my_num = 146;
% filenames = 'DUCER_14.05.08.xls';
sheets = '�������';

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

[f1 R1 mD1] = real_model(delivery, consumption, dates );
f1 = f1(1:numel(dates));
R1 = R1(1:numel(dates));

figure
plot(dates,f,dates,f1,'r',dates(mD~=0),mD(mD~=0)./mD(mD~=0),'g*');
grid on
xlabel('�����')
ylabel('��������� ������')
title('�����')
legend('���� ������','�������� ���������','������ ������')
figure
plot(dates,R,dates,R1,'r');
grid on
xlabel('�����')
ylabel('��������� �������')
title('������')
legend('���� ������','�������� ���������')

 xyz(1,1:length(dates))=CV;
 xyz(2,1:length(dates))=R;
 xlswrite(['my_' filename],xyz');
 
  xyz(1,1:length(dates))=CV;
 xyz(2,1:length(dates))=R;
 date(1:length(dates))=b(num, 3);
 xlswrite(['my_' filenames],xyz','����1');
 xlswrite(['my_' filenames],date','����2');
