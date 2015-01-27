close all;
clear;
clc;
act=5; %5 from path 6 from ans
url=['http://mjimagenetapi.appspot.com/getpath?&act=' num2str(act)];
s = urlread(url);
num=findstr(s,10);
if num>0
    nnum=length(num);
    num=[0 num];
    for i=1:1:nnum
        list{i}=s(num(i)+1:num(i+1)-1);
    end
    l{1}=list{1};
    j=2;
    for i=2:1:nnum
        if length(list{i-1})==length(list{i})
            if abs(sum(list{i-1}-list{i}))>0
                l{j}=list{i};
                j=j+1;
            end
        else
            l{j}=list{i};
            j=j+1;
        end
    end
end