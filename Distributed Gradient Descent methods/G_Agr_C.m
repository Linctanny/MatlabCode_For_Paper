function y=G_Agr_C(x)
% 计算各个解的估计离平均值的距离的范数
% 输入:由解组成的列向量
% 输出:一致性误差
x1=x(1:3);
x2=x(4:6);
x3=x(7:9);
ave_x=(1/3)*(x1+x2+x3);
y=norm(x1-ave_x)+norm(x2-ave_x)+norm(x3-ave_x);
end