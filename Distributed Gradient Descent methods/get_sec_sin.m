function result=get_sec_sin(X)
% 功能:求给定矩阵的第二大奇异值
%输入:待求矩阵X
%输出：第二大奇异值result
s=svd(X);   %自动返回奇异值向量，降序排列
result=s(2);
end