clc;
clear;
close all;
cut_row=2;  %���X�C�A���O���X�M
cut_col=2;  %���X��
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
count=0;
for i=1:1:540
    for j=1:1:960
        temp(j,i)=pic(j,i);
        
        if(pic(j,i)>0)
            count=count+1;
        end
    end
end
every_pic_point_count(1,1)=count;
figure,imshow(temp);
%----------------�p��C�Ӥ���̭����h�֭�pixel�O���Ȫ�end--------------------