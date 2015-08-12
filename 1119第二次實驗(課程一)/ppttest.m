clc;
clear;
close all;
Bounding_box=700;
pic=imread('5762529972191233.tif');%對每一張tif圖片做處理
pic=pic>0;                  %pic中點大於0的話就是ture,給1     
            [x,y]=find(pic);            %找出矩陣X中的所有非零元素，並將這些元素的索引值填到[x,y]            
            mx=0;                       %給mx初始值            
            x_lenth=length(x);          %求出所有點的數量
            point_distance=x_lenth/300;            %取300點，所有點數/取樣300點，即是每point_distance多少點取一次
            distance=1:point_distance:length(x);   %取點距離
            x1=x(floor(distance));                 %紀錄取完300點的x座標
            y1=y(floor(distance));                 %紀錄取完300點的y座標 
            figure,plot(y1,-x1,'x')