close all;
clc;
clear;
point=dir('face1a.point');
fid=fopen(point.name);
 one=fscanf(fid,'Model=%d ', 1);
 A=fscanf(fid,'%f', [3 inf]);  %最後項為size，表示讀入二列資料，直到檔案底
 A=A';
 figure
 for i=1:1:size(A,1)
     plot(A(i,3),-A(i,2),'o');
     hold on;
 end

