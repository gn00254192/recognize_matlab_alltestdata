clc;
close all;
clear;
pic=imread('origin.png');
pic=rgb2gray(pic);
result_logic=imresize(pic,4);
r=result_logic<230;
se = strel('disk',2);        
erodedBW = imerode(r,se);
imshow(r), figure, imshow(erodedBW)
imwrite(erodedBW,['origin_pic.tif' ],'tif')