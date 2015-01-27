%將原圖轉成二質化影像
clc;
clear;
pic=imread('test.png');
pic=rgb2gray(pic);
width=size(pic,2); 
lenght=size(imread('test.png'),1);

figure,imshow(pic)

for i=1:1:lenght
    for j=1:1:width
        if(pic(i,j)==0)
       picf(i,j)=1; 
        else
         picf(i,j)=0;
            
        end
    end
end
figure,imshow(picf);
imwrite(picf,['test.tif' ],'tif')
