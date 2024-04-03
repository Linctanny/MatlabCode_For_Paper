function [p1,p3]=uncented_filter(opt_esti_init,covar_init,N)
opt_esti=[];%最优估计
opt_esti(:,1)=opt_esti_init;%最优估计初始值
covar_esti=[];%最优估计协方差
covar_esti(:,:,1)=covar_init;%最优估计协方差初始矩阵
one_step_obse=[];%一步观测
one_step_obse(:,1)=zeros(2,1); %一步观测初始值
one_step_path=[]; %一步路径
one_step_path(:,1)=zeros(6,1);
one_step_covar=[]; %一步协方差
one_step_covar(:,:,1)=zeros(6,6);%一步协方差初始化
sigma_xy=[];  %sigma_xy刻画x,y之间的协方差阵
sigma_xy(:,:,1)=zeros(6,2);% 初始化
sigma_y=[];
sigma_y(:,:,1)=zeros(2,2);
obse=[];
obse(:,1)=opt_esti_init(1:2);
K_benefit=[];
K_benefit(:,:,1)=zeros(6,2);
true_path=[];
true_path(:,1)=opt_esti_init;
A=@(t)[1,0,t,0,t^2/2,0;0,1,0,t,0,t^2/2;0,0,1,0,t,0;0,0,0,1,0,t;0,0,0,0,1,0;0,0,0,0,0,1];
Q=diag([1,1,0.1^2,0.01,0.01^2,0.01^2]);
R=diag([100,0.001^2]);
h=@(x)[sqrt(x(1)^2+x(2)^2);atan(x(2)/x(1))];
mean_v=zeros(6,1);
mean_w=zeros(2,1);
for i=2:N+1
    true_path(:,i)=A(0.5)*true_path(:,i-1)+mvnrnd(mean_v,Q)';
end
for i=2:N+1
    obse(:,i)=h(true_path(:,i))+mvnrnd(mean_w,R)';
end
for i=2:N+1
    f=@(x)A(0.5)*x;
    [mean_x,covar_x,x_temp,w]=uncented_trans(opt_esti(:,i-1),covar_esti(:,:,i-1),f);
    one_step_path(:,i)=mean_x;
    one_step_covar(:,:,i)=covar_x+Q;
    [mean_y,covar_y,y_temp,~]=uncented_trans(one_step_path(:,i),one_step_covar(:,:,i),h);
    one_step_obse(:,i)=mean_y;  %到一步预测这里
    sigma_y(:,:,i)=covar_y+R;
    sigma_xy(:,:,i)=gen_sigma_xy(x_temp,mean_x,y_temp,mean_y,w);
    K_benefit(:,:,i)=sigma_xy(:,:,i)*pinv(sigma_y(:,:,i));
    opt_esti(:,i)=one_step_path(:,i)+K_benefit(:,:,i)*(obse(:,i)-one_step_obse(:,i));
    covar_esti(:,:,i)=one_step_covar(:,:,i)-K_benefit(:,:,i)*sigma_y(:,:,i)*K_benefit(:,:,i)';
end
%% 绘图
figure(1)
hold on
p1=plot(true_path(1,:),true_path(2,:),'-dr');%真实轨迹作图
% p2=plot(obse(1,:),obse(2,:),'og');%观测作图
p3=plot(opt_esti(1,:),opt_esti(2,:),'-*b');%滤波轨迹作图
xlabel('x方向位置/m')
ylabel('y方向位置/m')
hold off
title('UKF-目标跟踪图')
legend([p1,p3],'True Trajectory','Filter Estimate');%添加标签
figure(2)
subplot(1,2,1)
p4=plot(opt_esti(1,:)-true_path(1,:),'o-g');
xlabel('t/s')
ylabel('x方向偏差/m')
title('误差分析图')
subplot(1,2,2)
p5=plot(opt_esti(2,:)-true_path(2,:),'o-r');
xlabel('t/s')
ylabel('y方向偏差/m')
title('误差分析图')

end