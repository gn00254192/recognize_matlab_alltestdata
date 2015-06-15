clc;
clear;
close all;
% Shape Context Demo #1
% match two pointsets from Chui & Rangarajan

% uncomment out one of these commands to load in some shape data
load save_fish_def_3_1.mat
%load face_x_y2.mat
%load save_face_notresize.mat
%load save_fish_noise_3_2.mat
%load save_fish_outlier_3_2.mat
%load save_face.mat
%load save_face_ttttt.mat
%load save_face_notdo_anything.mat
%load save_face_two_diff_pic.mat
several_times=3;  %轉移矩陣做幾次---不可低於3次

X=x1;
Y=y2a;

display_flag=1;
mean_dist_global=[]; % use [] to estimate scale from the data
nbins_theta=12;
nbins_r=5;
nsamp1=size(X,1);
nsamp2=size(Y,1);
ndum1=0;
ndum2=0;

if nsamp2>nsamp1
   % (as is the case in the outlier test)
   ndum1=ndum1+(nsamp2-nsamp1);
end

eps_dum=0.15;
r_inner=1/8;
r_outer=2;
n_iter=5;
r=1; % annealing rate
beta_init=1;  % initial regularization parameter (normalized)

if display_flag
   [x,y]=meshgrid(linspace(0,1,18),linspace(0,1,36));
   x=x(:);y=y(:);M=length(x);
end

