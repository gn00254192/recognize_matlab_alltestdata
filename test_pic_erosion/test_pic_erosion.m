%���Xpoint��
clc;
clear;
tic
allFolder =dir;  %��ܬY�Ӹ�Ƨ������e
for f=3:1:length(allFolder)   %�� length�ӧP�_�ɮת��h��
    if allFolder(f).isdir==1  %�p�G�O��Ƨ�����
        cd (allFolder(f).name);%cd�쨺�Ӹ�Ƨ��U
        allFile = dir('6198976764182528.tif');
        for k=1:1:length(allFile)
            pic=imread(allFile(k).name);%��C�@�itif�Ϥ����B�z
            pic=pic>0;
            a=ones(2,2);
            b=ones(4,4)
           
           % subplot(1,length(allFile),k),imshow(pic);
           figure,imshow(pic),title('���');
           imerodepicture=imerode(pic,a);
           figure,imshow(imerodepicture),title('�I�k');
           c=imdilate(imerodepicture,b);
           figure,imshow(c),title('�X�i');
        end
         cd ..;  
    end
end