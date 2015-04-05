clear;
clc;
close all;
allFile = dir('*.point');
for F=1:1:length(allFile)
    for K=1:1:length(allFile)
        if F~=K
        system(['PointMatchDemo2 ' allFile(F).name  ' ' allFile(K).name]);
        end
    end
end


