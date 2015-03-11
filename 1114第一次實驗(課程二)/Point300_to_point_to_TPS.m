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
            point_distance=x_lenth/300;            %取300點，所有點數/取樣300點，即是每point_distance多少點取一次
            distance=1:point_distance:length(x);   %取點距離
            %distance=1:1:length(x);                %不做取點動作
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
       %if(k==9)
        %   figure,plot(y_size,-x_size,'x'),axis equal,axis tight
       %end
       sx=[x_size,y_size];
       fnMat = allFile(k).name;    
       %open link file
       fpLink = fopen(['..\' 'drawline' num2str(k) 'a.point' ], 'wt' );
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







