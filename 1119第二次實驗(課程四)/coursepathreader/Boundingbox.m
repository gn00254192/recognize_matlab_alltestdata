clc;
clear;
close all;
Bounding_box=500;
allFile = dir('*.tif');
for k=1:1:length(allFile)
    pic=imread(allFile(k).name);%對每一張tif圖片做處理
    pic=pic>0;                  %pic中點大於0的話就是ture,給1  
    [x,y]=find(pic);            %找出矩陣X中的所有非零元素，並將這些元素的索引值填到[x,y]   
    rtmap=zeros(Bounding_box);  %製造一個空白的矩陣
    xminimum=min(x);            %x取最小座標
    yminimum=min(y);            %y取最小座標
    xmaximum=max(x);            %x取最大座標
    ymaximum=max(y);            %y取最大座標
    x=x-xminimum+1;               %所有座標減去最小值,讓圖片可貼在(1,1)上
    y=y-yminimum+1;               %所有座標減去最小值,讓圖片可貼在(1,1)上
    x_magnification=(Bounding_box-2)/(xmaximum-xminimum); %看ｘ要放大多少倍 -2是為了怕ceil往上加一
    y_magnification=(Bounding_box-2)/(ymaximum-yminimum); %看ｙ要放大多少倍
    x_magnify=ceil(x*x_magnification);    %放大ｘ   用ceil是怕floor座標會有0值
    y_magnify =ceil(y*y_magnification);   %放大ｙ
    %figure,plot(y_magnify,-x_magnify,'x'),axis equal,axis tight     %show出ｐｌｏｔ

    for j=1:1:length(x_magnify)            %把相對應X,Y軸寫進rtmap裡,以便做二維傅立葉
            rtmap(x_magnify(j,1),y_magnify(j,1))=1;
    end
    subplot(3,3,k),imshow(rtmap)     %show出放入空白矩陣圖片
    fmapq{k}=abs(fft2(rtmap));
    %figure,subplot(3,3,k),imshow(abs(log(abs(fmapq{i}))),[],'notruesize'),title('fft2');
    fmapq{k}= fmapq{k}/ fmapq{k}(1,1);
    fmapq{k}(1,1)=0;
end

originpic=9;%原圖

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


