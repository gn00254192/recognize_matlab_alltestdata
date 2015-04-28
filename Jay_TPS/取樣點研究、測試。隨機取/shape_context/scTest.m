%  
% ?极坐??和二?直方? by visionfans @ 2011.05.03  
%  
%% draw polar diagram  
h = figure();  
axs = subplot(2,1,1);  
axis equal;  
point = [Bsamp(1,n) Bsamp(2,n)];  
scDrawPolar(Bsamp,point,r_inner*mean_dist,r_outer*mean_dist,nbins_theta,nbins_r);  
%% draw 2d histogram  
subplot(2,1,2);  
axis equal;  
hold on;  
%%   
temp = flipud(full(Sn)');  
imagesc(temp);colormap(gray);  
axis image;  
xlabel('{/theta}');  
ylabel('log(r)');  
for i=1:size(temp,2)  
    for j=1:size(temp,1)  
        if temp(j,i)  
            text(i,j,sprintf('%d',temp(j,i)),'Color','r');  
        end  
    end  
end  
hold off;  
%%  
pause;  
close(h);  