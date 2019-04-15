%% ��� 1. ������ ������
close all
clear all
clc
path='F:\��� ���������\������\������\lab7\';
xlsfilename='DUCER_FUTURE.XLS';
id=152; % ����� ������
[num,date]=xlsread([path xlsfilename]); % ������ ����������� �� .xls �����
num=num(:,[1 6]); % ����� � ������� (2 �������)
date=date(2:end,3); %����
numdate=datenum(date,'dd.mm.yyyy');
ptr1=1; ptr2=1;
flag1=true; flag2=true;
for i=1:size(num,1) % ����� ������� ������
    if flag1
        if num(i,1)==id
            ptr1=i;
            ptr2=ptr1;
            flag1=false;
        end
    elseif flag2
        if num(i,1)~=id
            ptr2=i-1;
            flag2=false;
        end
    end
end
sale=num(ptr1:ptr2,2);
date=date(ptr1:ptr2);
numdate=numdate(ptr1:ptr2);
sale=[numdate sale]; % ���� � �������
ptr1=1; ptr2=1;
while ptr1<=size(sale,1) %������ ���� �����������
    while (sale(ptr2,1)==sale(ptr1,1))
        ptr2=ptr2+1;
        if (ptr2>size(sale,1))
            break;
        end
    end
    sale(ptr1,:)=HandleSameDates(sale(ptr1:ptr2-1,:));
    sale=[sale(1:ptr1,:);sale(ptr2:end,:)];
    ptr1=ptr1+1;
    ptr2=ptr1;
end
sale(:,1)=sale(:,1)-sale(1,1)+1;
sale=[sale;1+sale(end,1) 0];
% figure,plot(sale(:,1),sale(:,2)),title('�������'),grid
% xlabel('����'),ylabel('������� ������')
% axis([sale(1,1) sale(end,1) 0 max(sale(:,2))+1])
% duration=sale(end,1)-sale(1,1)+1;
% buf=zeros(duration,2);
% buf(1,:)=sale(1,:);
% ptr=2;
% for i=2:duration % ���������� ����������� ����
%     if sale(ptr,1)==(1+buf(i-1,1))
%         buf(i,:)=sale(ptr,:);
%         ptr=ptr+1;
%     else
%         buf(i,1)=1+buf(i-1,1);
%     end
% end
% sale=zeros(duration+1,2);
% sale(1:end-1,:)=buf;
% sale(end,1)=sale(end-1,1)+1;
% figure,plot(sale(:,1),sale(:,2)),title('�������'),grid
% xlabel('����'),ylabel('������� ������')
% axis([sale(1,1) sale(end,1) -1 max(sale(:,2))+1])
%% ��� 2. �������
Q=zeros(1,size(sale,1)); % ���-�� ������
fund=Q; % �������
Q(1)=50; % ��������� ������������� ������
fund(1)=500; % ��������� �������
purchaisingPrice=1; % ���������� ����
marketPrice=2; % �������� ����
deficitPrice=1.5; % ���� �� ������ ��������
deliveryPrice=10; % ��������� ���������� ������
deliveryDuration=30; % ����� ��������
freeStoringDuration=60; % ����� ����������� ��������
extraStoringPrice=0.05; % ��������� ��������������� ��������
oldStoringDuration=0; % �������� ���������� ������
currentStoringDuration=0; % �������� �������� ������
extraStoringGoods=0; % ������, �������� �� ������
deliveryWaiting=false; % ��� �� ��������
deliveryDate=0;
oldGoods=0;
% for i=1:size(sale,1)-1
%     currentStoringDuration=currentStoringDuration+1;
%     oldStoringDuration=oldStoringDuration+1;
%     if i==deliveryDate % ���� ��������
%         fund(i)=fund(i)-deliveryPrice;
%         fund(i)=fund(i)-order*purchaisingPrice;
%         oldGoods=Q(i);
%         Q(i)=Q(i)+order;
%         deliveryWaiting=false;
%         oldStoringDuration=currentStoringDuration;
%         currentStoringDuration=1;
%     end
%     if Q(i)>0
%         fund(i)=fund(i)-extraStoringGoods*extraStoringPrice;
%         if Q(i)>=sale(i,2)
%             Q(i+1)=Q(i)-sale(i,2);
%             fund(i+1)=fund(i)+sale(i,2)*marketPrice;
%             extraStoringGoods=max([extraStoringGoods-sale(i,2);0]);
%             oldGoods=max([oldGoods-sale(i,2);0]);
%         else
%             fund(i+1)=fund(i)+Q(i)*marketPrice;
%             extraStoringGoods=0;
%             oldGoods=0;
%         end
%     else
%         fund(i+1)=fund(i);
%         if ~deliveryWaiting % ����� ����������, ��� ���� �� ��� �������, 
%             %���� ���������������� ��� ������ if-end
%             deliveryDate=i+deliveryDuration;
%             order=50;
%             deliveryWaiting=true;
%         end
%     end
%     if (currentStoringDuration==freeStoringDuration) % ���� ����� ������
%         extraStoringGoods=extraStoringGoods+Q(i+1);
%     end
%     if (oldStoringDuration==freeStoringDuration)&&(oldGoods>0)
%         % ���� ������ ������ ����� ��������
%         extraStoringGoods=extraStoringGoods+oldGoods;
%     end
% end
% figure,plot(sale(:,1),Q),title('��������� ������'),grid
% xlabel('����'),ylabel('���-�� ������')
% axis([sale(1,1) sale(end,1) -1 1+max(Q)])
% figure,plot(sale(:,1),fund),title('�������'),grid
% xlabel('����'),ylabel('�.�.')
% axis([sale(1,1) sale(end,1) -10+min(fund) 10+max(fund)])
%% ��� 3. ������������
monitoringWindowWidth=28; % ������ ���� �����������
% maxSale=0;
for i=1:size(sale,1)-1
%     if sale(i,2)>maxSale
%         maxSale=sale(i,2);
%     end
    currentStoringDuration=currentStoringDuration+1;
    oldStoringDuration=oldStoringDuration+1;
    if ~deliveryWaiting % ���� ��� ��������, ���������� �� � ����
        if i<monitoringWindowWidth+1
            avgSale=mean(sale(1:i-1,2));
        else
            avgSale=mean(sale(i-monitoringWindowWidth:i-1,2));
        end
        if (Q(i)-avgSale*deliveryDuration)<=0
            deliveryDate=i+deliveryDuration;
