clc;
clear;
close all;
Bounding_box=700;
pic=imread('5762529972191233.tif');%��C�@�itif�Ϥ����B�z
pic=pic>0;                  %pic���I�j��0���ܴN�Oture,��1     
            [x,y]=find(pic);            %��X�x�}X�����Ҧ��D�s�����A�ñN�o�Ǥ��������ޭȶ��[x,y]            
            mx=0;                       %��mx��l��            
            x_lenth=length(x);          %�D�X�Ҧ��I���ƶq
            point_distance=x_lenth/300;            %��300�I�A�Ҧ��I��/����300�I�A�Y�O�Cpoint_distance�h���I���@��
            distance=1:point_distance:length(x);   %���I�Z��
            x1=x(floor(distance));                 %��������300�I��x�y��
            y1=y(floor(distance));                 %��������300�I��y�y�� 
            figure,plot(y1,-x1,'x')