function  [err1,err2,X,k]=D_NC_Algorithm(f1,f2,f3,alpha)
%% 给出分布式Nesterov的分布式推广D-NC的代码，该代码只考虑n个智能体，处于无向连通图
% 输入:函数中的f1,f2,f3是目标函数，alpha是步长
% 输出:err1是最优化误差；err2是一致性误差；X是解矩阵（9，1）；k是迭代次数

%% 输入需要的初值，信息交流矩阵W,stop_rule值，步长alpha,beta（取固定值），解初始估计矩阵X，max_iterate
n=3;   %输入智能体数量
n1=n^2;
k=1;    %迭代次数值
W=[1/2,1/4,1/4;
    1/4,3/4,0;
    1/4,0,3/4];   %根据拓扑图给定
I=eye(n);
stop_rule=1e-5; %停止准则
max_iterate=5000;
% alpha=0.05;  %先随便给一个，后面看文章修改
beta=[];    %beta(k)=k/(k+3)

%% 假定每个智能体解的估计值按行放置在X(n^2,k)中，此外还需要辅助变量矩阵Y(n^2,k),gra(n^2,k)为在Y(n^2,k)处的梯度矩阵
% 初始化
X=zeros(n1,1);
D=zeros(n1,1);
gra=zeros(n1,1);
% 这里第一行是x1对解的估计，第二行是x2对解的估计，第三行是x3对解的估计
X(:,k)=[1;1;0;
    2;4;1;
    4;2;3];
Y(:,k)=[1;1;0;
    2;4;1;
    4;2;3];

%% 写入各个智能体的目标函数，计算梯度向量(行向量，为构建梯度矩阵)
syms x y z
% f1=@(x,y,z)2*(x-1).^2+3*y.^2+2*z.^2;
% f2=@(x,y,z)2*(x-2).^2+4*y.^2+3*z.^2;
% f3=@(x,y,z)3*x.^2+3*y.^2+7*z.^2;
gra_1=matlabFunction([diff(f1,x),diff(f1,y),diff(f1,z)]);
gra_2=matlabFunction([diff(f2,x),diff(f2,y),diff(f2,z)]);
gra_3=matlabFunction([diff(f3,x),diff(f3,y),diff(f3,z)]);

% 给定error矩阵,tx矩阵，ty矩阵
err1=[1];
err2=[1];
tx=[0];
ty=[0];
% 计算W的第二大奇异值
miu2=get_sec_sin(W);
%% 进行循环的判断，进入循环
while k<max_iterate
    if err1(k)<stop_rule && err2(k)<stop_rule
        break;
    else
        %进行解的更新迭代
        k=k+1;
        %首先计算tx(k+1)
        tx(k)=ceil(-2*(log2(k)/log2(miu2)));
        %得到g在Y(n1,k-1)处的梯度矩阵
        gra(:,k-1)=Col_gra_matrix(gra_1,gra_2,gra_3,Y(:,k-1));
        %进行X的更新
        X(:,k)=(kron(W,I))^tx(k) *(Y(:,k-1)-alpha*gra(:,k-1));
        %再计算ty(k+1),beta(k)
        ty(k)=ceil(-(log2(3*k^2)/log2(miu2)));
        beta(k-1)=(k-1)/(k+2);
        %进行Y的更新
        Y(:,k)=(kron(W,I))^ty(k) *(X(:,k)+beta(k-1)*(X(:,k)-X(:,k-1)));
        % 计算梯度之和的范数以及估计值之间相差很近（待定停止准则）
        X_gra=Col_gra_matrix(gra_1,gra_2,gra_3,X(:,k));
        err1(k)=norm(X_gra(1:3)+X_gra(4:6)+X_gra(7:9));
        err2(k)=G_Agr_C(X(:,k));
    end
end
end