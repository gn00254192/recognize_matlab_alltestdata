clc;
clear;
close all;
select_point=98;

pic=imread('5762529972191233.tif');
%figure,imshow(pic);
Long=size(pic,1);     %看影像有多長
Wide=size(pic,2);     %看影像寬有多寬
mx=0; 
cut_row=30;  %有幾列，不是切幾刀
cut_col=30;  %有幾行

col_interval=floor(Wide/cut_col);  %算出行間距,取floor,剩下的都給最後一個
row_interval=floor(Long/cut_row);  %算出列間距,取floor,剩下的都給最後一個
cut_temp=ones((cut_row+1),(cut_col+1)*2);%創一個0矩陣用來之後放每個矩陣的切點座標

%-------------------------將各個切點座標寫入--------------------------

for j=1:1:cut_row+1
    temp=col_interval;
    for i=4:2:(cut_col+1)*2
        cut_temp(j,i)=temp;
        temp=temp+col_interval;
    end   
end
for j=1:2:(cut_col+1)*2
    temp=row_interval;
    for i=2:1:cut_row+1
        cut_temp(i,j)=temp;
        temp=temp+row_interval;
    end
end

if(cut_temp(1,(cut_col+1)*2)~=Wide || cut_temp(cut_row+1,1)~=Long)
    cut_temp(:,(cut_col+1)*2)=Wide;
    for i=1:2:(cut_col+1)*2
        cut_temp(cut_row+1,i)=Long;
    end
end
%-----------------------將各個切點座標寫入end----------------------------


%----------------計算每個切格裡面有多少個pixel是有值的--------------------
%每一列作完換做下一列,以3*3圖片為例,每張圖片切割順序如下
%1   2   3
%4   5   6
%7   8   9
num_row=1;
for  h=2:1:cut_row+1
    num_col=1;
    for k=4:2:(cut_col+1)*2 
        y1=1;
        count=0;
        for i=num_col:1:cut_temp(1,k) 
            x1=1;
            for j=num_row:1:cut_temp(h,1)
                temp(x1,y1)=pic(j,i);    
                x1=x1+1;
                if(pic(j,i)~=0)
                    count=count+1;
                end
            end
        y1=y1+1;
        end
%        figure,imshow(temp);
        save_pic_cut{h-1,(k/2)-1}=temp;
        save_pixel_count(h-1,(k/2)-1)=count;
        num_col=num_col+col_interval;
    end
    num_row=num_row+row_interval;
end

%----------------計算每個切格裡面有多少個pixel是有值的end--------------------

%----------------測試count有沒有寫錯----------------------
%count=0;
%for i=1:1:1920
%    for j=1:1:1080
%        if(pic(i,j)~=0)
%            count=count+1
%        end
%    end
%end
%----------------測試count有沒有寫錯end----------------------

%----------------計算每張圖要取樣多少點----------------------
total_point=sum(sum(save_pixel_count));
float_select_point=(save_pixel_count/total_point)*select_point;
int_select_point=floor((save_pixel_count/total_point)*select_point);
%----------------計算每張圖要取樣多少點end----------------------

%----------------------將點補滿到足夠---------------------------

while(sum(sum(int_select_point))<select_point)
    decimal_point=float_select_point-int_select_point;
    temp_decimal_point=find(decimal_point==max(max(decimal_point)),1);
    decimal_point(temp_decimal_point)=0;
    int_select_point(temp_decimal_point)=int_select_point(temp_decimal_point)+1;
end
%----------------------將點補滿到足夠end---------------------------

%--------------------------randrom_index-----------------------------
for i=1:1:size(int_select_point,2)
    for j=1:1:size(int_select_point,1)
        %int_select_point(j,i)   %依矩陣索引排列出
        random_index{j,i}=randperm(size(find(save_pic_cut{j,i}),1));
    end    
end
%--------------------------randrom_end--------------------------------

%-------------------------------取樣-----------------------------------
for i=1:1:size(save_pic_cut,2)
    for j=1:1:size(save_pic_cut,1)
        if(isempty(random_index{j,i})==0)
            [x,y]=find(save_pic_cut{j,i});
            for k=1:1:int_select_point(j,i)
                x_temp{j,i}(k,1)=x(random_index{j,i}(1,k));
                y_temp{j,i}(k,1)=y(random_index{j,i}(1,k));
            end
        else
            x_temp{j,i}=[];
            y_temp{j,i}=[];
        end
        %figure,plot(y_temp{j,i},-x_temp{j,i},'o')
    end
