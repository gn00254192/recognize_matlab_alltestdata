clear;
clc;
c=imread('circles.tif');
x=ones(256,1)*[1:256];
c2=double(c).*(x/2+50)+(1-double(c)).*x/2;
c3=uint8(255*mat2gray(c2));
figure,subplot(1,2,1),imshow(c3)
cut1=c3(:,1:64);
cut2=c3(:,65:128);
cut3=c3(:,129:192);
cut4=c3(:,193:256);
graythreashpicture1=graythresh(cut1);
graythreashpicture2=graythresh(cut2);
graythreashpicture3=graythresh(cut3);
graythreashpicture4=graythresh(cut4);
change1=c3(:,1:64)>graythreashpicture1*255;
change2=c3(:,65:128)>graythreashpicture2*255;
change3=c3(:,129:192)>graythreashpicture3*255;
change4=c3(:,193:256)>graythreashpicture4*310;
for i=1:1:256
    for j=1:1:64
        answer(i,j)=change1(i,j);
    end
end
for i=1:1:256
    for j=1:1:64
        answer(i,j+64)=change2(i,j);
    end
end
for i=1:1:256
    for j=1:1:64
        answer(i,j+128)=change3(i,j);
    end
end
for i=1:1:256
    for j=1:1:64
        
        answer(i,j+192)=change4(i,j);
    end
end
subplot(1,2,2),imshow(answer,[])
