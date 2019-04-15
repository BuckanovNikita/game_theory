close all
clear all
clc
v0=140000/30; k=700/30; s=4/30;
alpha=pi/2; p=30;
t=1:90; tau=3;
q=sqrt(2*k*v0/s);
% q=7000;
Q=q*ones(1,length(t));
profit=zeros(1,length(t));
v=ones(1,length(t));
day=1;
for i=2:length(t)
    day=day+1;
    if day==8
        day=1;
    end
    r=-4+8*rand;
    v(i-1)=v0*(1+r*day);
%     v(i-1)=v0*(1+r);
%     q=sqrt(2*k*v(i-1)/s);
    Q(i)=Q(i-1)-v(i-1);
    k=0;
    if mod(t(i),tau)==0
        Q(i)=q*tau+Q(i);
    end
    if Q(i)>0
        k=7;
        profit(i)=profit(i-1)-s*Q(i)-k*tau*q+v(i-1)*p;
    else
        profit(i)=profit(i-1)-abs(k*Q(i));
    end
end
figure,plot(t,Q,'g'),grid
title('кол-во товара на складе'),xlabel('время, дни'),ylabel('кол-во, л')
figure,plot(t,profit,'b'),grid
title('изменение общего дохода'),xlabel('время, дни'),ylabel('доход, у.е.')
figure,plot(t,v,'r'),grid
title('изменение тренда'),xlabel('время, дни'),ylabel('тренд')