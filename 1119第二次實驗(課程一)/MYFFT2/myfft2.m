clc;
clear;
close all;

allFile = dir('*.point');
for i=1:1:length(allFile)
    fid=fopen(allFile(i).name);
    one=fscanf(fid,'Model=%d ', 1);
    A=fscanf(fid,'%f', [3 inf]);  %最後項為size，表示讀入二列資料，直到檔案底
    A=A';
    A=A(:,2:3);
    A=floor(A*64);
    [THETA,RHO] = cart2pol(A(:,1),A(:,2));
    RHO=floor(RHO)+1;
    THETA=floor((THETA+pi)*10+1);
    rtmap=zeros(65);
    for j=1:1:length(THETA)
        rtmap(RHO(j),THETA(j))=rtmap(RHO(j),THETA(j))+1;
    end
  %   figure,plot(A(:,2),A(:,1),'o'),axis equal,axis tight;
     imshow(rtmap)
    fclose(fid);
    fmapq{i}=abs(fft2(rtmap));
    fmapq{i}= fmapq{i}/ fmapq{i}(1,1);
    fmapq{i}(1,1)=0;
     fmapq{i}= fmapq{i}(1:4,1:6);
end

originpic=9;%原圖

for picnum=1:1:originpic-1
       sum=0;
    for i=1:1:4
        for j=1:1:6
            Disp2o=sqrt((fmapq{1,picnum}(i,j)-fmapq{1,originpic}(i,j))* (fmapq{1,picnum}(i,j)-fmapq{1,originpic}(i,j)));
            sum=Disp2o+sum;
        end
    end
    distance(1,picnum)=sum;
end







    


