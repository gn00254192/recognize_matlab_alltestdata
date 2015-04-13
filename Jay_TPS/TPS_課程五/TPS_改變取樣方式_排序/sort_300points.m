clear all;
close all;
clc;
Bounding_box=500;
allFile = dir('*.tif');
for k=1:1:length(allFile)
    pic=imread(allFile(k).name);%對每一張tif圖片做處理
    pic=double(pic);
    pic=pic>0;
    [x,y]=find(pic);
    xminimum=min(x);            %x取最小座標
    yminimum=min(y);            %y取最小座標
    xmaximum=max(x);            %x取最大座標
    ymaximum=max(y);            %y取最大座標
    x=x-xminimum+1;               %所有座標減去最小值,讓圖片可貼在(1,1)上
    y=y-yminimum+1;               %所有座標減去最小值,讓圖片可貼在(1,1)上
    x_magnification=(Bounding_box-1)/(xmaximum-xminimum); %看ｘ要放大多少倍 -2是為了怕ceil往上加一
    y_magnification=(Bounding_box-1)/(ymaximum-yminimum); %看ｙ要放大多少倍
    x_magnify=ceil(x*x_magnification);    %放大ｘ   用ceil是怕floor座標會有0值
    y_magnify =ceil(y*y_magnification);   %放大ｙ

    sx=[x_magnify,y_magnify];

    [sort_coordinates,ind]=sort(sx(:,1));%排序x軸,並記下index

    for i=1:1:size(sort_coordinates,1)  %排序X軸，並透過索引將y軸對應到對的x軸
        sort_coordinates(i,2)=sx(ind(i,1),2);
    end
  
 
 
 %---------------------改進後的取點---------------------------------------------
    x1=sort_coordinates(:,1);   %把排序好的分別給x軸y軸
    y1=sort_coordinates(:,2);   %把排序好的分別給x軸y軸
    x_lenth=length(sort_coordinates);
    point_distance=x_lenth/300;            %取300點，所有點數/取樣300點，即是每point_distance多少點取一次
    distance=1:point_distance:length(x);   %取點距離
        
    x2=x1(floor(distance));                 %紀錄取完300點的x座標
    y2=y1(floor(distance));                 %紀錄取完300點的y座標
 
    sx2=[x2,y2];
    
    fnMat = allFile(k).name;    
    %open link file
    fpLink = fopen([ 'shadow_sort_300point' num2str(k) 'a.point' ], 'wt' );
    fprintf( fpLink, 'Model=%d\n', size(sx2,1) );
    for i=1:size(sx2,1)
       fprintf( fpLink, '%d\t%25.20f\t%25.20f\n', i-1, sx2(i, 1), sx2(i, 2) );
    end;
    
     figure
     for i=1:1:size(sx2,1)
         plot(sx2(i,2),-sx2(i,1),'o');
        hold on;
    end
    
    clear sx2;
    fclose( fpLink );
    
    
 %-------------------------------------------------------------------------

end
 