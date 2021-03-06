clc;
clear;
close all;
% Shape Context Demo #1
% match two pointsets from Chui & Rangarajan

% uncomment out one of these commands to load in some shape data
load cube_pic9_pic1.mat
%load save_fish_def_3_1.mat
%load face_x_y2.mat
%load save_face_notresize.mat
%load save_fish_noise_3_2.mat
%load save_fish_outlier_3_2.mat
%load save_face.mat
%load save_face_ttttt.mat
%load save_face_notdo_anything.mat
%load save_face_two_diff_pic.mat

times=5;
sec_correct_tap=0;
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
   plot(x1(:,1),x1(:,2),'b+',y2a(:,1),y2a(:,2),'ro'),axis tight
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
    ,axis tight
        hold off
    title([int2str(n_good) ' correspondences (unwarped X)'])
drawnow	
%-----------以下取自tps_iter_match_1----------------end


for i=1:1:2000
    ans_is=0;
    while(ans_is==0)
        Rand_one=randperm(size(X2b(:,1),1))';%亂數取樣
        Rand_two=randperm(size(X2b(:,1),1))';%亂數取樣
        Rand_three=randperm(size(X2b(:,1),1))';%亂數取樣
        Rand_seed(1,1)=Rand_one(1,1);
        Rand_seed(2,1)=Rand_two(1,1);
        Rand_seed(3,1)=Rand_three(1,1); 
        first_line=sqrt((X2b(Rand_seed(1),1)-X2b(Rand_seed(2),1))^2+(X2b(Rand_seed(1),2)-X2b(Rand_seed(2),2))^2);
        sec_line=sqrt((X2b(Rand_seed(1),1)-X2b(Rand_seed(3),1))^2+(X2b(Rand_seed(1),2)-X2b(Rand_seed(3),2))^2);
        third_line=sqrt((X2b(Rand_seed(2),1)-X2b(Rand_seed(3),1))^2+(X2b(Rand_seed(2),2)-X2b(Rand_seed(3),2))^2);
        if(first_line+sec_line > third_line && first_line+third_line > sec_line && sec_line+third_line > first_line )
            ans_is=1;
        else
            ans_is=0;
        end
    end
    permutation(i,1)=Rand_one(1,1);
    permutation(i,2)=Rand_two(1,1);
    permutation(i,3)=Rand_three(1,1);
    
    in_points = [X2b(permutation(i,1),1) X2b(permutation(i,1),2);X2b(permutation(i,2),1) X2b(permutation(i,2),2);X2b(permutation(i,3),1) X2b(permutation(i,3),2)];   
    out_points = [Y2(permutation(i,1),1) Y2(permutation(i,1),2);Y2(permutation(i,2),1) Y2(permutation(i,2),2);Y2(permutation(i,3),1) Y2(permutation(i,3),2)]; 
    tform2 = maketform('affine',in_points,out_points);
    transform_matrix{i,1}=tform2.tdata.T;%紀錄每次的轉換矩陣
    for f=1:1:size(Y2(:,1),1)
                        if(f~=permutation(i,1) && f~=permutation(i,2) && f~=permutation(i,3))
                            mapping=[X2b(f,1) X2b(f,2) 1]*[tform2.tdata.T]; 
                            %剩下的點要乘上轉換矩陣~看是否shape_context的匹配有對
                            Y_tran{i,1}(f,9)=mapping(1,1);%紀錄mapping的點座標
                            Y_tran{i,1}(f,10)=mapping(1,2);                          
                            Y_tran{i,1}(f,11)=sqrt((mapping(1,1)-Y2(f,1))^2+(mapping(1,2)-Y2(f,2))^2);%算與標準答案的差距
                        else
                            Y_tran{i,1}(f,9)=Y2(f,1);%紀錄mapping的點座標
                            Y_tran{i,1}(f,10)=Y2(f,2);
                            Y_tran{i,1}(f,11)=0;
                        end
                        if(Y_tran{i,1}(f,11)<=threshold)  %判斷點數對或錯
                            Y_tran{i,1}(f,12)=1;
                        else
                            Y_tran{i,1}(f,12)=0;
                        end
    end
    Y_tran{i,1}(:,1)=X(:,1);%紀錄X座標
    Y_tran{i,1}(:,2)=X(:,2);
    Y_tran{i,1}(:,3)=Y(:,1);%紀錄Y座標
    Y_tran{i,1}(:,4)=Y(:,2);
    Y_tran{i,1}(:,5)=X2b(:,1);%紀錄X2b座標
    Y_tran{i,1}(:,6)=X2b(:,2);
    Y_tran{i,1}(:,7)=Y2(:,1);%紀錄Y2座標
    Y_tran{i,1}(:,8)=Y2(:,2);
    permutation(i,6)=mean(Y_tran{i,:}(:,11));
    permutation(i,4)=sum(Y_tran{i,1}(:,12));  %對幾個
    permutation(i,5)=size(Y2(:,1),1)-sum(Y_tran{i,1}(:,12));%錯幾個
                               
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

