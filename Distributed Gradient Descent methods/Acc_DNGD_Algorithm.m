function  [err1,err2,X,k]=Acc_DNGD_Algorithm(f1,f2,f3,miu,eta)
%功能: 下面给出Acc-DNGD算法的代码，同样考虑无向连通上的n个智能体
% 输入:函数中的f1,f2,f3是目标函数，eta是步长,miu作除数
% 输出:err1是最优化误差；err2是一致性误差；X是解矩阵（3，3）；k是迭代次数

%% 输入需要的初值，信息交流矩阵W,stop_rule值，步长alpha,miu,eta，max_iterate
n=3;   %输入智能体数量
k=1;    %迭代次数值
W=[1/2,1/4,1/4;
    1/4,3/4,0;
    1/4,0,3/4];    %根据拓扑图给定
stop_rule=1e-5; %停止准则
max_iterate=5000; %最大迭代次数，超过跳出循环
% miu=0.8;  %暂且给定，具体看论文，以下的eta也是
% eta=0.02;  %暂且给定
alpha=sqrt(miu*eta); 

%% 假定每个智能体解的估计值按行放置在X(:,:,k)中，此外还需要辅助变量矩阵V(:,:,k),Y(:,:,k),S(:,:,k),以及G(:,:,k)为在Y(:,:,k)处的梯度矩阵
% 初始化
X=zeros(n,n);
V=X;
Y=X;
S=X;
G=X;
% 这里第一行是x1对解的估计，第二行是x2对解的估计，第三行是x3对解的估计
X(:,:,k)=X;
Y(:,:,k)=X(:,:,k);
V(:,:,k)=X(:,:,k);

%% 写入各个智能体的目标函数，计算梯度向量(行向量，为构建梯度矩阵)
syms x y z
% f1=@(x,y,z)2*(x-1).^2+3*(y-1).^2+2*z.^2;
% f2=@(x,y,z)2*(x-1).^2+4*(y-2).^2+3*z.^2;
% f3=@(x,y,z)3*(x).^2+3*(y-2).^2+7*z.^2;
gra_1=matlabFunction([diff(f1,x),diff(f1,y),diff(f1,z)]);
gra_2=matlabFunction([diff(f2,x),diff(f2,y),diff(f2,z)]);
gra_3=matlabFunction([diff(f3,x),diff(f3,y),diff(f3,z)]);

% 构建S和G的初始矩阵
G(:,:,k)=gra_matrix(gra_1,gra_2,gra_3,Y(:,:,k));
S(:,:,k)=gra_matrix(gra_1,gra_2,gra_3,Y(:,:,k));

% 给定error矩阵,tx矩阵，ty矩阵
err1=[1];
err2=[1];

%% 进行循环的判断，进入循环
while k<max_iterate
    if err1(k)<stop_rule && err2(k)<stop_rule
        break
    else
        %进行解的更新迭代
        k=k+1;
        %更新X
        X(:,:,k)=W*Y(:,:,k-1)-eta*S(:,:,k-1);
        %更新V
        V(:,:,k)=(1-alpha)*W*V(:,:,k-1)+alpha*W*Y(:,:,k-1)-(alpha/miu)*S(:,:,k-1);
        %更新Y
        Y(:,:,k)=(X(:,:,k)+alpha*V(:,:,k))/(1+alpha);
        %更新G
        G(:,:,k)=gra_matrix(gra_1,gra_2,gra_3,Y(:,:,k));
        %更新S
        S(:,:,k)=W*S(:,:,k-1)+G(:,:,k)-G(:,:,k-1);
        % 计算梯度之和的范数以及估计值之间相差很近（待定停止准则）
        X_gra=gra_matrix(gra_1,gra_2,gra_3,X(:,:,k));
        err1(k)=norm(X_gra(1,:)+X_gra(2,:)+X_gra(3,:));
        err2(k)=Acc_D_Agr_C(X(:,:,k));
    end
end
end
