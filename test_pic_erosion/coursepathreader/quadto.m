function [ pic ] = quadto( y,x,pic )
%QUADTO Summary of this function goes here
%   Detailed explanation goes here
r=0.5/sqrt((x(1)-x(3))^2+(y(1)-y(3))^2);
if r==inf
    r=1;
end
for i=0:r:1
    x1=((1-i)^2)*x(1)+2*i*(1-i)*x(2)+(i^2)*x(3);
    y1=((1-i)^2)*y(1)+2*i*(1-i)*y(2)+(i^2)*y(3);
    pic(floor(y1),floor(x1))=1;
end
end

