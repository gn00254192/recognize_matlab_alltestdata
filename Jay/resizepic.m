close all;
clc;
%pic=imread('test.PNG');
%figure,imshow(pic);
%D1 = imresize(pic,[321*2 230*2],'bilinear');
%figure,imshow(D1);
%E1 = imresize(pic,[321*2 230*2],'bicubic');
%figure,imshow(E1);
%result_logic=imresize(pic,4);
%figure,imshow(result_logic);
%result_logic=rgb2gray(result_logic);
%figure,imshow(result_logic);
%r=result_logic<200;
%imshow(result_logic),figure,imshow(result_logic<200);
%figure,imshow(r);


%se = strel('disk',1);        
%erodedBW = imerode(r,se);
%imshow(r), figure, imshow(erodedBW)
clc;
close all;
clear;
pic=imread('111.jpg');
pic=rgb2gray(pic);
%result_logic=imresize(pic,6);
r=pic<80;
%se = strel('disk',2);        
%erodedBW = imerode(r,se);
 figure, imshow(r,[])




