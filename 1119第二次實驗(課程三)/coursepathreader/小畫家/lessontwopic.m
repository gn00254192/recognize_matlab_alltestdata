%將原圖轉成二質化影像
clc;
clear;
pic=imread('circle.png');
picccc=rgb2gray(pic)
width=size(pic,2); 
lenght=size(imread('circle.png'),1);

figure,imshow(pic,[])

for i=1:1:lenght
    for j=1:1:width
        if(picccc(i,j)==0)
       picf(i,j)=1; 
        else
         picf(i,j)=0;
            
        end
    end
end
picf=uint8(255*picf);
figure,imshow(picf,[]);
imwrite(picf,['circle.tif' ],'tif')
