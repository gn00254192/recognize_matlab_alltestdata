clc;
clear;
close all;
pic=imread('213.jpg');
pic=imread('5762529972191233.tif');
pic2=pic>0;                  %pic���I�j��0���ܴN�Oture,��1     
[x,y]=find(pic2); 
%[x1,y1]=find(pic);
%[x2,y2]=find(pic);%��X�x�}X�����Ҧ��D�s�����A�ñN�o�Ǥ��������ޭȶ��[x,y]     
%figure,plot(y,-x,'*')
%hold on;
%figure,imshow(pic)
in_points = [1 1000;1 1;1000 1];
out_points = [1000 1000;1 1000;1 1];
X=[1 1000];%���wX�d��
Y=[1 1000];%���wY�d��
%plot(in_points(:,1),in_points(:,2),'ro')
tform2 = maketform('affine',in_points,out_points);% maketform=>�s�@�ഫ�x�}�Atform2�̦�T=�ഫ�x�}�A���OA
cb_trans = imtransform(pic,tform2,'XData',X,'YData',Y);%imtransform=>�i��y���ഫ�A�NPic���Wtform2�̪��ഫ�x�}�A�|�o��s���y��
figure,imshow(cb_trans,[]);


%in_points = [point(1,1) point(1,2);xp_up yp_up;point(2,1) point(2,2) ];
%out_points = [1 1;1 256;256 1];
%X=[1 256];%���wX�d��
%Y=[1 256];%���wY�d��
%tform2 = maketform('affine',in_points,out_points);% maketform=>�s�@�ഫ�x�}�Atform2�̦�T=�ഫ�x�}�A���OA
%cb_trans = imtransform(img, tform2,'XData', [1 (size(cb,2)+ xform(3,1))],'YData',[1 (size(cb,1)+ xform(3,2))]));%imtransform=>�i��y���ഫ�A�NPic���Wtform2�̪��ഫ�x�}�A�|�o��s���y��
%figure,imshow(cb_trans);

%cb = checkerboard;
%figure,imshow(cb);
xform = [ 0  -1 0
          1  0  0
          0  0  1 ];
tform_translate = maketform('affine', xform);
[pic xdata ydata]= imtransform(pic, tform_translate);
figure,imshow(pic)



xform = [ 0.3  0  0
          0   0.3  0
          0    0   1 ];
tform_translate = maketform('affine', xform);
[pic xdata ydata]= imtransform(pic, tform_translate);
figure,imshow(pic)


xform = [ 1  5  0
          5  1  0
          0  0  1 ];
tform_translate = maketform('affine', xform);
[pic xdata ydata]= imtransform(pic, tform_translate);
figure,imshow(pic)

