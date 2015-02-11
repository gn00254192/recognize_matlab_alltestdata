close all;
clc;
%pic=imread('test.PNG');
%figure,imshow(pic);
%D1 = imresize(pic,[321*2 230*2],'bilinear');
%figure,imshow(D1);
%E1 = imresize(pic,[321*2 230*2],'bicubic');
%figure,imshow(E1);
%result_logic=imresize(pic,4);
%figure,imshow(result_logic);
%result_logic=rgb2gray(result_logic);
%figure,imshow(result_logic);
%r=result_logic<200;
%imshow(result_logic),figure,imshow(result_logic<200);
%figure,imshow(r);


%se = strel('disk',1);        
%erodedBW = imerode(r,se);
%imshow(r), figure, imshow(erodedBW)
clc;
close all;
clear;
pic=imread('7.png');
pic=rgb2gray(pic);

width=size(pic,2); %¼e
lenght=size(pic,1);%ªø
cut1=pic(1:(lenght/2),1:(width/2));             
cut2=pic(1:(lenght/2),(width-(width/2)):width);
cut3=pic(lenght-(lenght/2):lenght,1:(width/2));
cut4=pic((lenght-(lenght/2)):lenght,(width-(width/2)):width);

graythreashpicture1=graythresh(cut1);
graythreashpicture2=graythresh(cut2);
graythreashpicture3=graythresh(cut3);
graythreashpicture4=graythresh(cut4);


change1=pic(1:(lenght/2),1:(width/2))>graythreashpicture1*200;
change2=pic(1:(lenght/2),(width-(width/2)):width)>graythreashpicture2*225;
change3=pic(lenght-(lenght/2):lenght,1:(width/2))>graythreashpicture3*230;
change4=pic((lenght-(lenght/2)):lenght,(width-(width/2)):width)>graythreashpicture4*230;


for i=1:1:floor(lenght/2)
    for j=1:1:floor(width/2)
        answer(i,j)=change1(i,j);
    end
end
for i=1:1:(lenght/2)
    for j=1:1:ceil(width-(width/2))
        answer(i,j+floor(width/2))=change2(i,j);
    end
end
for i=1:1:ceil(lenght-(lenght/2))
    for j=1:1:floor(width/2)
        answer(i+floor(lenght/2),j)=change3(i,j);
    end
end
for i=1:1:ceil(lenght-(lenght/2))
    for j=1:1:ceil(width-(width/2))     
        answer(i+floor(lenght/2),j+floor(width/2))=change4(i,j);
    end
end
figure,imshow(answer,[])
%result_logic=imresize(pic,6);
%r=pic<125;
%se = strel('disk',2);        
%erodedBW = imerode(r,se);
%figure, imshow(r,[])

imwrite(answer,['pic_part2test71.tif' ],'tif')


