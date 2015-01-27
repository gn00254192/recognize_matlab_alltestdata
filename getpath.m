%act=1; %1from path 3 from ans
%node='02676566';
url=['http://mjimagenetapi.appspot.com/getpath?node=' node '&act=' num2str(act)];
s = urlread(url);
if length(s)>10
    
    n1=findstr(s,'http://summer3c.host56.com/upload/')+34;
    n2=findstr(s,'.png')-1;
    name=[s(n1:n2) ];
    
    fid = fopen( [name '.txt'], 'w');
    fprintf(fid, s);
    fclose(fid);
    a= dir([name '.txt']);
    pause(10);
    
   % if a.bytes>10000            
    %    n1=findstr(s,'http:/summer3c.host56.com/upload/')-2;
     %   s1=s(1:n1);
   %    url=['http://mjimagenetapi.appspot.com/getpath?key=' s1 '&act=' num2str(act+1)];
   %     s = urlread(url);
 %   end
    
end