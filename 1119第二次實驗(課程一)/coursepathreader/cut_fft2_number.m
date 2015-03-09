clc;
clear;
close all;
add_temp=1;
row_size=4
col_size=6
for fft_size_runtimes=1:1:8
Bounding_box=700;
sight_like_one=2;
sight_like_two=5;
sight_like_three=4;
allFile = dir('*.tif');
for k=1:1:length(allFile)
    pic=imread(allFile(k).name);%��C�@�itif�Ϥ����B�z
    pic=pic>0;                  %pic���I�j��0���ܴN�Oture,��1  
    [x,y]=find(pic);            %��X�x�}X�����Ҧ��D�s�����A�ñN�o�Ǥ��������ޭȶ��[x,y]   
    rtmap=zeros(Bounding_box);  %�s�y�@�Ӫťժ��x�}
    xminimum=min(x);            %x���̤p�y��
    yminimum=min(y);            %y���̤p�y��
    xmaximum=max(x);            %x���̤j�y��
    ymaximum=max(y);            %y���̤j�y��
    x=x-xminimum+1;               %�Ҧ��y�д�h�̤p��,���Ϥ��i�K�b(1,1)�W
    y=y-yminimum+1;               %�Ҧ��y�д�h�̤p��,���Ϥ��i�K�b(1,1)�W
    x_magnification=(Bounding_box-2)/(xmaximum-xminimum); %�ݣA�n��j�h�֭� -2�O���F��ceil���W�[�@
    y_magnification=(Bounding_box-2)/(ymaximum-yminimum); %�ݣB�n��j�h�֭�
    x_magnify=floor(x*x_magnification);    %��j�A   ��ceil�O��floor�y�з|��0��
    y_magnify =floor(y*y_magnification);   %��j�B

    %figure,plot(y_magnify,-x_magnify,'x'),axis equal,axis tight     %show�X��������

    for j=1:1:length(x_magnify)            %��۹���X,Y�b�g�irtmap��,�H�K���G���ť߸�
        if(x_magnify(j,1)==0&&y_magnify(j,1)~=0)
            x_magnify(j,1)=1;
            rtmap(x_magnify(j,1),y_magnify(j,1))=1;
        end
        
        if(x_magnify(j,1)~=0&&y_magnify(j,1)==0)
            y_magnify(j,1)=1;
            rtmap(x_magnify(j,1),y_magnify(j,1))=1;
        end
        if(x_magnify(j,1)~=0&&y_magnify(j,1)~=0) 
            rtmap(x_magnify(j,1),y_magnify(j,1))=1;
        end
    end
    %subplot(3,3,k),imshow(rtmap)     %show�X��J�ťկx�}�Ϥ�
    fmapq{k}=abs(fft2(rtmap));
    %figure,subplot(3,3,k),imshow(abs(log(abs(fmapq{i}))),[],'notruesize'),title('fft2');
    fmapq{k}= fmapq{k}/ fmapq{k}(1,1);
    fmapq{k}(1,1)=0;
    if(row_size<=700 && col_size<=700)
        fmapq{k}= fmapq{k}(1:row_size,1:col_size);
    else
        fmapq{k}= fmapq{k}(1:Bounding_box,1:Bounding_box);
    end
end

originpic=9;%���
if(row_size<=700 && col_size<=700)
%figure,
for picnum=1:1:originpic-1
       sum=0;
    for i=1:1:row_size
        for j=1:1:col_size
            Disp2o=sqrt((fmapq{1,picnum}(i,j)-fmapq{1,originpic}(i,j))* (fmapq{1,picnum}(i,j)-fmapq{1,originpic}(i,j)));
            sum=Disp2o+sum;
        end
    end
    fftdist(1,picnum)=sum;
end
else
    for picnum=1:1:originpic-1
       sum=0;
    for i=1:1:Bounding_box
        for j=1:1:Bounding_box
            Disp2o=sqrt((fmapq{1,picnum}(i,j)-fmapq{1,originpic}(i,j))* (fmapq{1,picnum}(i,j)-fmapq{1,originpic}(i,j)));
            sum=Disp2o+sum;
        end
    end
    fftdist(1,picnum)=sum;
end
end
 
 
    fftdistsmaller_record(add_temp,:)=fftdist;   %�Ҧ��Ϫ��Z����X
    sorted_record(add_temp,:) = sort(fftdistsmaller_record(add_temp,:));  %�N�Ҧ��Z���Ƨ�~�s�bsort��
    fftdistsmaller=fftdist;
    sorted = sort(fftdistsmaller);
    
    %----------------------------��ı�Ƽƾ�----------------------------------------------
%---------------�Ĥ@�i��~���---------------------------------------------------
%1.��ı�o�����O�̭��ĴX�i��
%2.���X���@�i���Z���ƾ�
%3.��L�bsort�̪�����
%�N���ޭȦs�U,���U�Ӷ]��bouding=100,200,300.....1000�ɪ����p
%plot�X��


like_value_one=fftdistsmaller(sight_like_one);%2.���X���@�i���Z���ƾ�
like_final_sort_index(fft_size_runtimes+1)=find(sorted==(like_value_one))%3.��L�bsort�̪�����



%---------------�e�T�i����N���---------------------------------------------------

    like_value_two=fftdistsmaller(sight_like_two);%���X�ĤG�i�����Z���ƾ�
    like_value_three=fftdistsmaller(sight_like_three);%���X�ĤT�i�����Z���ƾ�
    contrast(1,1)=find(sorted==(like_value_one));%��X�Ĥ@�i�����Ϥ��ƦW�b�ĴX
    contrast(1,2)=find(sorted==(like_value_two));%��X�ĤG�i�����Ϥ��ƦW�b�ĴX
    contrast(1,3)=find(sorted==(like_value_three));%��X�ĤT�i�����Ϥ��ƦW�b�ĴX
    contrast_record(add_temp,:)=contrast;%�O���C�@�����ƦW����
    contrast_sort=sort(contrast)%�N�T�i�Ϥ����ƦW�ƧǨ��X�̤p�ƦW
    thirdlike_final_sort_index(fft_size_runtimes+1) =contrast_sort(1,1)

    
    add_temp=add_temp+1;
    row_size=row_size*2
    col_size=col_size*2
end
x_label=[0,4 ,8,16,32,64,128,256,700]
subplot(1,1,1);
plot(x_label,like_final_sort_index,'r--*',x_label,thirdlike_final_sort_index,'b:diamond');
xlabel('fft�@size');
ylabel('�ƦW');