if display_flag
   figure(1)
   plot(x1(:,1),x1(:,2),'b+',y2a(:,1),y2a(:,2),'ro')
   title(['original pointsets (nsamp1=' int2str(nsamp1) ', nsamp2=' ...
       int2str(nsamp2) ')'])
   if 0
      h1=text(x1(:,1),x1(:,2),int2str((1:nsamp1)'));
      h2=text(y2a(:,1),y2a(:,2),int2str((1:nsamp2)'));  
      set(h2,'fontangle','italic');
   end
   drawnow
end

%-----------以下取自tps_iter_match_1----------------start稍微修改
Xk=X; 
k=1;
s=1;
out_vec_1=zeros(1,nsamp1); 
out_vec_2=zeros(1,nsamp2);
disp(['iter=' int2str(k)])
[BH1,mean_dist_1]=sc_compute(Xk',zeros(1,nsamp1),mean_dist_global,nbins_theta,nbins_r,r_inner,r_outer,out_vec_1);
[BH2,mean_dist_2]=sc_compute(Y',zeros(1,nsamp2),mean_dist_1,nbins_theta,nbins_r,r_inner,r_outer,out_vec_2);
beta_k=(mean_dist_1^2)*beta_init*r^(k-1);
costmat=hist_cost_2(BH1,BH2);
nptsd=nsamp1+ndum1;
costmat2=eps_dum*ones(nptsd,nptsd);
costmat2(1:nsamp1,1:nsamp2)=costmat;
disp('running hungarian alg.')
cvec=hungarian(costmat2);
disp('done.')
[a,cvec2]=sort(cvec);
out_vec_1=cvec2(1:nsamp1)>nsamp2;
out_vec_2=cvec(1:nsamp2)>nsamp1;
X2=NaN*ones(nptsd,2);
X2(1:nsamp1,:)=Xk;
X2=X2(cvec,:);
X2b=NaN*ones(nptsd,2);
X2b(1:nsamp1,:)=X;
X2b=X2b(cvec,:);
Y2=NaN*ones(nptsd,2);
Y2(1:nsamp2,:)=Y;
% extract coordinates of non-dummy correspondences and use them
% to estimate transformation
ind_good=find(~isnan(X2b(1:nsamp1,1)));
% NOTE: Gianluca said he had to change nsamp1 to nsamp2 in the
% preceding line to get it to work properly when nsamp1~=nsamp2 and
% both sides have outliers...
n_good=length(ind_good);
X3b=X2b(ind_good,:);
Y3=Y2(ind_good,:);
% show the correspondences between the untransformed images
figure(2)
    plot(X(:,1),X(:,2),'b+',Y(:,1),Y(:,2),'ro')
    ind=cvec(ind_good);
        hold on
    plot([X2b(:,1) Y2(:,1)]',[X2b(:,2) Y2(:,2)]','k-')
        hold off
    title([int2str(n_good) ' correspondences (unwarped X)'])
drawnow	
%-----------以下取自tps_iter_match_1----------------end


%-------------------只做一次--start-------------------------
%-------------------隨機取點----start------------------
%Rand_seed=randperm(size(X2b(:,1),1))';
%Top_three=Rand_seed(1:3)
%-------------------隨機取點-----end--------------------

%-------------------------------------
%in_points = [X2b(Top_three(1),1) X2b(Top_three(1),2);X2b(Top_three(2),1) X2b(Top_three(2),2);X2b(Top_three(3),1) X2b(Top_three(3),2)];   
%out_points = [Y2(Top_three(1),1) Y2(Top_three(1),2);Y2(Top_three(2),1) Y2(Top_three(2),2);Y2(Top_three(3),1) Y2(Top_three(3),2)]; 
%tform2 = maketform('affine',in_points,out_points);% maketform=>製作轉換矩陣，tform2裡有T=轉換矩陣，筆記A


%[5 4 1]*[1 0 0;0 1 0;0 0 1]

%mapping=[X2b(Rand_seed(4),1) X2b(Rand_seed(4),2) 1]*[tform2.tdata.T] 
%剩下的點要乘上轉換矩陣~看是否shape_context的匹配有對

%temp(:,1)=Y2(:,1)-mapping(1,1);    %將圖2的所有座標-mapping到的點
%temp(:,2)=Y2(:,2)-mapping(1,2);    %要看哪個最靠近mapping點

%for i=1:1:size(Y2(:,1))            %將所有座標-mapping點座標,看誰最靠近
%    temp(i,3)=sqrt(temp(i,1)^2+temp(i,2)^2);
%end

%index=find(temp(:,3)==min(temp(:,3)));

%if(index==Rand_seed(4))
%    ans=1;
%else
%    ans=0;
%end
%---------------------只做一次--end-----------------------------

%-------------------- 做多次--start-----------------------------
Rand_seed=randperm(size(X2b(:,1),1))';
num_count3=1;
count=0;
ct2=1;
for i=1:1:several_times-2     
    for j=2:1:several_times-1
        if(j~=i)            
            for k=3:1:several_times
                if(k~=j && k~=i )
                    in_points = [X2b(Rand_seed(i),1) X2b(Rand_seed(i),2);X2b(Rand_seed(j),1) X2b(Rand_seed(j),2);X2b(Rand_seed(k),1) X2b(Rand_seed(k),2)];   
                    out_points = [Y2(Rand_seed(i),1) Y2(Rand_seed(i),2);Y2(Rand_seed(j),1) Y2(Rand_seed(j),2);Y2(Rand_seed(k),1) Y2(Rand_seed(k),2)]; 
                    tform2 = maketform('affine',in_points,out_points);
                    transform_matrix{num_count3,1}=tform2.tdata.T;%紀錄每次的轉換矩陣
                    %maketform=>製作轉換矩陣，tform2裡有T=轉換矩陣，筆記A    
                    %tform2.tdata.T
                    record(num_count3,3)=k;   %紀錄跑Rand_seed index怎麼跑
                    record(num_count3,2)=j;
                    record(num_count3,1)=i;
  
                    for f=1:1:size(Y2(:,1),1)
                        if(f~=i && f~=j && f~=k)
                            mapping=[X2b(Rand_seed(f),1) X2b(Rand_seed(f),2) 1]*[tform2.tdata.T]; 
                            %剩下的點要乘上轉換矩陣~看是否shape_context的匹配有對
                            Y_tran{num_count3,1}(Rand_seed(f),1)=mapping(1,1);%紀錄mapping的點座標
                            Y_tran{num_count3,1}(Rand_seed(f),2)=mapping(1,2);
                            
                            Y_tran{num_count3,1}(Rand_seed(f),3)=sqrt((mapping(1,1)-Y2(Rand_seed(f),1))^2+(mapping(1,2)-Y2(Rand_seed(f),2))^2);%算與標準答案的差距
                            
                        else
                            Y_tran{num_count3,1}(Rand_seed(f),1)=Y2(Rand_seed(f),1);%紀錄mapping的點座標
                            Y_tran{num_count3,1}(Rand_seed(f),2)=Y2(Rand_seed(f),2);
                            
                        end
                    end
                   
                  num_count3=num_count3+1;           
                end
            end
        end
    end
end
%for i=1:1:size(Y_tran(:,1),1)       %show 直方圖
    %figure, hist(Y_tran{i,1}(:,1), 20)
%end

%--------------------------計算每個平均差值------start-------------------
for i=1:1:size(Y_tran,1)
    Y_tran{i,:}(1,4)=mean(Y_tran{i,:}(:,3));
end
%--------------------------計算每個平均差值------end-------------------


%--------------------------再圖上畫線觀察--------start---------------------------------

threshold=0.05;

    
for j=1:1:size(Y_tran,1)
    %hold off;
    figure,
    plot(X(:,1),X(:,2),'b+',Y(:,1),Y(:,2),'ro') 
    hold on;
    %-------------點出第一個三角形-------------------
    plot(X2b(Rand_seed(record(j,1)),1),X2b(Rand_seed(record(j,1)),2),'Rx')
    plot(X2b(Rand_seed(record(j,2)),1),X2b(Rand_seed(record(j,2)),2),'Rx')
    plot(X2b(Rand_seed(record(j,3)),1),X2b(Rand_seed(record(j,3)),2),'Rx')
    
    %------------用線畫出第一個三角形---------------
    plot([X2b(Rand_seed(record(j,1)),1) X2b(Rand_seed(record(j,2)),1)]',[X2b(Rand_seed(record(j,1)),2) X2b(Rand_seed(record(j,2)),2)]','k-')
    plot([X2b(Rand_seed(record(j,2)),1) X2b(Rand_seed(record(j,3)),1)]',[X2b(Rand_seed(record(j,2)),2) X2b(Rand_seed(record(j,3)),2)]','k-')
    plot([X2b(Rand_seed(record(j,3)),1) X2b(Rand_seed(record(j,1)),1)]',[X2b(Rand_seed(record(j,3)),2) X2b(Rand_seed(record(j,1)),2)]','k-')
    
    %plot([X2b(Rand_seed(record(j,1),1),1) Y2(Rand_seed(record(j,1),1),1)]',[X2b(Rand_seed(record(j,1),1),2) Y2(Rand_seed(record(j,1),1),2)]','k-')
    %plot([X2b(Rand_seed(record(j,2),1),1) Y2(Rand_seed(record(j,2),1),1)]',[X2b(Rand_seed(record(j,2),1),2) Y2(Rand_seed(record(j,2),1),2)]','k-')
    %plot([X2b(Rand_seed(record(j,3),1),1) Y2(Rand_seed(record(j,3),1),1)]',[X2b(Rand_seed(record(j,3),1),2) Y2(Rand_seed(record(j,3),1),2)]','k-')
    
    %----------------用線畫出第二個三角形-------------------
    plot([Y2(Rand_seed(record(j,1)),1) Y2(Rand_seed(record(j,2)),1)]',[Y2(Rand_seed(record(j,1)),2) Y2(Rand_seed(record(j,2)),2)]','m--')
    plot([Y2(Rand_seed(record(j,2)),1) Y2(Rand_seed(record(j,3)),1)]',[Y2(Rand_seed(record(j,2)),2) Y2(Rand_seed(record(j,3)),2)]','m--')
    plot([Y2(Rand_seed(record(j,3)),1) Y2(Rand_seed(record(j,1)),1)]',[Y2(Rand_seed(record(j,3)),2) Y2(Rand_seed(record(j,1)),2)]','m--')
    ,title(['mean=' num2str(Y_tran{j,:}(1,4)) ])
    hold off;
    figure, hist(Y_tran{j,1}(:,3), 15),title(['mean=' num2str(Y_tran{j,:}(1,4)) ])
    figure,
    for i=1:1:size(Y2(:,1),1)
        plot(X(:,1),X(:,2),'b+',Y(:,1),Y(:,2),'ro') 
        hold on
        plot([X2b(i,1) Y_tran{j,1}(i,1)]',[X2b(i,2) Y_tran{j,1}(i,2)]','k-');
        hold on
        %pause;
%-----------------給閥值----在閥值內的給1-----start----------        
         if(Y_tran{j,1}(i,3)<=threshold)
            Y_tran{j,1}(i,5)=1;
         else
            Y_tran{j,1}(i,5)=0;
         end
 %-----------------給閥值----在閥值內的給1-----end----------         
    end
    %pause;
    hold off;
%---------------在閥值內的畫綠線--------start----------------    
    figure,
    for n=1:1:size(Y2(:,1),1)
        plot(X(:,1),X(:,2),'b+',Y(:,1),Y(:,2),'ro') 
        hold on
        if(Y_tran{j,1}(n,5)==1)
            plot([X2b(n,1) Y_tran{j,1}(n,1)]',[X2b(n,2) Y_tran{j,1}(n,2)]','g-'),title(['threshold=' num2str(threshold) ]);
            hold on
        else
            plot([X2b(n,1) Y_tran{j,1}(n,1)]',[X2b(n,2) Y_tran{j,1}(n,2)]','r-'),title(['threshold=' num2str(threshold)]);
            hold on
        end        
    end    
    hold off;   
%---------------在閥值內的畫綠線--------end----------------     
end

%--------------------------再圖上畫線觀察--------end----------------------------

%threshold=0.045;
%for i=1:1:size(Y_tran(:,1),1)     %voting   對的給1錯的給0  
%    for j=1:1:size(Y_tran{1,1},1)
%        if(Y_tran{i,1}(j,3)<=threshold)
%            Y_tran{i,1}(j,5)=1;
%        else
%            Y_tran{i,1}(j,5)=0;
%        end
%    end
%end

  
%for i=1:1:size(Y_tran,1)    %畫圖,對的畫綠色線,錯的畫紅色線
%figure,
%    for j=1:1:size(Y2(:,1),1)
%        plot(X(:,1),X(:,2),'b+',Y(:,1),Y(:,2),'ro') 
%        hold on
%        if(Y_tran{i,1}(j,5)==1)
%            plot([X2b(j,1) Y_tran{i,1}(j,1)]',[X2b(j,2) Y_tran{i,1}(j,2)]','g-'),title(['threshold=' num2str(threshold) ]);
%            hold on
%        else
%            plot([X2b(j,1) Y_tran{i,1}(j,1)]',[X2b(j,2) Y_tran{i,1}(j,2)]','r-'),title(['threshold=' num2str(threshold)]);
%            hold on
%        end
        
%    end
    
%    hold off;
%end
%--------------統計每個點數對幾次--------------
correct_point(1:size(Y_tran{1,1},1),1)=0;%初始化
for i=1:1:size(Y_tran(:,1),1)   
    Y_tran{i,1}(3,4)=sum(Y_tran{i,1}(:,5)) %看每次轉換矩陣對的點總共有幾個
    for j=1:1:size(Y_tran{1,1},1)
        if(Y_tran{i,1}(j,5)==1)
            correct_point(j,1)=correct_point(j,1)+1;%統計每個點在n次的轉換矩陣中對幾次
        else
            correct_point(j,1)=correct_point(j,1);
        end  
    end
end
%--------------統計每個點數對幾次--------------




