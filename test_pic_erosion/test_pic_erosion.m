%產出point檔
clc;
clear;
tic
allFolder =dir;  %顯示某個資料夾的內容
for f=3:1:length(allFolder)   %用 length來判斷檔案的多寡
    if allFolder(f).isdir==1  %如果是資料夾的話
        cd (allFolder(f).name);%cd到那個資料夾下
        allFile = dir('6198976764182528.tif');
        for k=1:1:length(allFile)
            pic=imread(allFile(k).name);%對每一張tif圖片做處理
            pic=pic>0;
            a=ones(2,2);
            b=ones(4,4)
           
           % subplot(1,length(allFile),k),imshow(pic);
           figure,imshow(pic),title('原圖');
           imerodepicture=imerode(pic,a);
           figure,imshow(imerodepicture),title('侵蝕');
           c=imdilate(imerodepicture,b);
           figure,imshow(c),title('擴張');
        end
         cd ..;  
    end
end