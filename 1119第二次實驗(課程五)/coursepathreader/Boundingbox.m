clc;
clear;
close all;
Bounding_box=500;
allFile = dir('*.tif');
for k=1:1:length(allFile)
    pic=imread(allFile(k).name);%��C�@�itif�Ϥ����B�z
    pic=pic>0;                  %pic���I�j��0���ܴN�Oture,��1  
    [x,y]=find(pic);            %��X�x�}X�����Ҧ��D�s�����A�ñN�o�Ǥ��������ޭȶ��[x,y]   
    rtmap=zeros(Bounding_box);  %�s�y�@�Ӫťժ��x�}
    xminimum=min(x);            %x���̤p�y��
    yminimum=min(y);            %y���̤p�y��
    xmaximum=max(x);            %x���̤j�y��
    ymaximum=max(y);            %y���̤j�y��
    x=x-xminimum+1;               %�Ҧ��y�д�h�̤p��,���Ϥ��i�K�b(1,1)�W
    y=y-yminimum+1;               %�Ҧ��y�д�h�̤p��,���Ϥ��i�K�b(1,1)�W
    x_magnification=(Bounding_box-2)/(xmaximum-xminimum); %�ݣA�n��j�h�֭� -2�O���F��ceil���W�[�@
    y_magnification=(Bounding_box-2)/(ymaximum-yminimum); %�ݣB�n��j�h�֭�
    x_magnify=ceil(x*x_magnification);    %��j�A   ��ceil�O��floor�y�з|��0��
    y_magnify =ceil(y*y_magnification);   %��j�B
    %figure,plot(y_magnify,-x_magnify,'x'),axis equal,axis tight     %show�X��������

    for j=1:1:length(x_magnify)            %��۹���X,Y�b�g�irtmap��,�H�K���G���ť߸�
            rtmap(x_magnify(j,1),y_magnify(j,1))=1;
    end
    subplot(3,3,k),imshow(rtmap)     %show�X��J�ťկx�}�Ϥ�
    fmapq{k}=abs(fft2(rtmap));
    %figure,subplot(3,3,k),imshow(abs(log(abs(fmapq{i}))),[],'notruesize'),title('fft2');
    fmapq{k}= fmapq{k}/ fmapq{k}(1,1);
    fmapq{k}(1,1)=0;
end

originpic=9;%���

figure,
for picnum=1:1:originpic-1
       sum=0;
    for i=1:1:size(rtmap,1)
        for j=1:1:size(rtmap,2)
            Disp2o=sqrt((fmapq{1,picnum}(i,j)-fmapq{1,originpic}(i,j))* (fmapq{1,picnum}(i,j)-fmapq{1,originpic}(i,j)));
            sum=Disp2o+sum;
        end
    end
    fftdist(1,picnum)=sum;
    subplot(3,3,picnum),imshow(log(abs(fftshift(fmapq{picnum}))),[],'notruesize'),title('fft2');
end
    subplot(3,3,9),imshow(log(abs(fftshift(fmapq{9}))),[],'notruesize'),title('fft2');
fftdistsmaller=fftdist/10000


