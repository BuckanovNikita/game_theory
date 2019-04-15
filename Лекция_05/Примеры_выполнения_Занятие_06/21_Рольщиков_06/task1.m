close all
clear all
clc
v0=140000/30; k=700/30; s=4/30;
alpha=pi; p=35;
t=1:90;
% q=sqrt(2*k*v0/s);
q=14000;
Q=q*ones(1,length(t));
profit=zeros(1,length(t));
v=ones(1,length(t));
ctr=0;
for i=2:length(t)
    ctr=ctr+1;
    if ctr>7
        ctr=0;
    end
    r=-4+8*rand;
    v(i-1)=v0*(1+ctr*r);
    Q(i)=Q(i-1)-v(i-1);
%     k=0;
    if Q(i)<0
%         k=10;
        q=sqrt(2*k*v(i-1)/s);
        Q(i)=q+Q(i-1);
    end
    profit(i)=profit(i-1)-s*Q(i)-k*q+v(i-1)*p;
end
figure,plot(t,Q,'g'),grid
title('кол-во товара на складе'),xlabel('время, дни'),ylabel('кол-во, л')
figure,plot(t,profit,'b'),grid
title('изменение общего дохода'),xlabel('время, дни'),ylabel('доход, у.е.')
figure,plot(t,v,'r'),grid
title('изменение тренда'),xlabel('время, дни'),ylabel('тренд')