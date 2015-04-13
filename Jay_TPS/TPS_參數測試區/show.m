clc;
clear;
close all;
fid=fopen('face__sort_300point9a_face__sort_300point4a.match');
one=fscanf(fid,'Model=%d ', 1);
A=fscanf(fid,'%f', [3 inf]);  %�̫ᶵ��size�A���Ū�J�G�C��ơA�����ɮש�
A=A';

one=fscanf(fid,'Deform=%d ', 1);
B=fscanf(fid,'%f', [3 inf]);  %�̫ᶵ��size�A���Ū�J�G�C��ơA�����ɮש�
B=B';

one=fscanf(fid,'Match=%d ', 1);
C=fscanf(fid,'%f', [2 inf]);  %�̫ᶵ��size�A���Ū�J�G�C��ơA�����ɮש�
C=C';
fclose(fid);

    figure,plot(A(:,3),-A(:,2),'o');
   hold on;
     plot(B(:,3),-B(:,2),'X','Color','m');
     hold on;
     
     [csize,cline]=size(C);
     for i=1:1:csize
         x=[A(C(i,1)+1,2),B(C(i,2)+1,2)];
         y=[A(C(i,1)+1,3),B(C(i,2)+1,3)];
         line(y,-x,'Color','y','LineWidth',1);
         hold on;
     end
   axis equal%,axis tight;