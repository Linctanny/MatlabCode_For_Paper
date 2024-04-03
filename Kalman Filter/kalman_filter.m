function [p1,p2,p3]=kalman_filter(N,delta_t,q_1,q_2,sigma_1,sigma_2)
% % 函数kalman_filter为kalman滤波的仿真函数,这里考虑小车的追踪问题
% input: N:追踪的次数，delta_t:运动时间间隔 q_1,q_2:状态方程中过程噪声的的方差矩阵参数
%        sigma_1,sigma_2:观测方程中观测噪声的方差阵的参数
% output:p1:绘制真实轨迹的plot句柄
%        p2:绘制观测轨迹的plot句柄 
%        p3:绘制估计轨迹的plot句柄

%% 矩阵的设定
pre_path = zeros(4,N); % 一步预报向量
impro_path = zeros(4,N); % 修正向量
impro_path(:,1)=zeros(4,1); % 初始估计向量
T_path = zeros(4,N); %真实状态向量
T_path(:,1)=[1,3,2,1]'; %初始状态向量    
watch_path = zeros(2,N); %真实观测向量
H_watch = [1,0,0,0;0,1,0,0]; % 观测方程中的矩阵
A_move = [1,0,delta_t,0;
          0,1,0,delta_t;
          0,0,1,0;
          0,0,0,1]; %运动方程中的矩阵
v_move = zeros(4,N); %运动方程中的噪声向量
v_var =[(q_1*delta_t^3)/3,0,(q_1*delta_t^2)/2,0; 
        0,(q_2*delta_t^3)/3,0,(q_2*delta_t^2)/2;
        (q_1*delta_t^2)/2,0,q_1*delta_t,0;
        0,(q_2*delta_t^2)/2,0,q_2*delta_t];  %运动噪声方差阵
w_watch = zeros(2,N);%观测方程中的噪声向量
w_var = [sigma_1^2,0;
         0,sigma_2^2]; %观测方程中噪声的方差阵
K=zeros(4,2,N); %增益矩阵
estimation_var=zeros(4,4,N); %估计方差阵
estimation_var(:,:,1)=eye(4); %初始方差阵
pre_var=zeros(4,4,N); %一步预报误差阵

%% 迭代进行kalman滤波过程  
for k = 2:N
    v_move(:,k-1) = mvnrnd([0,0,0,0]',v_var); %生成状态方程第k步的噪声向量
    T_path(:,k) = A_move*T_path(:,k-1)+v_move(:,k-1);  %汽车的第k步的运动
    w_watch(:,k) = mvnrnd([0,0]',w_var);
    watch_path(:,k)=H_watch*T_path(:,k)+w_watch(:,k);
    pre_path(:,k)=A_move*impro_path(:,k-1);
    pre_var(:,:,k)=A_move*estimation_var(:,:,k-1)*A_move'+v_var;
    K(:,:,k)=pre_var(:,:,k)*H_watch'*pinv(H_watch*pre_var(:,:,k)*H_watch'+w_var);
    estimation_var(:,:,k)=(eye(4)-K(:,:,k)*H_watch)*pre_var(:,:,k);
    impro_path(:,k)=pre_path(:,k)+K(:,:,k)*(watch_path(:,k)-H_watch*pre_path(:,k));
end

%% 绘图
hold on
p1=plot(T_path(1,:),T_path(2,:),'-dr');%真实轨迹作图
p2=plot(watch_path(1,:),watch_path(2,:),'og');%观测作图
p3=plot(impro_path(1,:),impro_path(2,:),'-*b');%滤波轨迹作图
hold off
legend([p1,p2,p3],'True Trajectory','Measurements','Filter Estimate');%添加标签

end