function x=Col_gra_matrix(gra_1,gra_2,gra_3,y)
% 功能:对列向量返回在该点的梯度列向量
% 输入:gra_1:梯度分量（行向量），其余同理；y为待取值点
% 输出:梯度列向量
x=[gra_1(y(1),y(2),y(3)),gra_2(y(4),y(5),y(6)),gra_3(y(7),y(8),y(9))]';
end