clc;
close all;
clear;
pic=imread('test_origin.png');
pic=rgb2gray(pic);
%result_logic=imresize(pic,4);
%imwrite(result_logic,['result_origin.tif' ],'tif')
r=pic<190;
se = strel('disk',1);        
erodedBW = imerode(r,se);
imshow(r), figure, imshow(erodedBW)
%se = strel('disk',2);        
%erodedBW = imerode(r,se);
%imshow(r), figure, imshow(erodedBW)
imwrite(r,['origin_pic.tif' ],'tif')
%pic2=imread('result_origin.tif');
%pic23(:,:,1)=pic2(:,:,1);
%pic23(:,:,2)=pic2(:,:,2);
%pic23(:,:,3)=pic2(:,:,3);
%pic2=rgb2gray(pic23);
%r2=pic<185;
%figure,imshow(r2)