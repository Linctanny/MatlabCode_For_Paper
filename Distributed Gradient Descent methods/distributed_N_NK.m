function  [err1,err2,X,k]=distributed_N_NK(f1,f2,f3,alpha,beta)
%下面给出分布式牛顿法的代码，是对二阶算法牛顿法的分布式推广，但是利用Taylor把二阶信息展开
% 输入:函数中的f1,f2,f3是目标函数，alpha，beta是步长
% 输出:err1是最优化误差；err2是一致性误差；X是解矩阵（9，1）；k是迭代次数

%% 给出已知信息,W为信息交流矩阵，stop_rule为停止准则，alpha惩罚系数，beta为固定步长
n=3;   %输入智能体数量
n1=n^2;
k=1;    %迭代次数值
W=[1/2,1/4,1/4;
    1/4,3/4,0;
    1/4,0,3/4];  %根据拓扑图给定
I=eye(n);
stop_rule=1e-5; %停止准则
max_iterate=5000; %最大迭代步长
K=10;  %Taylor展开项的数目
% alpha=0.05;  % 暂且给定，后面看文章修改
% beta=0.1;    % 暂且给定
%% 给出目标函数
syms x y z
% f1=@(x,y,z)2*x.^2+3*y.^2+2*z.^2;
% f2=@(x,y,z)2*x.^2+4*y.^2+3*z.^2;
% f3=@(x,y,z)3*x.^2+3*y.^2+7*z.^2;
gra_1=matlabFunction([diff(f1,x),diff(f1,y),diff(f1,z)]);
gra_2=matlabFunction([diff(f2,x),diff(f2,y),diff(f2,z)]);
gra_3=matlabFunction([diff(f3,x),diff(f3,y),diff(f3,z)]);
% 分别求出f1，f2,f3的hessian矩阵
hess_1=matlabFunction(hessian(f1,[x,y,z]));
hess_2=matlabFunction(hessian(f2,[x,y,z]));
hess_3=matlabFunction(hessian(f3,[x,y,z]));

% 构建矩阵B和D
Z=kron(W,I);
I_big=kron(I,I);
B=I_big-diag(diag(Z))+Z;
D=alpha*blkdiag(hess_1(),hess_2(),hess_3())+2*(I_big-diag(diag(Z)));

% 初始化估计矩阵
X=zeros(n1,1);
G=X;
gra=X;
H=X;   %是后面的最终方向
X(:,k)=[2;3;2.5;4;3;2;1.5;4;0];
gra(:,k)=Col_gra_matrix(gra_1,gra_2,gra_3,X(:,k));


% 给定误差矩阵以进入循环
err1=[1];
err2=[1];

%% 进入循环
while k<max_iterate
    if err1(k)<stop_rule && err2(k)<stop_rule
        break
    else
        %计算梯度矩阵
        G(:,k)=(I_big-Z)*X(:,k)+alpha*gra(:,k); 
        %计算下降方向
        H_TEMP=-pinv(D)*G(:,k);
        for t=1:K-1
            H_TEMP(:,t+1)=pinv(D)*(B*H_TEMP(:,t)-G(:,k));
        end
        H(:,k)=H_TEMP(:,K);
        %进行迭代次数增加
        k=k+1;
        %对X进行更新
        X(:,k)=X(:,k-1)+beta*H(:,k-1);
        % 求误差err1与err2
        gra(:,k)=Col_gra_matrix(gra_1,gra_2,gra_3,X(:,k));
        X_gra=gra(:,k);
        err1(k)=norm(X_gra(1:3)+X_gra(4:6)+X_gra(7:9));
        err2(k)=G_Agr_C(X(:,k));
    end
end
end