
%addpath(pwd);
clc;
clear;
allFolder =dir;
for f=3:1:length(allFolder)
    if allFolder(f).isdir==1
        cd (allFolder(f).name);
%-----------------------------------------------------------       
       
allFile = dir('*.tif');
for k=1:1:length(allFile)
    pic=imread(allFile(k).name);
    pic=pic>0;
    [x,y]=find(pic);
         
    mx=0;
    
    num=length(x);
    num=num/300;
    num=1:num:length(x);
    x=x(floor(num));
    y=y(floor(num));
    
    
    
    
    for xi=1:1:length(x)
        [xs,n]=max(sqrt((x-x(xi)).*(x-x(xi))+(y-y(xi)).*(y-y(xi))));
        if xs>mx
            xx1=xi;
            xx2=n;
            mx=xs;
        end
    end
    x=x-mean(x);
    y=y-mean(y);
    x=x/mx;
    y=y/mx;
%     th1=atan2((y(xx2)-y(xx1)),(x(xx2)-x(xx1)));
%     r=sqrt(x.^2+y.^2);
%     th=atan2(y,x);
 %    th=th-th1;
%    x=r.*cos(th);
%     y=r.*sin(th);
         subplot(1,length(allFile),k),plot(y,-x,'x'),axis equal,axis tight
   
    sx=[x,y];
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

 
%-----------------------------------------------------------       
                
        cd ..;
    end
end

