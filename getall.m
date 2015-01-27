clc
clear
getlist;
act=1;
if num>=0
    for i=1:1:length(list)
        node=list{i};
        getpath;
        pause(10);
    end
end