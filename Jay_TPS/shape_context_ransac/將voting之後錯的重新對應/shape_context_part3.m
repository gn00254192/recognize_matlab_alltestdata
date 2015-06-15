clc;
clear;
close all;
% Shape Context Demo #1
% match two pointsets from Chui & Rangarajan

% uncomment out one of these commands to load in some shape data
%load face_pic9_pic3.mat
load save_fish_def_3_1.mat
%load face_x_y2.mat
%load save_face_notresize.mat
%load save_fish_noise_3_2.mat
%load save_fish_outlier_3_2.mat
%load save_face.mat
%load save_face_ttttt.mat
%load save_face_notdo_anything.mat
%load save_face_two_diff_pic.mat

threshold=0.05;
several_times=15;  %轉移矩陣做幾次---不可低於3次
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

Rand_seed=randperm(size(X2b(:,1),1))';%亂數取樣
num_count=1;

for i=1:1:several_times-2     
    for j=1:1:several_times-1
        if(j~=i)            
            for k=1:1:several_times
                if(k~=i && k~=j )
                    in_points = [X2b(Rand_seed(i),1) X2b(Rand_seed(i),2);X2b(Rand_seed(j),1) X2b(Rand_seed(j),2);X2b(Rand_seed(k),1) X2b(Rand_seed(k),2)];   
                    out_points = [Y2(Rand_seed(i),1) Y2(Rand_seed(i),2);Y2(Rand_seed(j),1) Y2(Rand_seed(j),2);Y2(Rand_seed(k),1) Y2(Rand_seed(k),2)]; 
                    tform2 = maketform('affine',in_points,out_points);
                    transform_matrix{num_count,1}=tform2.tdata.T;%紀錄每次的轉換矩陣
                    %maketform=>製作轉換矩陣，tform2裡有T=轉換矩陣，筆記A    
                    %tform2.tdata.T
                    permutation(num_count,3)=k;   %紀錄跑Rand_seed index怎麼跑
                    permutation(num_count,2)=j;
                    permutation(num_count,1)=i;
  
                    for f=1:1:size(Y2(:,1),1)
                        if(f~=i && f~=j && f~=k)
                            mapping=[X2b(Rand_seed(f),1) X2b(Rand_seed(f),2) 1]*[tform2.tdata.T]; 
                            %剩下的點要乘上轉換矩陣~看是否shape_context的匹配有對
                            Y_tran{num_count,1}(Rand_seed(f),9)=mapping(1,1);%紀錄mapping的點座標
                            Y_tran{num_count,1}(Rand_seed(f),10)=mapping(1,2);
                            
                            Y_tran{num_count,1}(Rand_seed(f),11)=sqrt((mapping(1,1)-Y2(Rand_seed(f),1))^2+(mapping(1,2)-Y2(Rand_seed(f),2))^2);%算與標準答案的差距
                            
                        else
                            Y_tran{num_count,1}(Rand_seed(f),9)=Y2(Rand_seed(f),1);%紀錄mapping的點座標
                            Y_tran{num_count,1}(Rand_seed(f),10)=Y2(Rand_seed(f),2);
                            Y_tran{num_count,1}(Rand_seed(f),11)=0;
                        end
                        
                        if(Y_tran{num_count,1}(Rand_seed(f),11)<=threshold)  %判斷點數對或錯
                            Y_tran{num_count,1}(Rand_seed(f),12)=1;
                        else
                            Y_tran{num_count,1}(Rand_seed(f),12)=0;
                        end
                    end
                    Y_tran{num_count,1}(:,1)=X(:,1);%紀錄X座標
                    Y_tran{num_count,1}(:,2)=X(:,2);
                    Y_tran{num_count,1}(:,3)=Y(:,1);%紀錄Y座標
                    Y_tran{num_count,1}(:,4)=Y(:,2);
                    Y_tran{num_count,1}(:,5)=X2b(:,1);%紀錄X2b座標
                    Y_tran{num_count,1}(:,6)=X2b(:,2);
                    Y_tran{num_count,1}(:,7)=Y2(:,1);%紀錄Y2座標
                    Y_tran{num_count,1}(:,8)=Y2(:,2);
                    permutation(num_count,6)=mean(Y_tran{num_count,:}(:,11));
                    permutation(num_count,4)=sum(Y_tran{num_count,1}(:,12));
                    permutation(num_count,5)=size(Y2(:,1),1)-sum(Y_tran{num_count,1}(:,12));
                    num_count=num_count+1;           
                end
            end
        end
    end
