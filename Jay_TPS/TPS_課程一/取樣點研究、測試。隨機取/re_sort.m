clc;
clear;
close all;
select_point=300;
Bounding_box=500;
cut_row=100;  %���X�C�A���O���X�M
cut_col=100;  %���X��
allFile = dir('*.tif');
for kp=1:1:length(allFile)
    pic=imread(allFile(kp).name);
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
        cut_temp(i,j)=temp;
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
                if(pic(j,i)~=0)
                    count=count+1;
                end
            end
        y1=y1+1;
        end
%        figure,imshow(temp);
        save_pic_cut{h-1,(k/2)-1}=temp;
        save_pixel_count(h-1,(k/2)-1)=count;
        num_col=num_col+col_interval;
    end
    num_row=num_row+row_interval;
end

%----------------�p��C�Ӥ���̭����h�֭�pixel�O���Ȫ�end--------------------

%----------------����count���S���g��----------------------
%count=0;
%for i=1:1:1920
%    for j=1:1:1080
%        if(pic(i,j)~=0)
%            count=count+1
%        end
%    end
%end
%----------------����count���S���g��end----------------------

%----------------�p��C�i�ϭn���˦h���I----------------------
total_point=sum(sum(save_pixel_count));
float_select_point=(save_pixel_count/total_point)*select_point;
int_select_point=floor((save_pixel_count/total_point)*select_point);
%----------------�p��C�i�ϭn���˦h���Iend----------------------

%----------------------�N�I�ɺ��쨬��---------------------------

while(sum(sum(int_select_point))<select_point)
    decimal_point=float_select_point-int_select_point;
    temp_decimal_point=find(decimal_point==max(max(decimal_point)),1);
    decimal_point(temp_decimal_point)=0;
    int_select_point(temp_decimal_point)=int_select_point(temp_decimal_point)+1;
end
%----------------------�N�I�ɺ��쨬��end---------------------------

%--------------------------randrom_index-----------------------------
for i=1:1:size(int_select_point,2)
    for j=1:1:size(int_select_point,1)
        %int_select_point(j,i)   %�̯x�}���ޱƦC�X
        random_index{j,i}=randperm(size(find(save_pic_cut{j,i}),1));
    end    
end
%--------------------------randrom_end--------------------------------

%-------------------------------����-----------------------------------
for i=1:1:size(save_pic_cut,2)
    for j=1:1:size(save_pic_cut,1)
        if(isempty(random_index{j,i})==0)
            [x,y]=find(save_pic_cut{j,i});
            for k=1:1:int_select_point(j,i)
                x_temp{j,i}(k,1)=x(random_index{j,i}(1,k));
                y_temp{j,i}(k,1)=y(random_index{j,i}(1,k));
            end
        else
            x_temp{j,i}=[];
            y_temp{j,i}=[];
        end
        %figure,plot(y_temp{j,i},-x_temp{j,i},'o')
    end
end
%-------------------------------����end-----------------------------------

%----------------------------�N�U�Ө��˹ϦX��-------------------------------
x=x_temp{1,1};
y=y_temp{1,1};
x_y_merge=[x,y];
for i=2:1:size(save_pic_cut,2)    %�B�z�Ĥ@�C
    x=x_temp{1,i};
    y=y_temp{1,i}+col_interval*(i-1);
    x_y_temp=[x,y];
    x_y_merge=[x_y_merge;x_y_temp];
end

for i=2:1:size(save_pic_cut,1)     %�B�z�Ĥ@��
    x=x_temp{i,1}+row_interval*(i-1);
    y=y_temp{i,1};
    x_y_temp=[x,y];
    x_y_merge=[x_y_merge;x_y_temp];
end

for i=2:1:size(save_pic_cut,2)
    for j=2:1:size(save_pic_cut,1)
        x=x_temp{j,i}+row_interval*(j-1);
        y=y_temp{j,i}+col_interval*(i-1);
        x_y_temp=[x,y];
        
        x_y_merge=[x_y_merge;x_y_temp];
    end
end

    xminimum=min(x_y_merge(:,1));            %x���̤p�y��
    yminimum=min(x_y_merge(:,2));            %y���̤p�y��
    xmaximum=max(x_y_merge(:,1));            %x���̤j�y��
    ymaximum=max(x_y_merge(:,2));            %y���̤j�y��
    x1=x_y_merge(:,1)-xminimum+1;               %�Ҧ��y�д�h�̤p��,���Ϥ��i�K�b(1,1)�W
    y1=x_y_merge(:,2)-yminimum+1;               %�Ҧ��y�д�h�̤p��,���Ϥ��i�K�b(1,1)�W
    
    x_magnification=(Bounding_box-2)/(xmaximum-xminimum); %�ݣA�n��j�h�֭� -2�O���F��ceil���W�[�@
    y_magnification=(Bounding_box-2)/(ymaximum-yminimum); %�ݣB�n��j�h�֭�
    x_magnify=ceil(x1*x_magnification);    %��j�A   ��ceil�O��floor�y�з|��0��
    y_magnify =ceil(y1*y_magnification);   %��j�B
    
    
    
    size(x_y_merge)
    x_y_merge=[x_magnify,y_magnify];


    fnMat = allFile(kp).name;    
     %open link file
     fpLink = fopen([ 'face' num2str(kp) 'a.point' ], 'wt' );
     fprintf( fpLink, 'Model=%d\n', size(x_y_merge,1) );
     for i=1:size(x_y_merge,1)
        fprintf( fpLink, '%d\t%25.20f\t%25.20f\n', i-1, x_y_merge(i, 1), x_y_merge(i, 2) );
     end;
     figure,plot(x_y_merge(:,2),-x_y_merge(:,1),'o'),title([num2str(cut_row),'*',num2str(cut_col)])

     clear x_y_merge col_interval count cut_temp decimal_point float_select_point h i int_select_point j k num_col num_row random_index row_interval x x1 x_temp y y1 y_temp;
     fclose( fpLink );
end