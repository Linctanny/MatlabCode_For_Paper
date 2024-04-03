function result=Acc_D_Agr_C(X)
% 功能:计算X中各行向量离其平均向量的距离，用范数计算
ave=(1/3)*(X(1,:)+X(2,:)+X(3,:));
result=norm(X(1,:)-ave)+norm(X(2,:)-ave)+norm(X(3,:)-ave);
end