%% Nesterov加速梯度法code
% 更新规则
% y^k=x^k+(t_(k-1)-1)/t_k  (x^k-x^(k-1) )@t_(k+1)=(1+√(1+4t_k^2 ))/2   @x^(k+1)=y^k-1/L ∇f(x^k )                  
clc;clear;
%构建目标函数(利用函数句柄)
syms x y;
f=@(x,y)(x-3).^4+(y-1).^4;  %取值方法直接f(x,y)即可
% % 利用surf绘制图三维图形
px=-1:0.01:1;
py=px;
[PX,PY]=meshgrid(px,py);
PZ=f(PX,PY);
figure(1)
surf(PX,PY,PZ);
hold on
% 计算梯度函数
gra=matlabFunction([diff(f,x);diff(f,y)]);
%输入参数:步长1/L=alpha，停止准则er,最大迭代步长max_ite，初置x0=[2,4]'，以及三个辅助变量x(k),y(k),t(k)
alpha=0.1;
er=1e-10;
max_ite=5000;
x=[2 2;2 2]; %向量默认用列向量
y=[2 2;2 2];
t=[1,1];
% 构建迭代序列
gen_x=[x];
gen_y=[y];
gen_t=[t];
k=2;
% 开始迭代
while k<max_ite
    y_temp=gen_x(:,k)+((gen_t(k-1)-1)/gen_t(k))*(gen_x(:,k)-gen_x(:,k-1));
    gen_y=[gen_y,y_temp];
    t_temp=(1+sqrt(1+4*(gen_t(k)).^2))/2;
    gen_t=[gen_t,t_temp];
%计算当前点是否梯度为0
    temp_gra=gra(gen_y(1,k+1),gen_y(2,k+1));
    if norm(temp_gra)<er
        break
    end
    des_step=-temp_gra;
%开始迭代更新
    x_temp=gen_y(:,k+1)+alpha*des_step;
    gen_x=[gen_x,x_temp];
    k=k+1;
    plot3(gen_x(1,k),gen_x(2,k),f(gen_x(1,k),gen_x(2,k)),'red*')
    pause(0.2)
    drawnow;
end