end
[max_correct,index]=max(permutation(:,4));%找出voting最高的轉換矩陣
count1=1;
count2=1;
for f=1:1:size(Y_tran{index,1},1)   %抓出最好的轉換矩陣中錯誤的點
    if(Y_tran{index,1}(f,12)==0)
        wrong_point(count1,:)=Y_tran{index,1}(f,:);
        count1=count1+1;
    else
        correct_point(count2,:)=Y_tran{index,1}(f,:);
        count2=count2+1;
    end   
end
for i=1:1:size(wrong_point,1)
    for j=1:1:size(wrong_point,1)
        sec_cost(i,j)=sqrt((wrong_point(i,9)-wrong_point(j,7))^2+(wrong_point(i,10)-wrong_point(j,8))^2);
    end
end



%------------------------再做一次shape context--------換cost
clear costmat2 cvec cvec2 costmat X2b Y2 X Y Y3

X(:,1)=wrong_point(:,1);
X(:,2)=wrong_point(:,2);
Y(:,1)=wrong_point(:,3);
Y(:,2)=wrong_point(:,4);

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
   figure,
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
nptsd=nsamp1+ndum1;
disp('running hungarian alg.')
cvec=hungarian(sec_cost);
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
figure,
     plot(x1(:,1),x1(:,2),'b+',y2a(:,1),y2a(:,2),'ro')
    ind=cvec(ind_good);
        hold on
    plot([X2b(:,1) Y2(:,1)]',[X2b(:,2) Y2(:,2)]','k-')
        hold off
    title([int2str(n_good) ' correspondences (unwarped X)'])
drawnow	
%---------------------------------------------------------


%剩下的再去看誰在threshold裡---用的轉換矩陣是voting對最多的那一個
figure,plot(x1(:,1),x1(:,2),'b+',y2a(:,1),y2a(:,2),'ro')
ind=cvec(ind_good);
hold on
trans=transform_matrix(index);
threshold=0.1;
for f=1:1:size(Y2(:,1),1)
    mapping=[X2b(f,1) X2b(f,2) 1]*[trans{1,1}]; 
    %剩下的點要乘上轉換矩陣~看是否shape_context的匹配有對
    corr_map(f,1)=mapping(1,1);%紀錄mapping的點座標
    corr_map(f,2)=mapping(1,2);
                            
    corr_map(f,3)=sqrt((mapping(1,1)-Y2(f,1))^2+(mapping(1,2)-Y2(f,2))^2);%算與標準答案的差距
    if(corr_map(f,3)<=threshold)  %判斷點數對或錯
        corr_map(f,4)=1;
        plot([X2b(f,1) Y2(f,1)]',[X2b(f,2) Y2(f,2)]','k-')
        hold on;
    else
        corr_map(f,4)=0;
    end
end
hold off;

%畫出對的整張圖                        
figure,plot(x1(:,1),x1(:,2),'b+',y2a(:,1),y2a(:,2),'ro')
ind=cvec(ind_good);
hold on                        
plot([correct_point(:,5) correct_point(:,7)]',[correct_point(:,6) correct_point(:,8)]','r-')                        
hold on
for f=1:1:size(Y2(:,1),1)
    if(corr_map(f,3)<=threshold)  %判斷點數對或錯
        corr_map(f,4)=1;
        plot([X2b(f,1) Y2(f,1)]',[X2b(f,2) Y2(f,2)]','k-')
        hold on;
    end
end
hold off






