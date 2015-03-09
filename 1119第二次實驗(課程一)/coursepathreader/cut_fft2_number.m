clc;
clear;
close all;
add_temp=1;
row_size=4
col_size=6
for fft_size_runtimes=1:1:8
Bounding_box=700;
sight_like_one=2;
sight_like_two=5;
sight_like_three=4;
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
    x_magnify=floor(x*x_magnification);    %放大ｘ   用ceil是怕floor座標會有0值
    y_magnify =floor(y*y_magnification);   %放大ｙ

    %figure,plot(y_magnify,-x_magnify,'x'),axis equal,axis tight     %show出ｐｌｏｔ

    for j=1:1:length(x_magnify)            %把相對應X,Y軸寫進rtmap裡,以便做二維傅立葉
        if(x_magnify(j,1)==0&&y_magnify(j,1)~=0)
            x_magnify(j,1)=1;
            rtmap(x_magnify(j,1),y_magnify(j,1))=1;
        end
        
        if(x_magnify(j,1)~=0&&y_magnify(j,1)==0)
            y_magnify(j,1)=1;
            rtmap(x_magnify(j,1),y_magnify(j,1))=1;
        end
        if(x_magnify(j,1)~=0&&y_magnify(j,1)~=0) 
            rtmap(x_magnify(j,1),y_magnify(j,1))=1;
        end
    end
    %subplot(3,3,k),imshow(rtmap)     %show出放入空白矩陣圖片
    fmapq{k}=abs(fft2(rtmap));
    %figure,subplot(3,3,k),imshow(abs(log(abs(fmapq{i}))),[],'notruesize'),title('fft2');
    fmapq{k}= fmapq{k}/ fmapq{k}(1,1);
    fmapq{k}(1,1)=0;
    if(row_size<=700 && col_size<=700)
        fmapq{k}= fmapq{k}(1:row_size,1:col_size);
    else
        fmapq{k}= fmapq{k}(1:Bounding_box,1:Bounding_box);
    end
end

originpic=9;%原圖
if(row_size<=700 && col_size<=700)
%figure,
for picnum=1:1:originpic-1
       sum=0;
    for i=1:1:row_size
        for j=1:1:col_size
            Disp2o=sqrt((fmapq{1,picnum}(i,j)-fmapq{1,originpic}(i,j))* (fmapq{1,picnum}(i,j)-fmapq{1,originpic}(i,j)));
            sum=Disp2o+sum;
        end
    end
    fftdist(1,picnum)=sum;
end
else
    for picnum=1:1:originpic-1
       sum=0;
    for i=1:1:Bounding_box
        for j=1:1:Bounding_box
            Disp2o=sqrt((fmapq{1,picnum}(i,j)-fmapq{1,originpic}(i,j))* (fmapq{1,picnum}(i,j)-fmapq{1,originpic}(i,j)));
            sum=Disp2o+sum;
        end
    end
    fftdist(1,picnum)=sum;
end
end
 
 
    fftdistsmaller_record(add_temp,:)=fftdist;   %所有圖的距離算出
    sorted_record(add_temp,:) = sort(fftdistsmaller_record(add_temp,:));  %將所有距離排序~存在sort裡
    fftdistsmaller=fftdist;
    sorted = sort(fftdistsmaller);
    
    %----------------------------視覺化數據----------------------------------------------
%---------------第一張對才算對---------------------------------------------------
%1.我覺得像的是裡面第幾張圖
%2.取出那一張的距離數據
%3.找他在sort裡的索引
%將索引值存下,接下來跑當bouding=100,200,300.....1000時的狀況
%plot出來


like_value_one=fftdistsmaller(sight_like_one);%2.取出那一張的距離數據
like_final_sort_index(fft_size_runtimes+1)=find(sorted==(like_value_one))%3.找他在sort裡的索引



%---------------前三張有對就算對---------------------------------------------------

    like_value_two=fftdistsmaller(sight_like_two);%取出第二張像的距離數據
    like_value_three=fftdistsmaller(sight_like_three);%取出第三張像的距離數據
    contrast(1,1)=find(sorted==(like_value_one));%找出第一張像的圖片排名在第幾
    contrast(1,2)=find(sorted==(like_value_two));%找出第二張像的圖片排名在第幾
    contrast(1,3)=find(sorted==(like_value_three));%找出第三張像的圖片排名在第幾
    contrast_record(add_temp,:)=contrast;%記錄每一次的排名順序
    contrast_sort=sort(contrast)%將三張圖片的排名排序取出最小排名
    thirdlike_final_sort_index(fft_size_runtimes+1) =contrast_sort(1,1)

    
    add_temp=add_temp+1;
    row_size=row_size*2
    col_size=col_size*2
end
x_label=[0,4 ,8,16,32,64,128,256,700]
subplot(1,1,1);
plot(x_label,like_final_sort_index,'r--*',x_label,thirdlike_final_sort_index,'b:diamond');
xlabel('fft　size');
ylabel('排名');


