clc;clear;
%% 参数设置
% 设定随机种子
rng(1);
% 迭代次数设定
max_iter_num = 20;
% 初始值设置
E = 3*eye(2,2);
x_init = zeros(2,1);
% 常量设定
A = [0 -0.5;0.8 1];
B = [-0.12;0.02];
C = [-100 10];
D = 0.02;
H = 0;
L_1 = [0;1];
L_2 = 0;
R_1 = [0 0.3];
R_2 = 0;
R_3 = 0;
S = 1;
T = 1;
G = 0;
% 扰动量设定
delta = rand(1,max_iter_num)*2-1;
w = rand(1,max_iter_num)*2-1;
v = rand(1,max_iter_num)*2-1;
% P的正定性设定
min_value = 1e-6;
% 观测数据的值的代入
x_k = [];
y_k = [];
x_k(:,1) = [-0.5;1];
for k = 1:max_iter_num
    y_k(:,k) = C*x_k(:,k)+0.02*v(k);
    x_k(:,k+1) = (A+diag([0,0.3*delta(k)]))*x_k(:,k)+B*w(k);
end
% 每一次sdp产生的最优解的存储
x_hat = [];
P_hat = [];
% 对最优解初始值设定，才能代入循环
x_hat(:,1) = x_init;
P_hat(:,:,1) = E;

% 显示进度条
h = waitbar(0,'please wait!');
%% 循环开始
for k = 1:max_iter_num
    %对P_hat进行chokesly分解，得到E_temp
    E_temp = chol(P_hat(:,:,k));
    % pusai的生成，利用null函数
    pusai = null([C*x_hat(:,k)-y_k(:,k) C*E_temp 0 D L_2]);
    % Omiga的生成
    Phi = [R_1*x_init R_1*E_temp R_2 R_3 H;zeros(1,5) 1];
    Omiga = Phi'*[T G;G' -S]*Phi;

% cvx求解sdp问题，每个循环即是求解一次sdp问题
    cvx_begin sdp quiet
    variable tau_x(1) nonnegative
    variable tau_w(1) nonnegative
    variable tau_v(1) nonnegative
    variable x(2)
    variable P(2,2) semidefinite
    minimize(trace(P))
    subject to 
    
        sdp_2 = [A*x_init-x A*E_temp B zeros(2,1) L_1]*pusai;
        sdp_4 = pusai'*([1-tau_x-tau_w-tau_v zeros(1,5);
         zeros(1,1) tau_x zeros(1,4);
         zeros(1,2) tau_x zeros(1,3);
         zeros(1,3) tau_w zeros(1,2);
         zeros(1,4) tau_v zeros(1,1);
         zeros(1,6)]-Omiga)*pusai;
        P - min_value*eye(2) == semidefinite(2);
        [P,sdp_2;sdp_2',sdp_4]-min_value*eye(7) == semidefinite(7);
    
    cvx_end
    % 对x_hat,与P_hat进行赋值  
    x_hat(:,k+1) = x;
    P_hat(:,:,k+1) = P;
    
%进度的计算
    str=['运行中...',num2str(k/max_iter_num*100),'%'];
    waitbar(k/max_iter_num,h,str);
end  

% 取出椭球中心的界
bound = [];
for k = 1:max_iter_num+1
    temp = diag(P_hat(:,:,k));
    bound(k) = temp(1);
end
upper_bound = x_hat(1,:)+bound;
lower_bound = x_hat(1,:)-bound;

%%  绘图
figure(1)
plot(1:max_iter_num+1,x_k(1,:),'r-*',1:max_iter_num+1,x_hat(1,:),'b-o')
hold on
plot(1:max_iter_num+1,upper_bound,'black--',1:max_iter_num+1,lower_bound,'g--')
legend('真实投影','椭球中心投影','上边界','下边界')
xlabel('Time k')
ylabel('z(k)')
title('Robust Filter')















