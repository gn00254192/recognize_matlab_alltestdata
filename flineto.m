function [ pic ] = flineto( y1,y2,x1,x2,pic )
%LINETO Summary of this function goes here
%   Detailed explanation goes here
r=0.5/sqrt((x1-x2)^2+(y1-y2)^2);
if r==inf
    r=1;
end
for z=0:r:1
    x3=(1-z)*x1+z*x2;
    y3=(1-z)*y1+z*y2;
    pic(floor(y3),floor(x3))=1;
end

end