end
%-------------------------------取樣end-----------------------------------

%----------------------------將各個取樣圖合併-------------------------------
x=x_temp{1,1};
y=y_temp{1,1};
x_y_merge=[x,y];
for i=2:1:size(save_pic_cut,2)    %處理第一列
    x=x_temp{1,i};
    y=y_temp{1,i}+col_interval*(i-1);
    x_y_temp=[x,y];
    x_y_merge=[x_y_merge;x_y_temp];
end

for i=2:1:size(save_pic_cut,1)     %處理第一行
    x=x_temp{i,1}+row_interval*(i-1);
    y=y_temp{i,1};
    x_y_temp=[x,y];
    x_y_merge=[x_y_merge;x_y_temp];
end

for i=2:1:size(save_pic_cut,2)
    for j=2:1:size(save_pic_cut,1)
        x=x_temp{j,i}+row_interval*(j-1);
        y=y_temp{j,i}+col_interval*(i-1);
        x_y_temp=[x,y];
        x_y_merge=[x_y_merge;x_y_temp];
    end
end
 clear x1 y1 x2 y2
 figure,plot(x_y_merge(:,2),-x_y_merge(:,1),'o'),title([num2str(cut_row),'*',num2str(cut_col)])
  x1=x_y_merge(:,1)
  y1=x_y_merge(:,2)
  
  x2=x_y_merge(:,1)
  y2=x_y_merge(:,2)
    
    
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

       %subplot(1,length(allFile),k),plot(y_size,-x_size,'x'),axis equal,axis tight     %將所有點除去最遠距離，做大小正規化   
      figure,plot(y_barycentre,-x_barycentre,'x'),axis equal,axis tight     %將所有點除去最遠距離，做大小正規化 
      clear x1 y1
       x1(:,1)=y_barycentre
       x1(:,2)=-x_barycentre
       y1=x1;
       save save_face11 x1 y1;
       clear all;
     
     
     
     
     clc;
clear;

select_point=98;

pic=imread('5762529972191233.tif');
%figure,imshow(pic);
Long=size(pic,1);     %看影像有多長
Wide=size(pic,2);     %看影像寬有多寬
mx=0; 
cut_row=30;  %有幾列，不是切幾刀
cut_col=30;  %有幾行

col_interval=floor(Wide/cut_col);  %算出行間距,取floor,剩下的都給最後一個
row_interval=floor(Long/cut_row);  %算出列間距,取floor,剩下的都給最後一個
cut_temp=ones((cut_row+1),(cut_col+1)*2);%創一個0矩陣用來之後放每個矩陣的切點座標

%-------------------------將各個切點座標寫入--------------------------

for j=1:1:cut_row+1
    temp=col_interval;
    for i=4:2:(cut_col+1)*2
        cut_temp(j,i)=temp;
        temp=temp+col_interval;
    end   
end
for j=1:2:(cut_col+1)*2
    temp=row_interval;
    for i=2:1:cut_row+1
        cut_temp(i,j)=temp;
        temp=temp+row_interval;
    end
end

if(cut_temp(1,(cut_col+1)*2)~=Wide || cut_temp(cut_row+1,1)~=Long)
    cut_temp(:,(cut_col+1)*2)=Wide;
    for i=1:2:(cut_col+1)*2
        cut_temp(cut_row+1,i)=Long;
    end
end
%-----------------------將各個切點座標寫入end----------------------------


%----------------計算每個切格裡面有多少個pixel是有值的--------------------
%每一列作完換做下一列,以3*3圖片為例,每張圖片切割順序如下
%1   2   3
%4   5   6
%7   8   9
num_row=1;
for  h=2:1:cut_row+1
    num_col=1;
    for k=4:2:(cut_col+1)*2 
        y1=1;
        count=0;
        for i=num_col:1:cut_temp(1,k) 
            x1=1;
            for j=num_row:1:cut_temp(h,1)
                temp(x1,y1)=pic(j,i);    
                x1=x1+1;
                if(pic(j,i)~=0)
                    count=count+1;
                end
            end
        y1=y1+1;
        end
%        figure,imshow(temp);
        save_pic_cut{h-1,(k/2)-1}=temp;
        save_pixel_count(h-1,(k/2)-1)=count;
        num_col=num_col+col_interval;
    end
    num_row=num_row+row_interval;
end

%----------------計算每個切格裡面有多少個pixel是有值的end--------------------

%----------------測試count有沒有寫錯----------------------
%count=0;
%for i=1:1:1920
%    for j=1:1:1080
%        if(pic(i,j)~=0)
%            count=count+1
%        end
%    end
%end
%----------------測試count有沒有寫錯end----------------------

