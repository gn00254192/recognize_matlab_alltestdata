%���Xpoint��
clc;
clear;
close all;
allFolder =dir;  %��ܬY�Ӹ�Ƨ������e

for f=3:1:length(allFolder)   %�� length�ӧP�_�ɮת��h��
    if allFolder(f).isdir==1  %�p�G�O��Ƨ�����
        cd (allFolder(f).name);%cd�쨺�Ӹ�Ƨ��U
        allFile = dir('*.tif');
        for k=1:1:length(allFile)
            pic=imread(allFile(k).name);%��C�@�itif�Ϥ����B�z
            pic=pic>0;                  %pic���I�j��0���ܴN�Oture,��1     
            [x,y]=find(pic);            %��X�x�}X�����Ҧ��D�s�����A�ñN�o�Ǥ��������ޭȶ��[x,y]            
            mx=0;                       %��mx��l��            
            x_lenth=length(x);          %�D�X�Ҧ��I���ƶq
            %point_distance=x_lenth/300;            %��300�I�A�Ҧ��I��/����300�I�A�Y�O�Cpoint_distance�h���I���@��
            %distance=1:point_distance:length(x);   %���I�Z��
            distance=1:1:length(x);                %�������I�ʧ@
            x1=x(floor(distance));                 %��������300�I��x�y��
            y1=y(floor(distance));                 %��������300�I��y�y��          
       for xi=1:1:length(x1)                       %x�y�и�y�y�ЩҦ��I��hx(1)��y(1)�C�Ӻ�X�Z����A��X�̤j��
            [xs,n]=max(sqrt((x1-x1(xi)).*(x1-x1(xi))+(y1-y1(xi)).*(y1-y1(xi))));   %��X���I�����̤j�Z��
            if xs>mx            %����X�ƭȤ���j�ɡA�O���U��
                mx=xs;          %�̷s�Z����mx�A���L�i�H�~���U�@�Ӥ��
            end
       end
       maxlength(1,k)=mx;
       x_barycentre=x1-mean(x1);     %�D�X�Ҧ�x�y�Ъ������ȡA��X���ߡA�Ҧ�X�I��h���ߡA�������I�b(0,0)
       y_barycentre=y1-mean(y1);     %�D�X�Ҧ�y�y�Ъ������ȡA��X���ߡA�Ҧ�y�I��h���ߡA�������I�b(0,0)
       %subplot(1,length(allFile),k),plot(y_barycentre,-x_barycentre,'x'),axis equal,axis tight   %�N�Ҧ��Ϥ����I���m���ߡA����m���W��
       x_size=x_barycentre/mx;       %�N�Ҧ���m���W�ƪ�x�y�Фj�p���W�ơA�Ҧ��I�y�а��h�̻��Z��  
       y_size=y_barycentre/mx;       %�N�Ҧ���m���W�ƪ�y�y�Фj�p���W�ơA�Ҧ��I�y�а��h�̻��Z�� 
       %subplot(1,length(allFile),k),plot(y_size,-x_size,'x'),axis equal,axis tight     %�N�Ҧ��I���h�̻��Z���A���j�p���W��   
       subplot(3,3,k),plot(y_size,-x_size,'x'),axis equal,axis tight     %�N�Ҧ��I���h�̻��Z���A���j�p���W�� 
       if(k==9)
           figure,plot(y_size,-x_size,'x'),axis equal,axis tight
       end
       sx=[x_size,y_size];
       fnMat = allFile(k).name;    
       %open link file
       fpLink = fopen(['..\' allFolder(f).name num2str(k) 'a.point' ], 'wt' );
       fprintf( fpLink, 'Model=%d\n', size(sx,1) );
       for i=1:size(sx,1)
          fprintf( fpLink, '%d\t%25.20f\t%25.20f\n', i-1, sx(i, 1), sx(i, 2) );
       end;
       clear sx;
       fclose( fpLink );
        end
         cd ..;        
    end    
end
%��2���ť߸�
allPoint = dir('*.point');
for i=1:1:length(allPoint)
    fid=fopen(allPoint(i).name);   %�@���@�����X��ƪ��W��
    one=fscanf(fid,'Model=%d ', 1);%d�N��ϥξ��,�ݨ��X�����
    data=fscanf(fid,'%f', [3 inf]);   %�̫ᶵ��size�A���Ū�J�T�C��ơA�����ɮש��Ainf�N��EOF(End of File)�A%f�N��㦳�B�I���ƾ�
    data=data';%��m                      Ū�X�Ҧ�POINT�����
    data=data(:,2:3);
    allpicmaxlen=max(max(maxlength));    %��X�Ҧ��ϧΤ����ӹϧΪ��̪���̪�
    allpicminlen=min(min(maxlength));    %��X�Ҧ��ϧΤ����ӹϧΪ��̪���̵u
    %data=ceil(data*allpicmaxlen);        %�Ҧ��y���I���W�̪���A��j���
    data=ceil(data*allpicminlen*0.9);        %�Ҧ��y���I���W�̵u��A��j���
    data=data+ceil(allpicminlen/2);          %���i�Ϯ���Ĥ@�H��
    rtmap=zeros(ceil(allpicmaxlen));%�s�y�@�Ӫťժ��x�}
    %figure,plot(data(:,2),-data(:,1)+max(max(data(:,1))),'o'),axis equal,axis tight;%plot�X�C�ӹϧΩ�j�æ첾�ܲĤ@�H��
    
    for j=1:1:length(data)            %��۹���X,Y�b�g�irtmap��,�H�K���G���ť߸�
        if(rtmap(data(j,1),data(j,2))~=1)
            rtmap(data(j,1),data(j,2))=rtmap(data(j,1),data(j,2))+1;
        end      
    end
    figure,imshow(rtmap);     %�L�X�b�G�i��� 
    fmapq{i}=abs(fft2(rtmap));
    %figure,subplot(3,3,k),imshow(abs(log(abs(fmapq{i}))),[],'notruesize'),title('fft2');
    fmapq{i}= fmapq{i}/ fmapq{i}(1,1);
    fmapq{i}(1,1)=0;
    fclose(fid);
end



originpic=9;%���

figure,
for picnum=1:1:originpic-1
       sum=0;
    for i=1:1:size(rtmap,1)
        for j=1:1:size(rtmap,2)
            Disp2o=sqrt((fmapq{1,picnum}(i,j)-fmapq{1,originpic}(i,j))* (fmapq{1,picnum}(i,j)-fmapq{1,originpic}(i,j)));
            sum=Disp2o+sum;
        end
    end
    fftdist(1,picnum)=sum;
    subplot(3,3,picnum),imshow(log(1+abs(fftshift(fmapq{picnum}))),[],'notruesize'),title('fft2');
end
    subplot(3,3,9),imshow(log(1+abs(fftshift(fmapq{9}))),[],'notruesize'),title('fft2');
fftdistsmaller=fftdist/10000




