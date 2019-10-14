clc;clear;
%%
% Iris
load Iris.mat
hold on;
x=1:3;%x���ϵ����ݣ���һ��ֵ�������ݿ�ʼ���ڶ���ֵ��������������ֵ������ֹ 
normalizedMSE=normalizeData(MSE_all{1}); %a����yֵ
% a=(MSE_all{1}); %a����yֵ 
% b=[334.4,143.2,297.4,487.2,596.2]; %b����yֵ 
plot(x,normalizedMSE,'-xk'); %���ԣ���ɫ����� axis([0,6,0,700]) %ȷ��x����y���ͼ��С 

%%
% wine
load WineAdjust.mat
hold on;
x=1:2;
normalizedMSE=normalizeData(MSE_all{1}); %a����yֵ
plot(x,normalizedMSE,'-oc');


%%
% wine
load DUM.mat
hold on;
x=1:4;%x���ϵ����ݣ���һ��ֵ�������ݿ�ʼ���ڶ���ֵ��������������ֵ������ֹ 
normalizedMSE=normalizeData(MSE_all{1}); %a����yֵ
plot(x,normalizedMSE,'-sk'); %���ԣ���ɫ����� axis([0,6,0,700]) %ȷ��x����y���ͼ��С 

%%
% MovementLibras
load MovementLibras.mat
hold on;
x=1:1:7;%x���ϵ����ݣ���һ��ֵ�������ݿ�ʼ���ڶ���ֵ��������������ֵ������ֹ 
normalizedMSE=normalizeData(MSE_all{1}); %a����yֵ
plot(x,normalizedMSE,'-dc'); %���ԣ���ɫ����� axis([0,6,0,700]) %ȷ��x����y���ͼ��С 

%%
% Ecoli
load Ecoli.mat
hold on;
x=1:1:6;%x���ϵ����ݣ���һ��ֵ�������ݿ�ʼ���ڶ���ֵ��������������ֵ������ֹ 
normalizedMSE=normalizeData(MSE_all{1}); %a����yֵ
plot(x,normalizedMSE,'-+r'); %���ԣ���ɫ����� axis([0,6,0,700]) %ȷ��x����y���ͼ��С 

%%
clc;clear;
% WineQualityRed
load WineQualityRed.mat
hold on;
x=1:1:5;%x���ϵ����ݣ���һ��ֵ�������ݿ�ʼ���ڶ���ֵ��������������ֵ������ֹ 
normalizedMSE=normalizeData(MSE_all{1}); %a����yֵ
plot(x,normalizedMSE,'-pb'); %���ԣ���ɫ����� axis([0,6,0,700]) %ȷ��x����y���ͼ��С 

%%
% EMPGA_1
load EMPGA_1.mat
x=1:1:24;%x���ϵ����ݣ���һ��ֵ�������ݿ�ʼ���ڶ���ֵ��������������ֵ������ֹ 
normalizedMSE=normalizeData(MSE_all{1}(1:24)); %a����yֵ
plot(x,normalizedMSE,'-hr'); %���ԣ���ɫ����� axis([0,6,0,700]) %ȷ��x����y���ͼ��С 

%%
% EMPGA_2
load EMPGA_2.mat
x=1:1:36;%x���ϵ����ݣ���һ��ֵ�������ݿ�ʼ���ڶ���ֵ��������������ֵ������ֹ 
normalizedMSE=normalizeData(MSE_all{1}(1:36)); %a����yֵ
plot(x,normalizedMSE,'-*b'); %���ԣ���ɫ����� axis([0,6,0,700]) %ȷ��x����y���ͼ��С 

%%
set(gca,'XTick',[0:2:40]) %x�᷶Χ1-6�����1 
set(gca,'YTick',[0:0.1:1]) %y�᷶Χ0-700�����100 
axis([0,40,0,1]); %����1��xmin������2��xmax������3��ymin������4��ymax
legend('Iris','Wine','Data User Modeling','Movement Libras','Ecoli','Wine Quality Red','EMGPA1','EMGPA2'); %���ϽǱ�ע xlabel('���') %x���������� ylabel('ʱ�䣨ms��') %y����������
