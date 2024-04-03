function [mean_y,covar_y,y,w]=uncented_trans(mean_x,covar_x,f)
% 实现uncented transform
% input:mean_x:输入地均值向量x covar_x:输入地均值向量服从地分布地协方差 f:非线性变换f,ka:分布的参数
% output:mean_y:产生的均值向量y covar_y:产生的y的协方差矩阵
n=size(mean_x,1);
ka=3-n; %仅对于正态分布而言，是用3-n得出ka
x_temp=sqrtm((n+ka).*covar_x);
y_temp=[mean_x];
for i=1:n
    x=mean_x+x_temp(:,i);
    y_temp=[y_temp,x];
end
for i=1:n
    x_=mean_x-x_temp(:,i);
    y_temp=[y_temp,x_];
end
y=[];
for i=1:2*n+1  %产生所有的y
    y_=f(y_temp(:,i));
    y=[y,y_];
end
% 产生权重
w=ones(1,2*n+1).*(1/(2*(n+ka)));
w(1)=ka/(n+ka);
mean_y=y*w';
covar_y=0;
for i=1:2*n+1
    covar_y=covar_y+w(i)*(y(:,i)-mean_y)*(y(:,i)-mean_y)';
end
