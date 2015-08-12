%產出point檔
clc;
clear;
close all;
allFolder =dir;  %顯示某個資料夾的內容

for f=3:1:length(allFolder)   %用 length來判斷檔案的多寡
    if allFolder(f).isdir==1  %如果是資料夾的話
        cd (allFolder(f).name);%cd到那個資料夾下
        allFile = dir('*.tif');
        for k=1:1:length(allFile)
            pic=imread(allFile(k).name);%對每一張tif圖片做處理
            pic=pic>0;                  %pic中點大於0的話就是ture,給1     
            [x,y]=find(pic);            %找出矩陣X中的所有非零元素，並將這些元素的索引值填到[x,y]            
            mx=0;                       %給mx初始值            
            x_lenth=length(x);          %求出所有點的數量
            %point_distance=x_lenth/300;            %取300點，所有點數/取樣300點，即是每point_distance多少點取一次
            %distance=1:point_distance:length(x);   %取點距離
            distance=1:1:length(x);                %不做取點動作
            x1=x(floor(distance));                 %紀錄取完300點的x座標
            y1=y(floor(distance));                 %紀錄取完300點的y座標          
       for xi=1:1:length(x1)                       %x座標跟y座標所有點減去x(1)及y(1)每個算出距離後，找出最大值
            [xs,n]=max(sqrt((x1-x1(xi)).*(x1-x1(xi))+(y1-y1(xi)).*(y1-y1(xi))));   %找出兩點之間最大距離
            if xs>mx            %當有算出數值比較大時，記錄下來
                mx=xs;          %最新距離給mx，讓他可以繼續跟下一個比較
            end
       end
       maxlength(1,k)=mx;
       x_barycentre=x1-mean(x1);     %求出所有x座標的平均值，找出重心，所有X點減去重心，讓重心點在(0,0)
       y_barycentre=y1-mean(y1);     %求出所有y座標的平均值，找出重心，所有y點減去重心，讓重心點在(0,0)
       %subplot(1,length(allFile),k),plot(y_barycentre,-x_barycentre,'x'),axis equal,axis tight   %將所有圖中心點移置重心，做位置正規化
       x_size=x_barycentre/mx;       %將所有位置正規化的x座標大小正規化，所有點座標除去最遠距離  
       y_size=y_barycentre/mx;       %將所有位置正規化的y座標大小正規化，所有點座標除去最遠距離 
       %subplot(1,length(allFile),k),plot(y_size,-x_size,'x'),axis equal,axis tight     %將所有點除去最遠距離，做大小正規化   
       subplot(3,3,k),plot(y_size,-x_size,'x'),axis equal,axis tight     %將所有點除去最遠距離，做大小正規化 
       if(k==9)
           figure,plot(y_size,-x_size,'x'),axis equal,axis tight
       end
       sx=[x_size,y_size];
       fnMat = allFile(k).name;    
       %open link file
       fpLink = fopen(['..\' allFolder(f).name num2str(k) 'a.point' ], 'wt' );
       fprintf( fpLink, 'Model=%d\n', size(sx,1) );
       for i=1:size(sx,1)
          fprintf( fpLink, '%d\t%25.20f\t%25.20f\n', i-1, sx(i, 1), sx(i, 2) );
       end;
       clear sx;
       fclose( fpLink );
        end
         cd ..;        
    end    
end
%做2維傅立葉
allPoint = dir('*.point');
for i=1:1:length(allPoint)
    fid=fopen(allPoint(i).name);   %一筆一筆取出資料的名稱
    one=fscanf(fid,'Model=%d ', 1);%d代表使用整數,看取幾筆資料
    data=fscanf(fid,'%f', [3 inf]);   %最後項為size，表示讀入三列資料，直到檔案底，inf代表EOF(End of File)，%f代表具有浮點之數據
    data=data';%轉置                      讀出所有POINT的資料
    data=data(:,2:3);
    allpicmaxlen=max(max(maxlength));    %找出所有圖形中哪個圖形的最長邊最長
    allpicminlen=min(min(maxlength));    %找出所有圖形中哪個圖形的最長邊最短
    %data=ceil(data*allpicmaxlen);        %所有座標點乘上最長邊，放大比例
    data=ceil(data*allpicminlen*0.9);        %所有座標點乘上最短邊，放大比例
    data=data+ceil(allpicminlen/2);          %把整張圖挪到第一象限
    rtmap=zeros(ceil(allpicmaxlen));%製造一個空白的矩陣
    %figure,plot(data(:,2),-data(:,1)+max(max(data(:,1))),'o'),axis equal,axis tight;%plot出每個圖形放大並位移至第一象限
    
    for j=1:1:length(data)            %把相對應X,Y軸寫進rtmap裡,以便做二維傅立葉
        if(rtmap(data(j,1),data(j,2))~=1)
            rtmap(data(j,1),data(j,2))=rtmap(data(j,1),data(j,2))+1;
        end      
    end
    figure,imshow(rtmap);     %印出在二進位圖 
    fmapq{i}=abs(fft2(rtmap));
    %figure,subplot(3,3,k),imshow(abs(log(abs(fmapq{i}))),[],'notruesize'),title('fft2');
    fmapq{i}= fmapq{i}/ fmapq{i}(1,1);
    fmapq{i}(1,1)=0;
    fclose(fid);
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
    subplot(3,3,picnum),imshow(log(1+abs(fftshift(fmapq{picnum}))),[],'notruesize'),title('fft2');
end
    subplot(3,3,9),imshow(log(1+abs(fftshift(fmapq{9}))),[],'notruesize'),title('fft2');
fftdistsmaller=fftdist/10000