X(:,1)=wrong_point(:,5);
X(:,2)=wrong_point(:,6);
Y(:,1)=wrong_point(:,7);
Y(:,2)=wrong_point(:,8);

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
   plot(x1(:,1),x1(:,2),'b+',y2a(:,1),y2a(:,2),'ro'),axis tight
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
    plot([X2b(:,1) Y2(:,1)]',[X2b(:,2) Y2(:,2)]','k-'),axis tight
        hold off
    title([int2str(n_good) ' correspondences (unwarped X)'])
drawnow	
%---------------------------------------------------------


%剩下的再去看誰在threshold裡---用的轉換矩陣是voting對最多的那一個
figure,plot(x1(:,1),x1(:,2),'b+',y2a(:,1),y2a(:,2),'ro')
ind=cvec(ind_good);
hold on
%trans=transform_matrix(index);

input_point(:,1)=correct_point(:,5);
input_point(:,2)=correct_point(:,6);
base_point(:,1)=correct_point(:,7);
base_point(:,2)=correct_point(:,8);
t_affine1 = cp2tform(input_point,base_point,'affine');

threshold=0.1;
for f=1:1:size(Y2(:,1),1)
    mapping=[X2b(f,1) X2b(f,2) 1]*[t_affine1.tdata.T]; 
    %剩下的點要乘上轉換矩陣~看是否shape_context的匹配有對
    corr_map(f,9)=mapping(1,1);%紀錄mapping的點座標
    corr_map(f,10)=mapping(1,2);
                            
    corr_map(f,11)=sqrt((mapping(1,1)-Y2(f,1))^2+(mapping(1,2)-Y2(f,2))^2);%算與標準答案的差距
    if(corr_map(f,11)<=threshold)  %判斷點數對或錯
        corr_map(f,12)=1;
        plot([X2b(f,1) Y2(f,1)]',[X2b(f,2) Y2(f,2)]','k-')
        hold on;
        corr_map(f,5)=X2b(f,1);%紀錄X2b座標
        corr_map(f,6)=X2b(f,2);
        corr_map(f,7)=Y2(f,1);%紀錄Y2座標
        corr_map(f,8)=Y2(f,2);
    else
        corr_map(f,12)=0;
        corr_map(f,5)=X2b(f,1);%紀錄X2b座標
        corr_map(f,6)=X2b(f,2);
        corr_map(f,7)=Y2(f,1);%紀錄Y2座標
        corr_map(f,8)=Y2(f,2);
    end

end
,axis tight
hold off;
corr_map(:,1)=X(:,1);%紀錄X座標
corr_map(:,2)=X(:,2);
corr_map(:,3)=Y(:,1);%紀錄Y座標
corr_map(:,4)=Y(:,2);
%corr_map(:,5)=X2b(:,1);%紀錄X2b座標
%corr_map(:,6)=X2b(:,2);
%corr_map(:,7)=Y2(:,1);%紀錄Y2座標
%corr_map(:,8)=Y2(:,2);

%畫出對的整張圖                        
figure,plot(x1(:,1),x1(:,2),'b+',y2a(:,1),y2a(:,2),'ro')
ind=cvec(ind_good);
hold on                        
plot([correct_point(:,5) correct_point(:,7)]',[correct_point(:,6) correct_point(:,8)]','r-')                        
hold on
count=1;
count1=1;
for f=1:1:size(Y2(:,1),1)
    if(corr_map(f,11)<=threshold)  %判斷點數對或錯   
        plot([X2b(f,1) Y2(f,1)]',[X2b(f,2) Y2(f,2)]','k-')
        hold on;
        sec_correct(count1,:)=corr_map(f,:);
        count1=count1+1;
        sec_correct_tap=1;
    else
        sec_wrong(count,:)=corr_map(f,:);
        count=count+1;
    end
end
,axis tight,title(['total correct point=' num2str(sum(corr_map(:,12))+size(correct_point(:,1),1)) ])
hold off
if(sec_correct_tap>0)
correct=[correct_point;sec_correct];  %再次做過匈牙利最後對的點
end
if(sec_correct_tap==0)
    correct=[correct_point];
end
if(size(correct,1)==300)
    temp5=0
    for b=1:1:size(correct,1)  
        sum5=sqrt((correct(b,7)-correct(b,9))^2+(correct(b,8)-correct(b,10))^2);
        temp5=sum5+temp5;   
    end
    pic_dis_all=temp5/300;
end