%----------------計算每張圖要取樣多少點----------------------
total_point=sum(sum(save_pixel_count));
float_select_point=(save_pixel_count/total_point)*select_point;
int_select_point=floor((save_pixel_count/total_point)*select_point);
%----------------計算每張圖要取樣多少點end----------------------

%----------------------將點補滿到足夠---------------------------

while(sum(sum(int_select_point))<select_point)
    decimal_point=float_select_point-int_select_point;
    temp_decimal_point=find(decimal_point==max(max(decimal_point)),1);
    decimal_point(temp_decimal_point)=0;
    int_select_point(temp_decimal_point)=int_select_point(temp_decimal_point)+1;
end
%----------------------將點補滿到足夠end---------------------------

%--------------------------randrom_index-----------------------------
for i=1:1:size(int_select_point,2)
    for j=1:1:size(int_select_point,1)
        %int_select_point(j,i)   %依矩陣索引排列出
        random_index{j,i}=randperm(size(find(save_pic_cut{j,i}),1));
    end    
end
%--------------------------randrom_end--------------------------------

%-------------------------------取樣-----------------------------------
for i=1:1:size(save_pic_cut,2)
    for j=1:1:size(save_pic_cut,1)
        if(isempty(random_index{j,i})==0)
            [x,y]=find(save_pic_cut{j,i});
            for k=1:1:int_select_point(j,i)
                x_temp{j,i}(k,1)=x(random_index{j,i}(1,k));
                y_temp{j,i}(k,1)=y(random_index{j,i}(1,k));
            end
        else
            x_temp{j,i}=[];
            y_temp{j,i}=[];
        end
        %figure,plot(y_temp{j,i},-x_temp{j,i},'o')
    end
end
%-------------------------------取樣end-----------------------------------

%----------------------------將各個取樣圖合併-------------------------------
x=x_temp{1,1};
y=y_temp{1,1};
x_y_merge=[x,y];
for i=2:1:size(save_pic_cut,2)    %處理第一列
    x=x_temp{1,i};
    y=y_temp{1,i}+col_interval*(i-1);
    x_y_temp=[x,y];
    x_y_merge=[x_y_merge;x_y_temp];
end

for i=2:1:size(save_pic_cut,1)     %處理第一行
    x=x_temp{i,1}+row_interval*(i-1);
    y=y_temp{i,1};
    x_y_temp=[x,y];
    x_y_merge=[x_y_merge;x_y_temp];
end

for i=2:1:size(save_pic_cut,2)
    for j=2:1:size(save_pic_cut,1)
        x=x_temp{j,i}+row_interval*(j-1);
        y=y_temp{j,i}+col_interval*(i-1);
        x_y_temp=[x,y];
        x_y_merge=[x_y_merge;x_y_temp];
    end
end
 clear x1 y1 x2 y2
 figure,plot(x_y_merge(:,2),-x_y_merge(:,1),'o'),title([num2str(cut_row),'*',num2str(cut_col)])
  x1=x_y_merge(:,1)
  y1=x_y_merge(:,2)
  
  x2=x_y_merge(:,1)
  y2=x_y_merge(:,2)
    
    
     for xi=1:1:length(x1)                       %x座標跟y座標所有點減去x(1)及y(1)每個算出距離後，找出最大值
            [xs,n]=max(sqrt((x1-x1(xi)).*(x1-x1(xi))+(y1-y1(xi)).*(y1-y1(xi))));   %找出兩點之間最大距離
            if xs>mx            %當有算出數值比較大時，記錄下來
                mx=xs;          %最新距離給mx，讓他可以繼續跟下一個比較
            end
       end
       maxlength(1,k)=mx;
       
       %subplot(1,length(allFile),k),plot(y_barycentre,-x_barycentre,'x'),axis equal,axis tight   %將所有圖中心點移置重心，做位置正規化
       %subplot(1,length(allFile),k),plot(y_size,-x_size,'x'),axis equal,axis tight     %將所有點除去最遠距離，做大小正規化   
      figure,plot(y1,-x1,'x'),axis equal,axis tight     %將所有點除去最遠距離，做大小正規化 
      
       y2(:,1)=y1
       y2(:,2)=-x1
       y2a=y2;
       save save_face22 y2 y2a;
       
       
       load save_face11.mat
       load save_face22.mat
       
       save save_face_notresize y2 y2a x1 y1;
     
     
     
     
     





