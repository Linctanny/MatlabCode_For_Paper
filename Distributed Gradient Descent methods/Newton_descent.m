%% 构建牛顿下降法代码(定长步长下)
% 牛顿法与简单的梯度下降法主要是下降方向多了一个Hessian矩阵的修正
clc;clear;
%构建目标函数(利用函数句柄)
syms x y;
f=@(x,y)x.^4+y.^4;  %取值方法直接f(x,y)即可
% 利用surf绘制图三维图形
px=-1:0.01:1;
py=px;
[PX,PY]=meshgrid(px,py);
PZ=f(PX,PY);
surf(PX,PY,PZ);
hold on
% 计算hessian矩阵
hess=matlabFunction(hessian(f,[x,y]));
gra=matlabFunction([diff(f,x);diff(f,y)]);
%输入参数:步长alpha，停止准则er,最大迭代步长max_ite，初置x=[2,4]'.
alpha=1;
er=1e-5;
max_ite=5000;
ite=0;
x=[2,4]'; %向量默认用列向量
% 构建迭代序列
gen_x=[x];
gen_y=[f(x(1),x(2))];
% 开始迭代
while ite<max_ite
%计算当前点是否梯度为0
    temp_gra=gra(x(1),x(2));
    if norm(temp_gra)<er
        break
    end
    des_step=-pinv(hess(x(1),x(2)))*temp_gra;
%开始迭代更新
    x=x+alpha*des_step;
    gen_x=[gen_x,x];
    gen_y=[gen_y,f(x(1),x(2))];
    plot3(gen_x(1,:),gen_x(2,:),gen_y,'red*')
    pause(0.2)
    drawnow;
    ite=ite+1;
end
