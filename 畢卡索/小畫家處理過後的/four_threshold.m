clc;
close all;
clear;
pic=imread('origin.png');
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


change1=pic(1:(lenght/2),1:(width/2))>graythreashpicture1*255;
change2=pic(1:(lenght/2),(width-(width/2)):width)>graythreashpicture2*255;
change3=pic(lenght-(lenght/2):lenght,1:(width/2))>graythreashpicture3*255;
change4=pic((lenght-(lenght/2)):lenght,(width-(width/2)):width)>graythreashpicture4*255;


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

imwrite(answer,['pic_part2test71.tif' ],'tif')


