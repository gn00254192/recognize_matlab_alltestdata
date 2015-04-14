clc;
clear;
close all;
cut_row=3;  %���X�C�A���O���X�M
cut_col=3;  %���X��
pic=imread('5762529972191233.tif');
%figure,imshow(pic);
Long=size(pic,1);     %�ݼv�����h��
Wide=size(pic,2);     %�ݼv���e���h�e
col_interval=floor(Wide/cut_col);  %��X�涡�Z,��floor,�ѤU�������̫�@��
row_interval=floor(Long/cut_row);  %��X�C���Z,��floor,�ѤU�������̫�@��
cut_temp=ones((cut_row+1),(cut_col+1)*2);%�Ф@��0�x�}�ΨӤ����C�ӯx�}�����I�y��

%-------------------------�N�U�Ӥ��I�y�мg�J--------------------------

for j=1:1:cut_row+1
    temp=col_interval;
    for i=4:2:(cut_col+1)*2
        cut_temp(j,i)=temp;
        temp=temp+col_interval;
    end   
end
for j=1:2:(cut_col+1)*2
    temp=row_interval;
    for i=2:1:cut_row+1
        cut_temp(i,j)=temp
        temp=temp+row_interval;
    end
end

if(cut_temp(1,(cut_col+1)*2)~=Wide || cut_temp(cut_row+1,1)~=Long)
    cut_temp(:,(cut_col+1)*2)=Wide;
    for i=1:2:(cut_col+1)*2
        cut_temp(cut_row+1,i)=Long;
    end
end
%-----------------------�N�U�Ӥ��I�y�мg�Jend----------------------------


%----------------�p��C�Ӥ���̭����h�֭�pixel�O���Ȫ�--------------------
%�C�@�C�@�������U�@�C,�H3*3�Ϥ�����,�C�i�Ϥ����ζ��Ǧp�U
%1   2   3
%4   5   6
%7   8   9
num_row=1;
for  h=2:1:cut_row+1
    num_col=1;
    for k=4:2:(cut_col+1)*2 
        y1=1;
        count=0;
        for i=num_col:1:cut_temp(1,k) 
            x1=1;
            for j=num_row:1:cut_temp(h,1)
                temp(x1,y1)=pic(j,i);    
                x1=x1+1;
            end
        y1=y1+1;
        end
        figure,imshow(temp);
        save_pic_cut{h-1,(k/2)-1}=temp;
        num_col=num_col+col_interval
    end
    num_row=num_row+row_interval
end

%----------------�p��C�Ӥ���̭����h�֭�pixel�O���Ȫ�end--------------------