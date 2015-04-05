clear;
clc;
close all;
allFile = dir('*.match');
MIN=10000;
MINid=0;
n=9;
n1=8;
for F=0:1:(n-1)
    MIN(F+1)=10000;
    MINid(F+1)=0;
    
    for f=1:1:n1
        k=0;
        fid=fopen(allFile(F*n1+f).name);  %fid指定的檔案代碼
        allFile(F*n1+f).name
        name{F+1,1}= allFile(F*n1+f).name(1:findstr( allFile(F*n1+f).name,'_')-3);  %有哪些圖案,將名稱記下
        match= allFile(F*n1+f).name(findstr( allFile(F*n1+f).name,'_')+1:length(allFile(F*n1+f).name)-8); %match哪個　ｅｘ：[Picasso]
        if length(name{F+1,1})==length(match)        %if match 兩個東西的名字長度一樣
            if  allFile(F*n1+f).name(findstr( allFile(F*n1+f).name,'_')-2)~=allFile(F*n1+f).name(length(allFile(F*n1+f).name)-7)   
                %取出Picasso1a_Picasso7a   a前面的數字
                %ex:此例為 if 1~=7
                M=~sum(abs(name{F+1,1}-match))    %字串相減又都一樣的話   M=字串相減數目相加;   ex:abs(a-A)=32
            else                                  %假設match的東西名字長度一樣,但是取出a前面的數字相同時,k=f,M=0;
                k=f
                M=0
            end
        else                                      %如果 match 兩個東西的長度不同 M=0;
            M=0
        end
                
        %當F=0,f=1時,計算著Picasso1a_Picasso7a
        one=fscanf(fid,'Model=%d ', 1);   %  %d十進位（有正負符號）  %show 出Picasso1a.point數據   300點
        A=fscanf(fid,'%f', [3 inf]);  %最後項為size，表示讀入二列資料，直到檔案底
        A=A';
        one=fscanf(fid,'Deform=%d ', 1);%  %d十進位（有正負符號）  %show 出Picasso7a.point數據   300點
        B=fscanf(fid,'%f', [3 inf]);  %最後項為size，表示讀入二列資料，直到檔案底
        B=B';
        
        one=fscanf(fid,'Match=%d ', 1);%  %d十進位（有正負符號）  %show 出Picasso1a_Picasso7a數據   match到的點數
        C=fscanf(fid,'%f', [2 inf]);  %最後項為size，表示讀入二列資料，直到檔案底
        C=C';
        fclose(fid);
        
        cost=0;
        for ic=1:1:one
            cost=cost+sqrt((A(C(ic,1)+1,2)-B(C(ic,2)+1,2))^2+(A(C(ic,1)+1,3)-B(C(ic,2)+1,3))^2);
        end
        cost=(cost*300) /one;
        Cost(F+1,f)=cost;
        if  k==f    %not 
            Cost(F+1,k)=10000
            cost=10000;             %MIN 一開始10000
        end
        if cost< MIN(F+1)           %cost<10000
            MIN(F+1)=cost;          %MIN(1)=cost
            name{F+1,3}=f;          %name{1,3}=f  f=第幾次對到  第幾個迴圈
            name{F+1,4}=match;      %對到的那個match名稱
            name{F+1,2}=M;          
            rate(F+1)=M;
        end
    end
end
%for i=1:1:(length(ratrae)/2)
%    if MIN(i*2)<MIN(i*2-1)
%         MIN(i*2-1)= MIN(i*2);
%         name{i*2-1,3}=name{i*2,3};
%         name{i*2-1,4}=name{i*2,4};
%        name{i*2-1,2}=name{i*2,2}
%        rate(i*2-1)=rate(i*2)
%    else
%         MIN(i*2)= MIN(i*2-1);
%         name{i*2,3}=name{i*2-1,3};
%         name{i*2,4}=name{i*2-1,4};
%        name{i*2,2}=name{i*2-1,2}
%        rate(i*2)=rate(i*2-1)
%    end
%end
sum(rate)/9

save Cost3 Cost;