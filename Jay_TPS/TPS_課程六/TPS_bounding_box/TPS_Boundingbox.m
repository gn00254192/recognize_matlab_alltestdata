clc;
clear;
close all;
Bounding_box=500;
allFile = dir('*.tif');
for k=1:1:length(allFile)
    pic=imread(allFile(k).name);%��C�@�itif�Ϥ����B�z
    pic=pic>0;                  %pic���I�j��0���ܴN�Oture,��1  
    [x,y]=find(pic);            %��X�x�}X�����Ҧ��D�s�����A�ñN�o�Ǥ��������ޭȶ��[x,y]   
    rtmap=zeros(Bounding_box);  %�s�y�@�Ӫťժ��x�}
    rtmap_300point=zeros(Bounding_box);  %�s�y�@�Ӫťժ��x�}
    xminimum=min(x);            %x���̤p�y��
    yminimum=min(y);            %y���̤p�y��
    xmaximum=max(x);            %x���̤j�y��
    ymaximum=max(y);            %y���̤j�y��
    x=x-xminimum+1;               %�Ҧ��y�д�h�̤p��,���Ϥ��i�K�b(1,1)�W
    y=y-yminimum+1;               %�Ҧ��y�д�h�̤p��,���Ϥ��i�K�b(1,1)�W
    x_magnification=(Bounding_box-2)/(xmaximum-xminimum); %�ݣA�n��j�h�֭� -2�O���F��ceil���W�[�@
    y_magnification=(Bounding_box-2)/(ymaximum-yminimum); %�ݣB�n��j�h�֭�
    x_magnify=ceil(x*x_magnification);    %��j�A   ��ceil�O��floor�y�з|��0��
    y_magnify =ceil(y*y_magnification);   %��j�B
    %figure,plot(y_magnify,-x_magnify,'x'),axis equal,axis tight     %show�X��������

    x_lenth=length(x_magnify);
    point_distance=x_lenth/300;            %��300�I�A�Ҧ��I��/����300�I�A�Y�O�Cpoint_distance�h���I���@��
    distance=1:point_distance:length(x);   %���I�Z��
        
    x1=x_magnify(floor(distance));                 %��������300�I��x�y��
    y1=y_magnify(floor(distance));                 %��������300�I��y�y��
    
    for j=1:1:length(x_magnify)            %��۹���X,Y�b�g�irtmap��,�H�K���G���ť߸�
            rtmap(x_magnify(j,1),y_magnify(j,1))=1;
    end
        for j=1:1:length(x1)            %��۹���X,Y�b�g�irtmap��,�H�K���G���ť߸�
            rtmap_300point(x1(j,1),y1(j,1))=1;
    end
    %subplot(3,3,k),imshow(rtmap_300point)     %show�X��J�ťկx�}�Ϥ�
    figure,imshow(rtmap_300point);
    
    
       sx=[x1,y1];
       fnMat = allFile(k).name;    
       %open link file
       fpLink = fopen(['..\' 'Picasso' num2str(k) 'a.point' ], 'wt' );
       fprintf( fpLink, 'Model=%d\n', size(sx,1) );
       for i=1:size(sx,1)
          fprintf( fpLink, '%d\t%25.20f\t%25.20f\n', i-1, sx(i, 1), sx(i, 2) );
       end;
       clear sx;
       fclose( fpLink );
end
              
   
   





