clc;
clear;
close all;
cut_row=2;  %有幾列，不是切幾刀
cut_col=2;  %有幾行
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
count=0;
for i=1:1:540
    for j=1:1:960
        temp(j,i)=pic(j,i);
        
        if(pic(j,i)>0)
            count=count+1;
        end
    end
end
every_pic_point_count(1,1)=count;
figure,imshow(temp);
%----------------計算每個切格裡面有多少個pixel是有值的end--------------------