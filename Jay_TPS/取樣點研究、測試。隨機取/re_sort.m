clc;
clear;
close all;
cut_row=3;  %有幾列，不是切幾刀
cut_col=3;  %有幾行
pic=imread('5762529972191233.tif');
%figure,imshow(pic);
Long=size(pic,1);     %看影像有多長
Wide=size(pic,2);     %看影像寬有多寬
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
        cut_temp(i,j)=temp
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
            end
        y1=y1+1;
        end
        figure,imshow(temp);
        save_pic_cut{h-1,(k/2)-1}=temp;
        num_col=num_col+col_interval
    end
    num_row=num_row+row_interval
end

%----------------計算每個切格裡面有多少個pixel是有值的end--------------------