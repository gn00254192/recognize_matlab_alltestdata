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
    rtmap_300point=zeros(Bounding_box);  %製造一個空白的矩陣
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

    x_lenth=length(x_magnify);
    point_distance=x_lenth/300;            %取300點，所有點數/取樣300點，即是每point_distance多少點取一次
    distance=1:point_distance:length(x);   %取點距離
        
    x1=x_magnify(floor(distance));                 %紀錄取完300點的x座標
    y1=y_magnify(floor(distance));                 %紀錄取完300點的y座標
    
    for j=1:1:length(x_magnify)            %把相對應X,Y軸寫進rtmap裡,以便做二維傅立葉
            rtmap(x_magnify(j,1),y_magnify(j,1))=1;
    end
        for j=1:1:length(x1)            %把相對應X,Y軸寫進rtmap裡,以便做二維傅立葉
            rtmap_300point(x1(j,1),y1(j,1))=1;
    end
    %subplot(3,3,k),imshow(rtmap_300point)     %show出放入空白矩陣圖片
    figure,imshow(rtmap_300point);
    
    
       sx=[x1,y1];
       fnMat = allFile(k).name;    
       %open link file
       fpLink = fopen(['..\' 'Picasso' num2str(k) 'a.point' ], 'wt' );
       fprintf( fpLink, 'Model=%d\n', size(sx,1) );
       for i=1:size(sx,1)
          fprintf( fpLink, '%d\t%25.20f\t%25.20f\n', i-1, sx(i, 1), sx(i, 2) );
       end;
       clear sx;
       fclose( fpLink );
end
              
   
   





