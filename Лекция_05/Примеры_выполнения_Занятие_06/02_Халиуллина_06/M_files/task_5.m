% ��������� ������� 5 �� �.�. �6

clc; close all; clear all;
%��������� ������� 1 �� ������������ ������ �5
tay = 90; S = 4/30; q = 140000/10; K = 700; V = 140000/30;
% ������ � ������� �������
Rashod = S*q/2 + K*V/q;
% ������������ ������
Kol_vo = sqrt(2*K*V/S);
podvoz = Kol_vo/V;
Rashodi_optim = K*V/Kol_vo + S*Kol_vo/2;
% ��������� ������ � ���������������� ������
sklad(1) = Kol_vo;
den(1) = 1; m = 1;
dohod(1) = 0; stoim = 1; zavoz(1) = Kol_vo;
V_this_moment(1) = V;
alpha = 5; t_opt = 2; sezon = 0;
for i = 2:tay
    if (sezon == 8) sezon = 1; end
    V_1 = V + alpha*i + sezon*0.1*V;
    sezon = sezon + 1;
    zavoz(i) = 0;
    podvoz = 0;
    if(round((i)/2) == (i)/2)
        podvoz = (V_1+ ((V_1 - V)/(i-1))*t_opt/0.02)*t_opt - sklad(i-1);
        if (podvoz < 0) podvoz = 0; end
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
xlabel('����'); ylabel('���-�� ������ �� ������'); title('���������� ������ �� ������');
figure;
plot(den, V_this_moment);grid
xlabel('����'); ylabel('�������� ������������ ������'); title('������ ������');
figure;
plot(den, dohod);grid
xlabel('����'); ylabel('�����'); title('������� �����������');
% axis([0 60 0 14000])
figure
bar(den, zavoz, 'g');grid
xlabel('����'); ylabel('���-��'); title('���������� ����������� ������');
