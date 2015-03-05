%���Xpoint��
clc;
clear;
tic
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
            %x_lenth=length(x);          %�D�X�Ҧ��I���ƶq
            %point_distance=x_lenth/300;            %��300�I�A�Ҧ��I��/����300�I�A�Y�O�Cpoint_distance�h���I���@��
            %distance=1:point_distance:length(x);   %���I�Z��
            distance=1:1:length(x);                %�������I�ʧ@
            x1=x(floor(distance));                 %��������300�I��x�y��
            y1=y(floor(distance));                 %��������300�I��y�y��
       for xi=1:1:length(x1)                       %x�y�и�y�y�ЩҦ��I��hx(1)��y(1)�C�Ӻ�X�Z����A��X�̤j��
            
            [xs,n]=max(sqrt((x1-x1(xi)).*(x1-x1(xi))+(y1-y1(xi)).*(y1-y1(xi))));   %��X���I�����̤j�Z��
            dis=sqrt((x1-x1(xi)).*(x1-x1(xi))+(y1-y1(xi)).*(y1-y1(xi)));      %��C���⧹�������bdis��          
            if xs>mx            %������X�ƭȤ���j�ɡA�O���U��
                mx=xs;          %�̷s�Z����mx�A���L�i�H�~���U�@�Ӥ��  
                distxi=xi;      %����s�̻��Z���ɡA�����Ҧ��I��h�����I�o��̻��Z��
                distf=dis;      %��C���⧹�������bdis��,�ç�dis�̪���ƥᵹdistf
                [xss,nn]=max(distf); %�D�X�̤j��,�ç�X�̤j�Ȫ�����,�H�K�e�X�u
            end
            
       end
       allpicmaxlenth(1,k)=mx;%�O���C�i�ϳ̪��Z��
       x_barycentre=x1-mean(x1);     %�D�X�Ҧ�x�y�Ъ������ȡA��X���ߡA�Ҧ�X�I��h���ߡA�������I�b(0,0)
       y_barycentre=y1-mean(y1);     %�D�X�Ҧ�y�y�Ъ������ȡA��X���ߡA�Ҧ�y�I��h���ߡA�������I�b(0,0)
       %subplot(1,length(allFile),k),plot(y_barycentre,-x_barycentre,'x'),axis equal,axis tight   %�N�Ҧ��Ϥ����I���m���ߡA����m���W��
       x_size=x_barycentre/mx;       %�N�Ҧ���m���W�ƪ�x�y�Фj�p���W�ơA�Ҧ��I�y�а��h�̻��Z��  
       y_size=y_barycentre/mx;       %�N�Ҧ���m���W�ƪ�y�y�Фj�p���W�ơA�Ҧ��I�y�а��h�̻��Z�� 
       subplot(1,length(allFile),k),plot(y_size,-x_size,'x'),axis equal,axis tight     %�N�Ҧ��I���h�̻��Z���A���j�p���W��   
       line([y_size(distxi),y_size(nn)],[-x_size(distxi),-x_size(nn)], 'color', 'r');
       %subplot(1,length(allFile),k),plot(x1(xi),y1(xi),x1(nn),y1(nn),'--');
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