if(size(correct,1)~=300)
temp_sec_wrong=sec_wrong;
for i=1:1:size(sec_wrong,1)
    figure,plot(x1(:,1),x1(:,2),'b+',y2a(:,1),y2a(:,2),'ro')
    ind=cvec(ind_good);
    hold on
    plot(sec_wrong(i,5),sec_wrong(i,6),'Rx')
    hold on
    plot(sec_wrong(i,9),sec_wrong(i,10),'Rx')
    hold on
    plot([sec_wrong(i,5) sec_wrong(i,9)]',[sec_wrong(i,6) sec_wrong(i,10)]','k-');
    hold on
    r=0.10;
    x0=sec_wrong(i,9);
    y0=sec_wrong(i,10);
    t=linspace(0, 2*pi, 360);
    x=x0+r*cos(t);
    y=y0+r*sin(t);
    plot(x,y);
    hold on
    plot(sec_wrong(:,7),sec_wrong(:,8),'kx'),axis tight
    hold off
        for k=1:1:size(sec_wrong,1)   
            temp_sec_wrong(i,k+12) =sqrt((temp_sec_wrong(i,9)-temp_sec_wrong(k,7))^2+(temp_sec_wrong(i,10)-temp_sec_wrong(k,8))^2);           
        end
        if(min(temp_sec_wrong(i,13:12+size(sec_wrong,1)))<0.1)
            temp=find(temp_sec_wrong(i,13:12+size(temp_sec_wrong,1))==min(temp_sec_wrong(i,13:12+size(temp_sec_wrong,1))))
            sec_wrong(i,7)=temp_sec_wrong(temp(1,1),7);
            sec_wrong(i,8)=temp_sec_wrong(temp(1,1),8);
            sec_wrong(i,12)=1;
            temp_sec_wrong(temp(1,1),7)=99;
            temp_sec_wrong(temp(1,1),8)=99;
        end
end

figure,plot(x1(:,1),x1(:,2),'b+',y2a(:,1),y2a(:,2),'ro')
hold on
for i=1:1:size(sec_wrong,1)
    if(sec_wrong(i,12)==1)
         plot(sec_wrong(i,5),sec_wrong(i,6),'Rx')
         plot(sec_wrong(i,7),sec_wrong(i,8),'Rx')
         plot([sec_wrong(i,5) sec_wrong(i,7)]',[sec_wrong(i,6) sec_wrong(i,8)]','g-');
    else
         plot(sec_wrong(i,5),sec_wrong(i,6),'Rx')
         plot(sec_wrong(i,9),sec_wrong(i,10),'Rx')
         plot([sec_wrong(i,5) sec_wrong(i,9)]',[sec_wrong(i,6) sec_wrong(i,10)]','r-');
    end
end
plot(sec_wrong(:,7),sec_wrong(:,8),'kx'),title(['total correct point=' num2str(sum(corr_map(:,12))+size(correct_point(:,1),1)+sum(sec_wrong(:,12))) ]),axis tight
temp1_tap=0;
temp2_tap=0;
sum=1;
for i=1:1:size(corr_map,1)
    if(corr_map(i,12)==1)
        temp1(sum,:)=corr_map(i,:);
        sum=sum+1;
        temp1_tap=1;
    end      
end
sum=1;
for i=1:1:size(sec_wrong,1)
    if(sec_wrong(i,12)==1)
        temp2(sum,:)=sec_wrong(i,:);
        sum=sum+1;
        temp2_tap=1;
    end
end

if(temp1_tap==0 && temp2_tap~=0)
    All_correct_point=[temp2;correct_point];
end
if(temp2_tap==0 && temp1_tap~=0)
    All_correct_point=[temp1;correct_point];
end
if(temp1_tap~=0 && temp2_tap~=0)
    All_correct_point=[temp1;temp2;correct_point];
end
if(temp1_tap==0 && temp2_tap==0)
    All_correct_point=[correct_point];
end

input_points(:,1)=All_correct_point(:,5);
input_points(:,2)=All_correct_point(:,6);
base_points(:,1)=All_correct_point(:,7);
base_points(:,2)=All_correct_point(:,8);
t_affine = cp2tform(input_points,base_points,'affine');

for i=1:1:size(All_correct_point,1)
    mapping=[All_correct_point(i,5) All_correct_point(i,6) 1]*[t_affine.tdata.T];
    cp2tform_map(i,1)=mapping(1,1);
    cp2tform_map(i,2)=mapping(1,2);
end
figure,plot(x1(:,1),x1(:,2),'b+',y2a(:,1),y2a(:,2),'ro')
ind=cvec(ind_good);
hold on                        
plot([All_correct_point(:,5) All_correct_point(:,7)]',[All_correct_point(:,6) All_correct_point(:,8)]','k-'),axis tight
hold off

%figure,plot(x1(:,1),x1(:,2),'b+',y2a(:,1),y2a(:,2),'ro')
%ind=cvec(ind_good);
%hold on 
%plot(cp2tform_map(:,1),cp2tform_map(:,2),'k*')
%hold on 
%plot([All_correct_point(:,5) cp2tform_map(:,1)]',[All_correct_point(:,6) cp2tform_map(:,2)]','g-'),title(['cp2tform    mapping']);
%axis tight

dis_sum=0;
for i=1:1:size(All_correct_point,1)
    temp=sqrt((All_correct_point(i,7)-cp2tform_map(i,1))^2+(All_correct_point(i,8)-cp2tform_map(i,2))^2);
    dis_sum=dis_sum+temp;
end


figure,plot(x1(:,1),x1(:,2),'b+',y2a(:,1),y2a(:,2),'ro')
ind=cvec(ind_good);
pic_dis=(((300-size(All_correct_point,1))*0.15)+dis_sum)/300;
end