clear;
clc;
picture=imread('rice.tif');
figure,subplot(1,2,1),imshow(picture,[]);
graythreashpicture=graythresh(picture);
change=picture>graythreashpicture*255;

subplot(1,2,2),imshow(change,[]);