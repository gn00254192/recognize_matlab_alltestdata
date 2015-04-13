clear all;
close all;
clc;
tif_pic = dir('6297005097746432.tif');
pic=imread(tif_pic(1).name);
pic=double(pic);
pic=pic>0;
[x,y]=find(pic);
xminimum=min(x);            %x取最小座標
yminimum=min(y);            %y取最小座標
xmaximum=max(x);            %x取最大座標
ymaximum=max(y);            %y取最大座標
x=x-xminimum+1;               %所有座標減去最小值,讓圖片可貼在(1,1)上
y=y-yminimum+1;               %所有座標減去最小值,讓圖片可貼在(1,1)上
sx=[x,y];

[sort_coordinates,ind]=sort(sx(:,1));%排序x軸,並記下index

 for i=1:1:size(sort_coordinates,1)  %排序X軸，並透過索引將y軸對應到對的x軸
     sort_coordinates(i,2)=sx(ind(i,1),2);
 end

  figure
 for i=1:1:size(sort_coordinates,1)  %plot出來看
     plot(sort_coordinates(i,2),-sort_coordinates(i,1),'o');
     hold on;
 end
 
 
 %----------------開始算點彼此之間的距離----------------------------------

 point_distance(1,1) =sqrt((sort_coordinates(1,1)- sort_coordinates(2,1))^2+ (sort_coordinates(1,2)- sort_coordinates(2,2))^2);
 
 j=1;
 for i=2:1:size(sort_coordinates,1)-1
      point_distance(i,1) =sqrt((sort_coordinates(i,1)- sort_coordinates(i+1,1))^2+ (sort_coordinates(i,2)- sort_coordinates(i+1,2))^2);
      %中--後
      
      
      if( point_distance(i,1)>1&& point_distance(i,1)<10)
          temp(j,1)=i;
          j=j+1;
      end
 end
 point_distance=uint8(point_distance);     %看距離分布在那些位置上
 figure,imhist(point_distance)
for i=1:1:size(point_distance,1)
    if(point_distance(i,1)>50)
        point_distance(i,1)=0;
    end
end
point_distance=uint8(point_distance);     %看距離分布在那些位置上
 figure,imhist(point_distance),axis tight
  set(gca,'XLim',[0 55]);
%---------------add_point_test----------------------------------------- 
%j=1;
%for i=1:1:1
%    A=[1 3];
%    B=[1 3];
%    if(abs(A(1,1)-B(1,1))==0 && abs(A(1,2)-B(1,2))>0 )  %假設x一樣   y變化了
%         y_temp=abs(A(1,2)-B(1,2));                %y相減給y_temp
%         k=1;                                      %等等給while當判斷式用
%         firstone=A(1,2);                          %把y數值給firstone,等等要累加用
%        while(k<y_temp)
%            firstone=firstone+1;                   %將y累加下去
%            add_point(j,2)=firstone;               %把y值給add_point
%            add_point(j,1)=A(1,1);                 %把x值給add_point
%            k=k+1;
%            j=j+1;
%        end
%    else                                          %如果x變化了,記錄下來之後再處理
%        x_and_y_allchange(i,1)=1;
%    end
%end
%--------------------------------------------------------------------------

%-------------------------------------add_point---------------------------
j=1;
r=1;
for i=1:1:size(temp,1)
     if(abs(sort_coordinates(temp(i,1),1)-sort_coordinates(temp(i,1)+1,1))==0 && abs(sort_coordinates(temp(i,1),2)-sort_coordinates(temp(i,1)+1,2))>0 )  %假設x一樣   y變化了
         y_temp=abs(sort_coordinates(temp(i,1),2)-sort_coordinates(temp(i,1)+1,2));
         k=1;
         firstone=sort_coordinates(temp(i,1),2);
         while(k<y_temp)
             firstone=firstone+1;
             add_point(j,2)=firstone;
             add_point(j,1)=sort_coordinates(temp(i,1),1);
             k=k+1;
             j=j+1;
         end
     else
         x_and_y_allchange(r,1)=i;
     end
end
%------------------------------------------------------------------------- 
add_total_point=[sort_coordinates;add_point];%將原本的跟新增的點合併起來


%-------------------------------再ｓｏｒｔ一次------------------------------
[sort_add_total_point,ind2]=sort(add_total_point(:,1));%排序x軸,並記下index

 for i=1:1:size(sort_add_total_point,1)  %排序X軸，並透過索引將y軸對應到對的x軸
     sort_add_total_point(i,2)=add_total_point(ind2(i,1),2);
 end
%-------------------------------------------------------------------------
  figure
 for i=1:1:size(sort_add_total_point,1)  %plot出來看
     plot(sort_add_total_point(i,2),-sort_add_total_point(i,1),'o');
     hold on;
 end
  
 
  %---------------------取點(不增加點數)---------------------------------------------
 x1=sort_coordinates(:,1);   %把排序好的分別給x軸y軸
 y1=sort_coordinates(:,2);   %把排序好的分別給x軸y軸
 x_lenth=length(sort_coordinates);
 point_distance_choose=x_lenth/300;            %取300點，所有點數/取樣300點，即是每point_distance多少點取一次
 distance=1:point_distance_choose:length(x);   %取點距離
        
 x11=x1(floor(distance));                 %紀錄取完300點的x座標
 y11=y1(floor(distance));                 %紀錄取完300點的y座標
 
 sx1=[x11,y11];
 
% figure
 %for i=1:1:size(sx1,1)
 %    plot(sx1(i,2),-sx1(i,1),'o');
 %    hold on;
 %end
 %-------------------------------------------------------------------------
 
 
  %---------------------取點（增加點數）---------------------------------------------
 x1=sort_add_total_point(:,1);   %把排序好的分別給x軸y軸
 y1=sort_add_total_point(:,2);   %把排序好的分別給x軸y軸
 x_lenth=length(sort_add_total_point);
 point_distance_choose=x_lenth/300;            %取300點，所有點數/取樣300點，即是每point_distance多少點取一次
 distance=1:point_distance_choose:length(sort_add_total_point);   %取點距離
        
 x2=x1(floor(distance));                 %紀錄取完300點的x座標
 y2=y1(floor(distance));                 %紀錄取完300點的y座標
 
 sx2=[x2,y2];
 
% figure
 %for i=1:1:size(sx2,1)
 %    plot(sx2(i,2),-sx2(i,1),'o');
 %    hold on;
% end
 %-------------------------------------------------------------------------
 
 
 
 
 