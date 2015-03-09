clear;
clc;
close all;
allFile = dir('*.match');
MIN=10000;
MINid=0;
n=60;
n1=59;
for F=0:1:(n-1)
    MIN(F+1)=10000;
    MINid(F+1)=0;
    
    for f=1:1:n1
        k=0;
        fid=fopen(allFile(F*n1+f).name);
        name{F+1,1}= allFile(F*n1+f).name(1:findstr( allFile(F*n1+f).name,'_')-3);
        match= allFile(F*n1+f).name(findstr( allFile(F*n1+f).name,'_')+1:length(allFile(F*n1+f).name)-8);
        if length(name{F+1,1})==length(match)
            if  allFile(F*n1+f).name(findstr( allFile(F*n1+f).name,'_')-2)~=allFile(F*n1+f).name(length(allFile(F*n1+f).name)-7)
                M=~sum(abs(name{F+1,1}-match));
            else
                k=f;
                M=0;
            end
        else
            M=0;
        end
        
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
        
        cost=0;
        for ic=1:1:one
            cost=cost+sqrt((A(C(ic,1)+1,2)-B(C(ic,2)+1,2))^2+(A(C(ic,1)+1,3)-B(C(ic,2)+1,3))^2);
        end
        cost=(cost*300) /one;
        Cost(F+1,f)=cost;
        if  k==f
            Cost(F+1,k)=10000;
            cost=10000;
        end
        if cost< MIN(F+1)
            MIN(F+1)=cost;
            name{F+1,3}=f;
            name{F+1,4}=match;
            name{F+1,2}=M;
            rate(F+1)=M;
        end
    end
end
for i=1:1:(length(rate)/2)
    if MIN(i*2)<MIN(i*2-1)
%         MIN(i*2-1)= MIN(i*2);
%         name{i*2-1,3}=name{i*2,3};
%         name{i*2-1,4}=name{i*2,4};
        name{i*2-1,2}=name{i*2,2};
        rate(i*2-1)=rate(i*2);
    else
%         MIN(i*2)= MIN(i*2-1);
%         name{i*2,3}=name{i*2-1,3};
%         name{i*2,4}=name{i*2-1,4};
        name{i*2,2}=name{i*2-1,2};
        rate(i*2)=rate(i*2-1);
    end
end
sum(rate)/60