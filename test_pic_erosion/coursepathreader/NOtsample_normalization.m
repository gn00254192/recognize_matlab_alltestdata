allFile = dir('*.tif');

for k=1:1:length(allFile)
    
    %-----------------------------取出每個.tif前面的字串，用來命名之後.point-------------
   temp=(allFile(k).name);
   howlong=findstr(allFile(k).name,'.tif');
   newname=temp(1:howlong-1);
    
    %----------------------------------------------------------------------
    pic=imread(allFile(k).name);
    pic=pic>0;
    [x,y]=find(pic);
         
    mx=0;
    

    num=1:1:length(x);
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
         subplot(1,length(allFile),k),plot(y,-x,'.'),axis equal,axis tight   
    sx=[x,y];
    fnMat = allFile(k).name;

      %open link file
    fpLink = fopen([ newname '.point' ], 'wt' );
    fprintf( fpLink, 'Model=%d\n', size(sx,1) );
    for i=1:size(sx,1)
        fprintf( fpLink, '%d\t%25.20f\t%25.20f\n', i-1, sx(i, 1), sx(i, 2) );
    end;
    clear sx;
    
    fclose( fpLink );
    
 %   fclose( fpLink );
end


