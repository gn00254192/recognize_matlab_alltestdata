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
        fid=fopen(allFile(F*n1+f).name);  %fid���w���ɮץN�X
        allFile(F*n1+f).name
        name{F+1,1}= allFile(F*n1+f).name(1:findstr( allFile(F*n1+f).name,'_')-3);  %�����ǹϮ�,�N�W�ٰO�U
        match= allFile(F*n1+f).name(findstr( allFile(F*n1+f).name,'_')+1:length(allFile(F*n1+f).name)-8); %match���ӡ@��A�G[Picasso]
        if length(name{F+1,1})==length(match)        %if match ��ӪF�誺�W�r���פ@��
            if  allFile(F*n1+f).name(findstr( allFile(F*n1+f).name,'_')-2)~=allFile(F*n1+f).name(length(allFile(F*n1+f).name)-7)   
                %���XPicasso1a_Picasso7a   a�e�����Ʀr
                %ex:���Ҭ� if 1~=7
                M=~sum(abs(name{F+1,1}-match))    %�r��۴�S���@�˪���   M=�r��۴�ƥجۥ[;   ex:abs(a-A)=32
            else                                  %���]match���F��W�r���פ@��,���O���Xa�e�����Ʀr�ۦP��,k=f,M=0;
                k=f
                M=0
            end
        else                                      %�p�G match ��ӪF�誺���פ��P M=0;
            M=0
        end
                
        %��F=0,f=1��,�p���Picasso1a_Picasso7a
        one=fscanf(fid,'Model=%d ', 1);   %  %d�Q�i��]�����t�Ÿ��^  %show �XPicasso1a.point�ƾ�   300�I
        A=fscanf(fid,'%f', [3 inf]);  %�̫ᶵ��size�A���Ū�J�G�C��ơA�����ɮש�
        A=A';
        one=fscanf(fid,'Deform=%d ', 1);%  %d�Q�i��]�����t�Ÿ��^  %show �XPicasso7a.point�ƾ�   300�I
        B=fscanf(fid,'%f', [3 inf]);  %�̫ᶵ��size�A���Ū�J�G�C��ơA�����ɮש�
        B=B';
        
        one=fscanf(fid,'Match=%d ', 1);%  %d�Q�i��]�����t�Ÿ��^  %show �XPicasso1a_Picasso7a�ƾ�   match�쪺�I��
        C=fscanf(fid,'%f', [2 inf]);  %�̫ᶵ��size�A���Ū�J�G�C��ơA�����ɮש�
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
            cost=10000;             %MIN �@�}�l10000
        end
        if cost< MIN(F+1)           %cost<10000
            MIN(F+1)=cost;          %MIN(1)=cost
            name{F+1,3}=f;          %name{1,3}=f  f=�ĴX�����  �ĴX�Ӱj��
            name{F+1,4}=match;      %��쪺����match�W��
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