clear all;
close all;
clc;
Bounding_box=500;
allFile = dir('*.tif');
for k=1:1:length(allFile)
    pic=imread(allFile(k).name);%��C�@�itif�Ϥ����B�z
    pic=double(pic);
    pic=pic>0;
    [x,y]=find(pic);
    xminimum=min(x);            %x���̤p�y��
    yminimum=min(y);            %y���̤p�y��
    xmaximum=max(x);            %x���̤j�y��
    ymaximum=max(y);            %y���̤j�y��
    x=x-xminimum+1;               %�Ҧ��y�д�h�̤p��,���Ϥ��i�K�b(1,1)�W
    y=y-yminimum+1;               %�Ҧ��y�д�h�̤p��,���Ϥ��i�K�b(1,1)�W
    x_magnification=(Bounding_box-1)/(xmaximum-xminimum); %�ݣA�n��j�h�֭� -2�O���F��ceil���W�[�@
    y_magnification=(Bounding_box-1)/(ymaximum-yminimum); %�ݣB�n��j�h�֭�
    x_magnify=ceil(x*x_magnification);    %��j�A   ��ceil�O��floor�y�з|��0��
    y_magnify =ceil(y*y_magnification);   %��j�B

    sx=[x_magnify,y_magnify];

    [sort_coordinates,ind]=sort(sx(:,1));%�Ƨ�x�b,�ðO�Uindex

    for i=1:1:size(sort_coordinates,1)  %�Ƨ�X�b�A�óz�L���ޱNy�b������諸x�b
        sort_coordinates(i,2)=sx(ind(i,1),2);
    end
  
 
 
 %---------------------��i�᪺���I---------------------------------------------
    x1=sort_coordinates(:,1);   %��ƧǦn�����O��x�by�b
    y1=sort_coordinates(:,2);   %��ƧǦn�����O��x�by�b
    x_lenth=length(sort_coordinates);
    point_distance=x_lenth/300;            %��300�I�A�Ҧ��I��/����300�I�A�Y�O�Cpoint_distance�h���I���@��
    distance=1:point_distance:length(x);   %���I�Z��
        
    x2=x1(floor(distance));                 %��������300�I��x�y��
    y2=y1(floor(distance));                 %��������300�I��y�y��
 
    sx2=[x2,y2];
    
    fnMat = allFile(k).name;    
    %open link file
    fpLink = fopen([ 'shadow_sort_300point' num2str(k) 'a.point' ], 'wt' );
    fprintf( fpLink, 'Model=%d\n', size(sx2,1) );
    for i=1:size(sx2,1)
       fprintf( fpLink, '%d\t%25.20f\t%25.20f\n', i-1, sx2(i, 1), sx2(i, 2) );
    end;
    
     figure
     for i=1:1:size(sx2,1)
         plot(sx2(i,2),-sx2(i,1),'o');
        hold on;
    end
    
    clear sx2;
    fclose( fpLink );
    
    
 %-------------------------------------------------------------------------

end
 