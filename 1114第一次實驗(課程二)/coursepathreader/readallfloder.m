
addpath(pwd);
clc;
clear;
allFolder =dir;
for f=3:1:length(allFolder)
    if allFolder(f).isdir==1
        cd (allFolder(f).name);
        pathreader;
        cd ..;
    end
end

