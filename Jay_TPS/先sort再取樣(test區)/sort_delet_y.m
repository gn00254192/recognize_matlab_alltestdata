clear all;
close all;
clc;

tif_pic = dir('6297005097746432.tif');
pic=imread(tif_pic(1).name);

pic=pic>0;
[x,y]=find(pic);
xminimum=min(x);            %x���̤p�y��
yminimum=min(y);            %y���̤p�y��
xmaximum=max(x);            %x���̤j�y��
ymaximum=max(y);            %y���̤j�y��
x=x-xminimum+1;               %�Ҧ��y�д�h�̤p��,���Ϥ��i�K�b(1,1)�W
y=y-yminimum+1;               %�Ҧ��y�д�h�̤p��,���Ϥ��i�K�b(1,1)�W


sx=[x,y];
 [sort_y,ind]=sort(sx(:,2));%�Ƨ�y�b,�ðO�Uindex
 sort_y(:,2)=sort_y;
 %-----------�Ƨ�y�b�A�óz�L���ޱNy�b������諸x�b-----------------
 for i=1:1:size(sort_y,1)  %�Ƨ�X�b�A�óz�L���ޱNy�b������諸x�b
     sort_y(i,1)=sx(ind(i,1),1);
 end
%-------------------------------------------------------------- 
i=1;

while(i<size(sort_y,1))
temp=[];
pos=find(sort_y(:,2)==sort_y(i,2));
    if(size(pos,1)>1)
        k=1;
        for j=2:1:size(pos,1)
            if(abs(sort_y(pos(1,1),1)-sort_y(pos(j,1),1))==1)
                temp(k,1)=pos(j,1);  
                k=k+1;
            end
        end
    end
    
 if(isempty(temp)==0)
        for s=1:1:size(temp,1)
            sort_y(temp(s,1),:)=[];
        end
 end
 
    i=i+1
end

%-----------------------sort_y�ץX��--------------------------- 
 figure
 for i=1:1:size(sort_y,1)
    plot(sort_y(i,2),-sort_y(i,1),'o');
     hold on;
 end
 %------------------------------------------------------------ 
 

 
 
 
 
 %--------------------------�}�l�����I------------------------

 x1=sort_y(:,1);   %��ƧǦn�����O��x�by�b
 y1=sort_y(:,2);   %��ƧǦn�����O��x�by�b
 x_lenth=length(sort_y);
 point_distance_choose=x_lenth/300;            %��300�I�A�Ҧ��I��/����300�I�A�Y�O�Cpoint_distance�h���I���@��
 distance=1:point_distance_choose:length(sort_y);   %���I�Z��
        
 x11=x1(floor(distance));                 %��������300�I��x�y��
 y11=y1(floor(distance));                 %��������300�I��y�y��
 
 sx1=[x11,y11];
 
 
 %-----------------------sort_y�ץX��--------------------------- 
 figure
 for i=1:1:size(sx1,1)
    plot(sx1(i,2),-sx1(i,1),'o');
     hold on;
 end
 %------------------------------------------------------------ 


