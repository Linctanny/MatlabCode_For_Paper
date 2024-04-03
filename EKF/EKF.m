function [p1,p3]=EKF(N,x_00,P_00,w_mean,w_var,v_mean,v_var)
% 扩展卡尔曼滤波算法
% input: N:追踪的次数，x_00:初始的状态，P_00：初始的方差阵，w_mean,w_var:过程噪声w服从的高斯分布的参数
% v_mean,v_var:观测噪声v服从的高斯分布的参数
% output:p1:绘制真实轨迹的plot句柄
%        p2:绘制观测轨迹的plot句柄 
%        p3:绘制估计轨迹的plot句柄

one_step_es=zeros(4,N); %一步估计
T_path = zeros(4,N); % 真实运动状态
T_path(:,1)=x_00;   %真实运动状态初始化
one_P_var=zeros(4,4,N); % 一步方差矩阵
one_P_var(:,:,1)=P_00;
P_var=zeros(4,4,N); % 真实方差矩阵
P_var(:,:,1)=P_00; %真实方差矩阵初始化
one_z_hat=zeros(1,N);  % 一步观测预测
H_jocobbi=zeros(N,4); % h的在一步估计处的jacobbi矩阵
K=zeros(4,N);  %增益矩阵
T_z_ob=zeros(1,N);  % 真实观测数值
estimate=zeros(4,N);  % 最优估计值
estimate(:,1)=x_00;
A=zeros(4,4,N);
A(:,:,1)=[1,1,0,0;0,1,0,0;0,0,1,1;0,0,0,1]; %运动方程中的矩阵
Gamma=zeros(4,2,N);
h=@(x)sqrt(x(1)^2+x(3)^2); %假设雷达站位置为(0,0)
gen_jocabbi=@(y)[y(1)/sqrt(y(1)^2+y(3)^2),0,y(3)/sqrt(y(1)^2+y(3)^2),0];
for k =2:N
    A(:,:,k)=[1,k,0,0;0,1,0,0;0,0,1,k;0,0,0,1];
    one_step_es(:,k)=A(:,:,k)*estimate(:,k-1); %一步真实状态估计
    Gamma(:,:,k)=[k^2/2,0;k,0;0,k^2/2;0,k];
    T_path(:,k)=A(:,:,k)*T_path(:,k-1)+Gamma(:,:,k)*mvnrnd(w_mean,w_var)'; % 真实运动状态
    one_P_var(:,:,k)=A(:,:,k)*P_var(:,:,k-1)*A(:,:,k)'+Gamma(:,:,k)*w_var*Gamma(:,:,k)';%一步状态预测方差阵更新
    one_z_hat(k)=h(one_step_es(:,k)); %一步状态观测预测
    H_jocobbi(k,:)=gen_jocabbi(one_step_es(:,k)); %jacobbi矩阵
    K(:,k)=one_P_var(:,:,k)*H_jocobbi(k,:)'*pinv(H_jocobbi(k,:)*one_P_var(:,:,k)*H_jocobbi(k,:)'+v_var);%增益矩阵的计算
    T_z_ob(k)=h(T_path(:,k))+mvnrnd(v_mean,v_var); % 真实的观测
    estimate(:,k)=one_step_es(:,k)+K(:,k)*(T_z_ob(k)-one_z_hat(k));%最优估计
    P_var(:,:,k)=(eye(4)-K(:,k)*H_jocobbi(k,:))*one_P_var(:,:,k); % 真实方差矩阵的计算
end
%% 绘图
figure(1)
hold on
p1=plot(T_path(1,:),T_path(3,:),'-dr');%真实轨迹作图
% p2=plot(T_z_ob(:),'og');%观测作图
p3=plot(estimate(1,:),estimate(3,:),'-*b');%滤波轨迹作图
hold off
xlabel('x方向位置/m')
ylabel('y方向位置/m')
title('EKF-目标跟踪图')
legend([p1,p3],'True Trajectory','Filter Estimate');%添加标签
figure(2)
subplot(1,2,1)
p4=plot(estimate(1,:)-T_path(1,:),'o-g');
xlabel('t/s')
ylabel('x方向偏差/m')
title('误差分析图')
subplot(1,2,2)
p5=plot(estimate(3,:)-T_path(3,:),'o-r');
xlabel('t/s')
ylabel('y方向偏差/m')
title('误差分析图')



end