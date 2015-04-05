clear all;
close all;
clc;

tif_pic = dir('6297005097746432.tif');
pic=imread(tif_pic(1).name);

pic=pic>0;
[x,y]=find(pic);
xminimum=min(x);            %x取最小座標
yminimum=min(y);            %y取最小座標
xmaximum=max(x);            %x取最大座標
ymaximum=max(y);            %y取最大座標
x=x-xminimum+1;               %所有座標減去最小值,讓圖片可貼在(1,1)上
y=y-yminimum+1;               %所有座標減去最小值,讓圖片可貼在(1,1)上


sx=[x,y];
 [sort_y,ind]=sort(sx(:,2));%排序y軸,並記下index
 sort_y(:,2)=sort_y;
 %-----------排序y軸，並透過索引將y軸對應到對的x軸-----------------
 for i=1:1:size(sort_y,1)  %排序X軸，並透過索引將y軸對應到對的x軸
     sort_y(i,1)=sx(ind(i,1),1);
 end
%-------------------------------------------------------------- 
i=1;

while(i<size(sort_y,1))
temp=[];
pos=find(sort_y(:,2)==sort_y(i,2));
    if(size(pos,1)>1)
        k=1;
        for j=2:1:size(pos,1)
            if(abs(sort_y(pos(1,1),1)-sort_y(pos(j,1),1))==1)
                temp(k,1)=pos(j,1);  
                k=k+1;
            end
        end
    end
    
 if(isempty(temp)==0)
        for s=1:1:size(temp,1)
            sort_y(temp(s,1),:)=[];
        end
 end
 
    i=i+1
end

%-----------------------sort_y匯出來--------------------------- 
 figure
 for i=1:1:size(sort_y,1)
    plot(sort_y(i,2),-sort_y(i,1),'o');
     hold on;
 end
 %------------------------------------------------------------ 
 

 
 
 
 
 %--------------------------開始取樣點------------------------

 x1=sort_y(:,1);   %把排序好的分別給x軸y軸
 y1=sort_y(:,2);   %把排序好的分別給x軸y軸
 x_lenth=length(sort_y);
 point_distance_choose=x_lenth/300;            %取300點，所有點數/取樣300點，即是每point_distance多少點取一次
 distance=1:point_distance_choose:length(sort_y);   %取點距離
        
 x11=x1(floor(distance));                 %紀錄取完300點的x座標
 y11=y1(floor(distance));                 %紀錄取完300點的y座標
 
 sx1=[x11,y11];
 
 
 %-----------------------sort_y匯出來--------------------------- 
 figure
 for i=1:1:size(sx1,1)
    plot(sx1(i,2),-sx1(i,1),'o');
     hold on;
 end
 %------------------------------------------------------------ 


