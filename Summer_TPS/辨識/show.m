clc;
clear;
close all;
fid=fopen('bicycle1_bicycle2.match');
one=fscanf(fid,'Model=%d ', 1);
A=fscanf(fid,'%f', [3 inf]);  %最後項為size，表示讀入二列資料，直到檔案底
A=A';

one=fscanf(fid,'Deform=%d ', 1);
B=fscanf(fid,'%f', [3 inf]);  %最後項為size，表示讀入二列資料，直到檔案底
B=B';

one=fscanf(fid,'Match=%d ', 1);
C=fscanf(fid,'%f', [2 inf]);  %最後項為size，表示讀入二列資料，直到檔案底
C=C';
fclose(fid);

    figure,plot(A(:,2),A(:,3),'o');
   hold on;
     plot(B(:,2),B(:,3),'X','Color','m');
     hold on;
     
     [csize,cline]=size(C);
     for i=1:1:csize
         x=[A(C(i,1)+1,2),B(C(i,2)+1,2)];
         y=[A(C(i,1)+1,3),B(C(i,2)+1,3)];
         line(x,y,'Color','y','LineWidth',1);
         hold on;
     end
   axis equal,axis tight;