% %(1)畫圖呈現；(2)判斷點對錯  
% 
% for j=1:1:size(Y_tran,1)
%     %hold off;
%     figure,
%     plot(X(:,1),X(:,2),'b+',Y(:,1),Y(:,2),'ro') 
%     hold on;
%     %-------------點出第一個三角形-------------------
%     plot(X2b(Rand_seed(permutation(j,1)),1),X2b(Rand_seed(permutation(j,1)),2),'Rx')
%     plot(X2b(Rand_seed(permutation(j,2)),1),X2b(Rand_seed(permutation(j,2)),2),'Rx')
%     plot(X2b(Rand_seed(permutation(j,3)),1),X2b(Rand_seed(permutation(j,3)),2),'Rx')
%     
%     %------------用線畫出第一個三角形---------------
%     plot([X2b(Rand_seed(permutation(j,1)),1) X2b(Rand_seed(permutation(j,2)),1)]',[X2b(Rand_seed(permutation(j,1)),2) X2b(Rand_seed(permutation(j,2)),2)]','k-')
%     plot([X2b(Rand_seed(permutation(j,2)),1) X2b(Rand_seed(permutation(j,3)),1)]',[X2b(Rand_seed(permutation(j,2)),2) X2b(Rand_seed(permutation(j,3)),2)]','k-')
%     plot([X2b(Rand_seed(permutation(j,3)),1) X2b(Rand_seed(permutation(j,1)),1)]',[X2b(Rand_seed(permutation(j,3)),2) X2b(Rand_seed(permutation(j,1)),2)]','k-')
%     
%     %plot([X2b(Rand_seed(record(j,1),1),1) Y2(Rand_seed(record(j,1),1),1)]',[X2b(Rand_seed(record(j,1),1),2) Y2(Rand_seed(record(j,1),1),2)]','k-')
%     %plot([X2b(Rand_seed(record(j,2),1),1) Y2(Rand_seed(record(j,2),1),1)]',[X2b(Rand_seed(record(j,2),1),2) Y2(Rand_seed(record(j,2),1),2)]','k-')
%     %plot([X2b(Rand_seed(record(j,3),1),1) Y2(Rand_seed(record(j,3),1),1)]',[X2b(Rand_seed(record(j,3),1),2) Y2(Rand_seed(record(j,3),1),2)]','k-')
%     
%     %----------------用線畫出第二個三角形-------------------
%     plot([Y2(Rand_seed(permutation(j,1)),1) Y2(Rand_seed(permutation(j,2)),1)]',[Y2(Rand_seed(permutation(j,1)),2) Y2(Rand_seed(permutation(j,2)),2)]','m--')
%     plot([Y2(Rand_seed(permutation(j,2)),1) Y2(Rand_seed(permutation(j,3)),1)]',[Y2(Rand_seed(permutation(j,2)),2) Y2(Rand_seed(permutation(j,3)),2)]','m--')
%     plot([Y2(Rand_seed(permutation(j,3)),1) Y2(Rand_seed(permutation(j,1)),1)]',[Y2(Rand_seed(permutation(j,3)),2) Y2(Rand_seed(permutation(j,1)),2)]','m--')
%     ,title(['mean=' num2str(Y_tran{j,:}(1,4)) ])
%     hold off;
%     %figure, hist(Y_tran{j,1}(:,3), 15),title(['mean=' num2str(Y_tran{j,:}(1,4)) ])
% 
%     figure,
%     for i=1:1:size(Y2(:,1),1)    %X2b 與  mapping的點畫出來
%         plot(X(:,1),X(:,2),'b+',Y(:,1),Y(:,2),'ro') 
%         hold on
%         plot([X2b(i,1) Y_tran{j,1}(i,9)]',[X2b(i,2) Y_tran{j,1}(i,10)]','k-');
%         hold on
%         %pause;      
%     end
%     %pause;
%     hold off;
% %---------------在閥值內的畫綠線--------start----------------    
%     
%     figure,
%     for n=1:1:size(Y2(:,1),1)   %X2b 與  mapping的點畫出來，對的畫綠色錯的畫紅色
%         plot(X(:,1),X(:,2),'b+',Y(:,1),Y(:,2),'ro') 
%         hold on
%         if(Y_tran{j,1}(n,12)==1)
%             plot([X2b(n,1) Y_tran{j,1}(n,9)]',[X2b(n,2) Y_tran{j,1}(n,10)]','g-'),title(['threshold=' num2str(threshold) ]);
%             hold on
%         else
%             plot([X2b(n,1) Y_tran{j,1}(n,9)]',[X2b(n,2) Y_tran{j,1}(n,10)]','r-'),title(['threshold=' num2str(threshold)]);
%             hold on
%         end        
%     end    
%     hold off;   
% %---------------在閥值內的畫綠線--------end----------------     
% end





