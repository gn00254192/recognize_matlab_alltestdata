clc;
clear;
act=3; %5 from path 6 from ans  9 from 
path_node=['http://imagenetapi.appspot.com/getpath?&act=' num2str(act)];

All_node = urlread(path_node);     %去http://mjimagenetapi.appspot.com/getpath?&act=5讀出node資料
All_node_num=findstr(All_node,10);    %抓取所有NODE資料  10是ascii的換行鍵
if All_node_num>0
    nnum=length(All_node_num);  %幾筆資料+1
    All_node_num=[0 All_node_num];       %放入陣列裡
    for i=1:1:nnum 
        node_list{i}=All_node(All_node_num(i)+1:All_node_num(i+1)-1);  %把NODE資訊讀入陣列  EX{'02127808','02127808','02127808','02374451','02374451','google,1','google,2';}
    end
    l{1}=node_list{1};
    j=2;
    for i=2:1:nnum               %把NODE的重複拿掉           
                l{j}=node_list{i}; 
                j=j+1;
    end
end

act=8;
path_id=['http://imagenetapi.appspot.com/getpath?&act=' num2str(act)];
All_id = urlread(path_id);     %去http://mjimagenetapi.appspot.com/getpath?&act=8讀出number資料
All_id_num=findstr(All_id,10); %抓取所有number資料  10是ascii的換行鍵

if All_id_num>0
    nnum=length(All_id_num);  %幾筆資料+1
    All_id_num=[0 All_id_num];       %放入陣列裡
    for i=1:1:nnum 
        id_list{i}=All_id(All_id_num(i)+1:All_id_num(i+1)-1);  %把NODE資訊讀入陣列  EX{'02127808','02127808','02127808','02374451','02374451','google,1','google,2';}
    end
    l{1}=id_list{1};
    j=2;
    for i=2:1:nnum               %把NODE的重複拿掉           
                l{j}=id_list{i}; 
                j=j+1;
    end
end






act=1;
if All_node_num>=0
    for i=1:1:length(node_list)
        node=node_list{i};
        id=id_list{i};
        
%-----------getpath------------------------------------------------    
   %act=1; %1from path 3 from ans
%node='02676566';
url=['http://imagenetapi.appspot.com/getpath?key=' id '&act=' num2str(act) ];  %軌跡資料 EX  http://mjimagenetapi.appspot.com/getpath?node=02127808&act=1  

s = urlread(url);
if length(s)>10
    
    n1=findstr(s,'http://gn00254192.hostei.com/upload/')+36;   %-------以下三行主要是要讀出
    n2=findstr(s,'.JPEG')-1;
    name=[s(n1:n2) ];
    
    fid = fopen( [name '.txt'], 'w');
    fprintf(fid, s);
    fclose(fid);
    a= dir([name '.txt']);
    pause(10);
    
        if a.bytes>10000            
        n1=findstr(s,'http://gn00254192.hostei.com/upload/')-2;
        s1=s(1:n1);
 %       url=['http://mjimagenetapi.appspot.com/getpath?key=' s1 '&act=' num2str(act+1)];
 %       s = urlread(url);
    end
end

%-----------------------------------------------------------------------        
        
         pause(10);
    end
end