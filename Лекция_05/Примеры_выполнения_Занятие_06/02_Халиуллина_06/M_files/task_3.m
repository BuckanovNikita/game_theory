% ��������� ������� 3 �� �.�. �6

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
for i = 5:2*tay+3
    if (sklad(i-4) < 0)
        sklad(i-4) = 0.6*sklad(i-4);
        dohod(i-4) = dohod(i-4) + 0.2*sklad(i-4)*stoim;
    end
    if (i/2 == round(i/2))
        if ((i)/4 == round((i)/4))
            podvoz = Kol_vo - sklad(i-4);
            sklad(i-3) = sklad(i-4) + podvoz;
            den(i-3) = i-3+0.5;
        else
            sklad(i-3) = sklad(i-4);
            podvoz = 0;
            den(i-3) = i-3;
        end
    else
        if (sklad(i-4) < 0)
            pribil = dohod((i-1)-3) - K + V*stoim;
        else
            pribil = dohod((i-1)-3) - S*sklad((i-1)-3)- K + V*stoim;
        end
        podvoz = 0;
        V = (1+randn*0.1)*V;
        sklad(i-3) = sklad(i-4) - V;
        den(i-3) = i-3;
    end
    V_this_moment(m) = V;
    dohod(i-3) = pribil;
    zavoz(i-3) = podvoz;
    m = m + 1;
end
hold
plot(den, sklad, 'r-');grid
xlabel('����'); ylabel('���-�� ������ �� ������'); title('���������� ������ �� ������');
legend('������������������ ������',  '���������������� ������')
figure;
plot(den, [V_this_moment V]);grid
xlabel('����'); ylabel('�������� ������������ ������'); title('������ ������');
figure;
plot(den, dohod);grid
xlabel('����'); ylabel('�����'); title('������� �����������');
% axis([0 60 0 14000])
figure
bar(den, zavoz, 'g');grid
xlabel('����'); ylabel('���-��'); title('���������� ����������� ������');
axis([0 180 0 14000])