%             order=maxSale;
            order=floor(avgSale*(freeStoringDuration));
            deliveryWaiting=true;
        end
    end
    if i==deliveryDate % ���� ��������
        fund(i)=fund(i)-deliveryPrice;
        fund(i)=fund(i)-order*purchaisingPrice;
        oldGoods=Q(i);
        Q(i)=Q(i)+order;
        deliveryWaiting=false;
        oldStoringDuration=currentStoringDuration;
        currentStoringDuration=1;
    end
    fund(i)=fund(i)-extraStoringGoods*extraStoringPrice;
    if Q(i)>=sale(i,2)
        Q(i+1)=Q(i)-sale(i,2);
        fund(i+1)=fund(i)+sale(i,2)*marketPrice;
        extraStoringGoods=max([extraStoringGoods-sale(i,2);0]);
        oldGoods=max([oldGoods-sale(i,2);0]);
    else
        fund(i+1)=fund(i);
        if Q(i)>=0
            fund(i+1)=fund(i+1)+Q(i)*marketPrice;
        end
        extraStoringGoods=0;
        oldGoods=0;
        Q(i+1)=Q(i)-sale(i,2);
        if Q(i)>0
            fund(i+1)=fund(i+1)+(sale(i,2)-Q(i))*deficitPrice;
        else
            fund(i+1)=fund(i+1)+sale(i,2)*deficitPrice;
        end
    end
    if (currentStoringDuration==freeStoringDuration)&&(Q(i)>0)
        % ���� ����� ������
        extraStoringGoods=extraStoringGoods+Q(i);
    end
    if (oldStoringDuration==freeStoringDuration)&&(oldGoods>0)
        % ���� ������ ������ ����� ��������
        extraStoringGoods=extraStoringGoods+oldGoods;
    end
end
figure,plot(sale(:,1),Q),title('��������� ������'),grid
xlabel('����'),ylabel('���-�� ������')
axis([sale(1,1) sale(end,1) -1+min(Q) 1+max(Q)])
figure,plot(sale(:,1),fund),title('�������'),grid
xlabel('����'),ylabel('�.�.')
axis([sale(1,1) sale(end,1) -10+min(fund) 10+max(fund)])