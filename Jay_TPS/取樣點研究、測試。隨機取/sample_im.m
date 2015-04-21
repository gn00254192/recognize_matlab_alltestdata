clear 
close all
I=imread('5762529972191233.tif');
figure, imshow(I, []);
total_pt=sum(I(:)/255);
A=I(1:size(I,1)/2, 1:size(I,2)/2);
figure, imshow(A);
[A_x, A_y]=find(A);
figure, plot(A_y, A_x, 'o');
axis ij, axis square
A_pt = sum(A(:)/255);
A_num = A_pt/total_pt * 300;
A_num = floor(A_num);
index = randperm(A_pt);
A_xs = A_x(index(1:A_num));
A_ys = A_y(index(1:A_num));
figure, plot(A_ys, A_xs, 'o');
axis ij, axis square
%
B=I(1:size(I,1)/2, size(I,2)/2+1:size(I,2));
[B_x, B_y]=find(I(1:size(I,1)/2, size(I,2)/2+1:size(I,2)));
B_y = B_y+size(I,2)/2;
figure, plot(B_y, B_x, 'o');
axis ij, axis square
B_pt = sum(B(:)/255);
B_num = B_pt/total_pt * 300;
B_num = floor(B_num);
index = randperm(B_pt);
B_xs = B_x(index(1:B_num));
B_ys = B_y(index(1:B_num));
figure, plot(B_ys, B_xs, 'o');
axis ij, axis square
%
C=I(size(I,1)/2+1:size(I,1), 1:size(I,2)/2);
[C_x, C_y]=find(I(size(I,1)/2+1:size(I,1), 1:size(I,2)/2));
C_x = C_x + size(I,1)/2;
figure, plot(C_y, C_x, 'o');
axis ij, axis square
C_pt = sum(C(:)/255);
C_num = C_pt/total_pt * 300;
C_num = floor(C_num);
index = randperm(C_pt);
C_xs = C_x(index(1:C_num));
C_ys = C_y(index(1:C_num));
figure, plot(C_ys, C_xs, 'o');
axis ij, axis square
%
D=I(size(I,1)/2+1:size(I,1), size(I,2)/2+1:size(I,2));
[D_x, D_y]=find(I(size(I,1)/2+1:size(I,1), size(I,2)/2+1:size(I,2)));
D_x = D_x + size(I,1)/2;
D_y = D_y + size(I,2)/2;
figure, plot(D_y, D_x, 'o');
axis ij, axis square
D_pt = sum(D(:)/255);
D_num = D_pt/total_pt * 300;
D_num = floor(D_num);
index = randperm(D_pt);
D_xs = D_x(index(1:D_num));
D_ys = D_y(index(1:D_num));
figure, plot(D_ys, D_xs, 'o');
axis ij, axis square
%
samples_x = [A_xs; B_xs; C_xs; D_xs];
samples_y = [A_ys; B_ys; C_ys; D_ys];
figure, plot(samples_y, samples_x, '+');
axis ij, axis square
