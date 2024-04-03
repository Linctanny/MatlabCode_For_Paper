function  [err1,err2,X,k]=DIGing_algorithm(f1,f2,f3,alpha)
%功能: 给出计算分布式梯度跟踪法（DIGing）的代码，该代码只考虑n个智能体，处于无向连通图
% 输入:函数中的f1,f2,f3是目标函数，alpha是步长
% 输出:err1是最优化误差；err2是一致性误差；X是解矩阵（3，3）；k是迭代次数

% 输入需要的初值，信息交流矩阵W,stop_rule值，步长alpha（取固定值），解初始估计矩阵X，max_iterate
n=3;   %输入智能体数量
k=1;
W=[1/2,1/4,1/4;
    1/4,3/4,0;
    1/4,0,3/4];   %根据拓扑图给定
stop_rule=1e-5; %停止准则
max_iterate=5000;
% alpha=0.04;  %先随便给一个，后面看文章修改
X=zeros(n,n,1);
D=zeros(n,n,1);
% 这里第一行是x1对解的估计，第二行是x2对解的估计，第三行是x3对解的估计
X(:,:,k)=[1,1,0.5;
          2,4,1;
          4,1,3];

% 写入各个智能体的目标函数，计算梯度向量(行向量，为构建梯度矩阵)
syms x y z
% f1=@(x,y,z)2*(x-1).^2+3*y.^2+2*z.^2;
% f2=@(x,y,z)2*(x-3).^2+4*(y-1).^2+3*(z-5).^2;
% f3=@(x,y,z)3*(x-1).^2+3*y.^2+7*(z-4).^2;
gra_1=matlabFunction([diff(f1,x),diff(f1,y),diff(f1,z)]);
gra_2=matlabFunction([diff(f2,x),diff(f2,y),diff(f2,z)]);
gra_3=matlabFunction([diff(f3,x),diff(f3,y),diff(f3,z)]);

% 给定error矩阵
err1=[1];
err2=[1];
% 对梯度矩阵的初定义,输入gra_1,gra_2,gra_3,以及当前的解的估计矩阵，返回一个三维梯度矩阵
gra=zeros(n,n);
gra(:,:,k)=gra_matrix(gra_1,gra_2,gra_3,X(:,:,k));
D(:,:,k)=gra(:,:,k);
% 进行循环的判断，进入循环
while k<max_iterate
%计算梯度矩阵,
%     error(k)=norm(ones(1,3)*gra(:,:,k));
    %但是自己需要考虑单纯这样仅用范数的来判断能否出循环是否合适？
    if err1(k)<stop_rule && err2(k)<stop_rule
        break
    else
        % 解的更新迭代
        k=k+1;
        X(:,:,k)=W*X(:,:,k-1)-alpha*D(:,:,k-1);
        gra(:,:,k)=gra_matrix(gra_1,gra_2,gra_3,X(:,:,k));
        D(:,:,k)=W*D(:,:,k-1)+gra(:,:,k)-gra(:,:,k-1);
        %计算err1和err2
        X_gra=gra(:,:,k);
        err1(k)=norm(X_gra(1,:)+X_gra(2,:)+X_gra(3,:));
        err2(k)=Acc_D_Agr_C(X(:,:,k));
    end
end
end