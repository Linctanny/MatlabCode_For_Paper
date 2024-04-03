clc;clear
f1=@(x,y,z)2*(x-1).^2+3*(y-2).^2+2*z.^2;
f2=@(x,y,z)2*(x-1).^2+4*(y-2).^2+3*z.^2;
f3=@(x,y,z)3*(x-1).^2+3*(y-2).^2+7*z.^2;
alpha=[0.05,0.07,0.03 ,0.02,0.01 ,0.1];
beta=0.1;
miu=1;
% 分布式梯度下降法
[err1_DGD,err2_DGD,X_DGD,k_DGD]=distributed_gradient_algorithm(f1,f2,f3,alpha(1));
% f1=@(x,y,z)2*(x-1).^2+3*(y-2).^2+2*z.^2;
% f2=@(x,y,z)2*(x-1).^2+4*(y-2).^2+3*z.^2;
% f3=@(x,y,z)3*(x-1).^2+3*(y-2).^2+7*z.^2;
%绘制distributed gradient descent 每一个智能体的分量一致性过程，与最优解的变化过程
compo_1=[];
compo_2=[];
compo_3=[];
for i=1:k_DGD
    compo_1=[compo_1,X_DGD(:,1,i)];
    compo_2=[compo_2,X_DGD(:,2,i)];
    compo_3=[compo_3,X_DGD(:,3,i)];
end
agent={'智能体1','智能体2','智能体3'};
component={compo_1,compo_2,compo_3};
title1={'(a)智能体状态随迭代次数的变化','(b)智能体状态随迭代次数的变化','(c)智能体状态随迭代次数的变化'};
for i=1:3
figure(i)
p1=plot(component{i}(1,:),'r-');
grid on
hold on
p2=plot(component{i}(2,:),'k:.');
p3=plot(component{i}(3,:),'bo-','MarkerFaceColor','b','MarkerSize',3);
xlabel('迭代次数')
ylabel(['迭代解向量第',num2str(i),'分量'])
title(title1{i})
legend([p1,p2,p3],agent{1},agent{2},agent{3})
daspect([30,0.8,1])
box on
hold off
end
% 画出g(xi)-g的三张图
res1=[];
res2=[];
res3=[];
for i = 1:20
    res_temp=f1(X_DGD(1,1,i),X_DGD(1,2,i),X_DGD(1,3,i))+f2(X_DGD(1,1,i),X_DGD(1,2,i),X_DGD(1,3,i))+f3(X_DGD(1,1,i),X_DGD(1,2,i),X_DGD(1,3,i));
    res1=[res1,res_temp];
end
for i = 1:20
    res_temp=f1(X_DGD(2,1,i),X_DGD(2,2,i),X_DGD(2,3,i))+f2(X_DGD(2,1,i),X_DGD(2,2,i),X_DGD(2,3,i))+f3(X_DGD(2,1,i),X_DGD(2,2,i),X_DGD(2,3,i));
    res2=[res2,res_temp];
end
for i = 1:20
    res_temp=f1(X_DGD(3,1,i),X_DGD(3,2,i),X_DGD(3,3,i))+f2(X_DGD(3,1,i),X_DGD(3,2,i),X_DGD(3,3,i))+f3(X_DGD(3,1,i),X_DGD(3,2,i),X_DGD(3,3,i));
    res3=[res3,res_temp];
end
figure(4)
pl1=semilogy(res1,'r--');
hold on
pl2=semilogy(res2,'k-o');
pl3=semilogy(res3,'b-*');
xlabel('迭代次数')
ylabel('$$ g(x_i)-g(x^*) $$','Interpreter','latex')
title('分布式梯度下降法')
legend([pl1 pl2 pl3],agent{1},agent{2},agent{3})
box on
% % ax = gca;
% ax.YAxis.Exponent = 1;%常数2为指数值，改为0即不使用科学计数法
% 分布式Extra算法
% [err1_Extra,err2_Extra,X_Extra,k_Extra]=Extra_algorithm(f1,f2,f3,alpha(2));
% g=@(x)2*(x(1)-1).^2+3*(x(2)-2).^2+2*x(3).^2+2*(x(1)-1).^2+4*(x(2)-1).^2+3*x(3).^2+3*(x(1)-2).^2+3*(x(2)-2).^2+7*x(3).^2;
% [x,fval]=fmincon(g,[0,0,0]);
% % f1=@(x,y,z)2*(x-1).^2+3*(y-2).^2+2*z.^2;
% % f2=@(x,y,z)2*(x-1).^2+4*(y-1).^2+3*z.^2;
% % f3=@(x,y,z)3*(x-2).^2+3*(y-2).^2+7*z.^2;
% %绘制distributed Exra descent 每一个智能体的分量一致性过程，与最优解的变化过程
% compo_1=[];
% compo_2=[];
% compo_3=[];
% for i=1:k_Extra
%     compo_1=[compo_1,X_Extra(:,1,i)];
%     compo_2=[compo_2,X_Extra(:,2,i)];
%     compo_3=[compo_3,X_Extra(:,3,i)];
% end
% agent={'智能体1','智能体2','智能体3'};
% component={compo_1,compo_2,compo_3};
% title1={'(a)智能体状态随迭代次数的变化','(b)智能体状态随迭代次数的变化','(c)智能体状态随迭代次数的变化'};
% for i=1:3
% figure(i)
% p1=plot(component{i}(1,:),'r-');
% grid on
% hold on
% p2=plot(component{i}(2,:),'k:.');
% p3=plot(component{i}(3,:),'bo-','MarkerFaceColor','b','MarkerSize',3);
% xlabel('迭代次数')
% ylabel(['迭代解向量第',num2str(i),'分量'])
% title(title1{i})
% legend([p1,p2,p3],agent{1},agent{2},agent{3})
% daspect([40,0.8,1])
% % axis square
% box on
% end
% % 画出g(xi)-g的三张图
% res1=[];
% res2=[];
% res3=[];
% for i = 1:40
%     res_temp=f1(X_Extra(1,1,i),X_Extra(1,2,i),X_Extra(1,3,i))+f2(X_Extra(1,1,i),X_Extra(1,2,i),X_Extra(1,3,i))+f3(X_Extra(1,1,i),X_Extra(1,2,i),X_Extra(1,3,i));
%     res1=[res1,res_temp];
% end
% for i = 1:40
%     res_temp=f1(X_Extra(2,1,i),X_Extra(2,2,i),X_Extra(2,3,i))+f2(X_Extra(2,1,i),X_Extra(2,2,i),X_Extra(2,3,i))+f3(X_Extra(2,1,i),X_Extra(2,2,i),X_Extra(2,3,i));
%     res2=[res2,res_temp];
% end
% for i = 1:40
%     res_temp=f1(X_Extra(3,1,i),X_Extra(3,2,i),X_Extra(3,3,i))+f2(X_Extra(3,1,i),X_Extra(3,2,i),X_Extra(3,3,i))+f3(X_Extra(3,1,i),X_Extra(3,2,i),X_Extra(3,3,i));
%     res3=[res3,res_temp];
% end
% res1=res1-fval;
% res2=res2-fval;
% res3=res3-fval;
% figure(4)
% pl1=semilogy(res1,'r--');
% hold on
% pl2=semilogy(res2,'k-o');
% pl3=semilogy(res3,'b-*');
% xlabel('迭代次数')
% ylabel('$$ g(x_i)-g(x^*) $$','Interpreter','latex')
% title('分布式Extra算法')
% legend([pl1 pl2 pl3],agent{1},agent{2},agent{3})
% box on
%% 分布式DIGing算法
% [err1_DIG,err2_DIG,X_DIG,k_DIG]=DIGing_algorithm(f1,f2,f3,alpha(3));
% %f1=@(x,y,z)2*(x-1).^2+3*(y-2).^2+2*z.^2;
% % f2=@(x,y,z)2*(x-1).^2+4*(y-1).^2+3*z.^2;
% % f3=@(x,y,z)3*(x-2).^2+3*(y-3).^2+7*z.^2;
% % 计算原问题的最优值
% g=@(x)2*(x(1)-1).^2+3*(x(2)-2).^2+2*x(3).^2+2*(x(1)-1).^2+4*(x(2)-1).^2+3*x(3).^2+3*(x(1)-2).^2+3*(x(2)-3).^2+7*x(3).^2;
% [x,fval]=fmincon(g,[0,0,0]);
% % 画一致性与最优性
% compo_1=[];
% compo_2=[];
% compo_3=[];
% for i=1:k_DIG
%     compo_1=[compo_1,X_DIG(:,1,i)];
%     compo_2=[compo_2,X_DIG(:,2,i)];
%     compo_3=[compo_3,X_DIG(:,3,i)];
% end
% agent={'智能体1','智能体2','智能体3'};
% component={compo_1,compo_2,compo_3};
% title1={'(a)智能体状态随迭代次数的变化','(b)智能体状态随迭代次数的变化','(c)智能体状态随迭代次数的变化'};
% for i=1:3
% % subplot(1,3,i)
% figure(i)
% p1=plot(component{i}(1,:),'r-');
% grid on
% hold on
% p2=plot(component{i}(2,:),'k:.');
% p3=plot(component{i}(3,:),'bo-','MarkerFaceColor','b','MarkerSize',3);
% xlabel('迭代次数')
% ylabel(['迭代解向量第',num2str(i),'分量'])
% title(title1{i})
% legend([p1,p2,p3],agent{1},agent{2},agent{3})
% daspect([40,0.8,1])
% % axis square
% box on
% end
% % 画出g(xi)-g的三张图
% res1=[];
% res2=[];
% res3=[];
% for i = 1:50
%     res_temp=f1(X_DIG(1,1,i),X_DIG(1,2,i),X_DIG(1,3,i))+f2(X_DIG(1,1,i),X_DIG(1,2,i),X_DIG(1,3,i))+f3(X_DIG(1,1,i),X_DIG(1,2,i),X_DIG(1,3,i));
%     res1=[res1,res_temp];
% end
% for i = 1:50
%     res_temp=f1(X_DIG(2,1,i),X_DIG(2,2,i),X_DIG(2,3,i))+f2(X_DIG(2,1,i),X_DIG(2,2,i),X_DIG(2,3,i))+f3(X_DIG(2,1,i),X_DIG(2,2,i),X_DIG(2,3,i));
%     res2=[res2,res_temp];
% end
% for i = 1:50
%     res_temp=f1(X_DIG(3,1,i),X_DIG(3,2,i),X_DIG(3,3,i))+f2(X_DIG(3,1,i),X_DIG(3,2,i),X_DIG(3,3,i))+f3(X_DIG(3,1,i),X_DIG(3,2,i),X_DIG(3,3,i));
%     res3=[res3,res_temp];
% end
% res1=res1-fval;
% res2=res2-fval;
% res3=res3-fval;
% figure(4)
% pl1=semilogy(res1,'r--');
% hold on
% pl2=semilogy(res2,'k-o');
% pl3=semilogy(res3,'b-*');
% xlabel('迭代次数')
% ylabel('$$ g(x_i)-g(x^*) $$','Interpreter','latex')
% title('分布式梯度跟踪算法')
% legend([pl1 pl2 pl3],agent{1},agent{2},agent{3})
% box on

% scatter3(component{1}(1,:),component{2}(1,:),component{3}(1,:),'filled')
% hold on
% scatter3(component{1}(2,:),component{2}(2,:),component{3}(2,:))
% hold on
% % scatter3(component{1}(3,:),component{2}(3,:),component{3}(3,:))
% % D-NC 分布式一致性Nesterov算法(需要重新写，解变量是9*1的)
% % [err1_D_NC,err2_D_NC,X_D_NC,k_D_NC]=D_NC_Algorithm(f1,f2,f3,alpha(4));
% % f1=@(x,y,z)2*(x-1).^2+3*(y-2).^2+2*(z-1).^2;
% % f2=@(x,y,z)2*(x-1).^2+4*(y-1).^2+3*z.^2;
% % f3=@(x,y,z)3*(x-2).^2+3*(y-2).^2+7*z.^2;
% % 计算原问题的最优值
% % g=@(x)2*(x(1)-1).^2+3*(x(2)-2).^2+2*(x(3)-1).^2+2*(x(1)-1).^2+4*(x(2)-1).^2+3*x(3).^2+3*(x(1)-2).^2+3*(x(2)-2).^2+7*x(3).^2;
% % [x,fval]=fmincon(g,[0,0,0]);
% % 画一致性与最优性
% % compo_1=[X_D_NC(1,:);X_D_NC(4,:);X_D_NC(7,:)];
% % compo_2=[X_D_NC(2,:);X_D_NC(5,:);X_D_NC(8,:)];
% % compo_3=[X_D_NC(3,:);X_D_NC(6,:);X_D_NC(9,:)];
% % 
% % agent={'智能体1','智能体2','智能体3'};
% % component={compo_1,compo_2,compo_3};
% % title1={'(a)智能体状态随迭代次数的变化','(b)智能体状态随迭代次数的变化','(c)智能体状态随迭代次数的变化'};
% % for i=1:3
% % subplot(1,3,i)
% % figure(i)
% % p1=plot(component{i}(1,:),'r-');
% % grid on
% % hold on
% % p2=plot(component{i}(2,:),'g:.');
% % p3=plot(component{i}(3,:),'bo-','MarkerFaceColor','b','MarkerSize',3);
% % xlabel('迭代次数')
% % ylabel(['迭代解向量第',num2str(i),'分量'])
% % title(title1{i})
% % legend([p1,p2,p3],agent{1},agent{2},agent{3})
% % daspect([40,0.8,1])
% % axis square
% % box on
% % end
% % 画出g(xi)-g的三张图
% % res1=[];
% % res2=[];
% % res3=[];
% % for i = 1:50
% %     res_temp=f1(X_D_NC(1,i),X_D_NC(2,i),X_D_NC(3,i))+f2(X_D_NC(1,i),X_D_NC(2,i),X_D_NC(3,i))+f3(X_D_NC(1,i),X_D_NC(2,i),X_D_NC(3,i));
% %     res1=[res1,res_temp];
% % end
% % for i = 1:50
% %       res_temp=f1(X_D_NC(4,i),X_D_NC(5,i),X_D_NC(6,i))+f2(X_D_NC(4,i),X_D_NC(5,i),X_D_NC(6,i))+f3(X_D_NC(4,i),X_D_NC(5,i),X_D_NC(6,i));
% %     res2=[res2,res_temp];
% % end
% % for i = 1:50
% %     res_temp=f1(X_D_NC(7,i),X_D_NC(8,i),X_D_NC(9,i))+f2(X_D_NC(7,i),X_D_NC(8,i),X_D_NC(9,i))+f3(X_D_NC(7,i),X_D_NC(8,i),X_D_NC(9,i));
% %     res3=[res3,res_temp];
% % end
% % res1=res1-fval;
% % res2=res2-fval;
% % res3=res3-fval;
% % figure(4)
% % pl1=semilogy(res1,'r--');
% % hold on
% % pl2=semilogy(res2,'k-o');
% % pl3=semilogy(res3,'b-*');
% % xlabel('迭代次数')
% % ylabel('$$ g(x_i)-g(x^*) $$','Interpreter','latex')
% % title('分布式一致性Nesterov算法')
% % legend([pl1 pl2 pl3],agent{1},agent{2},agent{3})
% % box on
% 分布式加速Nesterov算法
%  [err1_Acc_DNGD,err2_Acc_DNGD,X_Acc_DNGD,k_Acc_DNGD]=Acc_DNGD_Algorithm(f1,f2,f3,miu,alpha(5));
% % f1=@(x,y,z)2*(x-1).^2+3*(y-2).^2+2*(z-1).^2;
% % f2=@(x,y,z)2*(x-1).^2+4*(y-1).^2+3*(z-2).^2;
% % f3=@(x,y,z)3*(x-2).^2+3*(y-2).^2+7*z.^2;
% % % 计算原问题的最优值
% g=@(x)2*(x(1)-1).^2+3*(x(2)-2).^2+2*(x(3)-1).^2+2*(x(1)-1).^2+4*(x(2)-1).^2+3*(x(3)-2).^2+3*(x(1)-2).^2+3*(x(2)-2).^2+7*x(3).^2;
% [x,fval]=fmincon(g,[0,0,0]);
% % 画一致性与最优性
% compo_1=[];
% compo_2=[];
% compo_3=[];
% for i=1:k_Acc_DNGD
%     compo_1=[compo_1,X_Acc_DNGD(:,1,i)];
%     compo_2=[compo_2,X_Acc_DNGD(:,2,i)];
%     compo_3=[compo_3,X_Acc_DNGD(:,3,i)];
% end
% agent={'智能体1','智能体2','智能体3'};
% component={compo_1,compo_2,compo_3};
% title1={'(a)智能体状态随迭代次数的变化','(b)智能体状态随迭代次数的变化','(c)智能体状态随迭代次数的变化'};
% for i=1:3
% % subplot(1,3,i)
% figure(i)
% p1=plot(component{i}(1,:),'r-');
% grid on
% hold on
% p2=plot(component{i}(2,:),'g:.');
% p3=plot(component{i}(3,:),'bo-','MarkerFaceColor','b','MarkerSize',3);
% xlabel('迭代次数')
% ylabel(['迭代解向量第',num2str(i),'分量'])
% title(title1{i})
% legend([p1,p2,p3],agent{1},agent{2},agent{3})
% daspect([40,0.8,1])
% ylim([0,3.5]);
% % axis square
% box on
% end
% % 画出g(xi)-g的三张图
% res1=[];
% res2=[];
% res3=[];
% for i = 1:60
%     res_temp=f1(X_Acc_DNGD(1,1,i),X_Acc_DNGD(1,2,i),X_Acc_DNGD(1,3,i))+f2(X_Acc_DNGD(1,1,i),X_Acc_DNGD(1,2,i),X_Acc_DNGD(1,3,i))+f3(X_Acc_DNGD(1,1,i),X_Acc_DNGD(1,2,i),X_Acc_DNGD(1,3,i));
%     res1=[res1,res_temp];
% end
% for i = 1:60
%     res_temp=f1(X_Acc_DNGD(2,1,i),X_Acc_DNGD(2,2,i),X_Acc_DNGD(2,3,i))+f2(X_Acc_DNGD(2,1,i),X_Acc_DNGD(2,2,i),X_Acc_DNGD(2,3,i))+f3(X_Acc_DNGD(2,1,i),X_Acc_DNGD(2,2,i),X_Acc_DNGD(2,3,i));
%     res2=[res2,res_temp];
% end
% for i = 1:60
%     res_temp=f1(X_Acc_DNGD(3,1,i),X_Acc_DNGD(3,2,i),X_Acc_DNGD(3,3,i))+f2(X_Acc_DNGD(3,1,i),X_Acc_DNGD(3,2,i),X_Acc_DNGD(3,3,i))+f3(X_Acc_DNGD(3,1,i),X_Acc_DNGD(3,2,i),X_Acc_DNGD(3,3,i));
%     res3=[res3,res_temp];
% end
% res1=res1-fval;
% res2=res2-fval;
% res3=res3-fval;
% figure(4)
% pl1=semilogy(res1,'r--');
% hold on
% pl2=semilogy(res2,'k-o');
% pl3=semilogy(res3,'b-*');
% xlabel('迭代次数')
% ylabel('$$ g(x_i)-g(x^*) $$','Interpreter','latex')
% title('分布式加速Nesterov算法')
% legend([pl1 pl2 pl3],agent{1},agent{2},agent{3})
% box on

% %% 分布式网络牛顿法
% [err1_NNK,err2_NNK,X_NNK,k_NNK]=distributed_N_NK(f1,f2,f3,alpha(6),beta);
% % f1=@(x,y,z)2*(x-3).^2+3*(y-2).^2+2*(z-1).^2;
% % f2=@(x,y,z)2*(x-3).^2+4*(y-2).^2+3*(z-1).^2;
% % f3=@(x,y,z)3*(x-3).^2+3*(y-2).^2+7*(z-1).^2;
% % 画一致性与最优性
% compo_1=[X_NNK(1,:);X_NNK(4,:);X_NNK(7,:)];
% compo_2=[X_NNK(2,:);X_NNK(5,:);X_NNK(8,:)];
% compo_3=[X_NNK(3,:);X_NNK(6,:);X_NNK(9,:)];
% 
% agent={'智能体1','智能体2','智能体3'};
% component={compo_1,compo_2,compo_3};
% title1={'(a)智能体状态随迭代次数的变化','(b)智能体状态随迭代次数的变化','(c)智能体状态随迭代次数的变化'};
% for i=1:3
% % subplot(1,3,i)
% figure(i)
% p1=plot(component{i}(1,:),'r-');
% grid on
% hold on
% p2=plot(component{i}(2,:),'g:.');
% p3=plot(component{i}(3,:),'bo-','MarkerFaceColor','b','MarkerSize',3);
% xlabel('迭代次数')
% ylabel(['迭代解向量第',num2str(i),'分量'])
% title(title1{i})
% legend([p1,p2,p3],agent{1},agent{2},agent{3})
% daspect([40,0.8,1])
% % axis square
% box on
% end
% % 画出g(xi)-g的三张图
% res1=[];
% res2=[];
% res3=[];
% for i = 1:40
%     res_temp=f1(X_NNK(1,i),X_NNK(2,i),X_NNK(3,i))+f2(X_NNK(1,i),X_NNK(2,i),X_NNK(3,i))+f3(X_NNK(1,i),X_NNK(2,i),X_NNK(3,i));
%     res1=[res1,res_temp];
% end
% for i = 1:40
%     res_temp=f1(X_NNK(4,i),X_NNK(5,i),X_NNK(6,i))+f2(X_NNK(4,i),X_NNK(5,i),X_NNK(6,i))+f3(X_NNK(4,i),X_NNK(5,i),X_NNK(6,i));
%     res2=[res2,res_temp];
% end
% for i = 1:40
%     res_temp=f1(X_NNK(7,i),X_NNK(8,i),X_NNK(9,i))+f2(X_NNK(7,i),X_NNK(8,i),X_NNK(9,i))+f3(X_NNK(7,i),X_NNK(8,i),X_NNK(9,i));
%     res3=[res3,res_temp];
% end
% % res1=res1-fval;
% % res2=res2-fval;
% % res3=res3-fval;
% figure(4)
% pl1=semilogy(res1,'r--');
% hold on
% pl2=semilogy(res2,'k-o');
% pl3=semilogy(res3,'b-*');
% xlabel('迭代次数')
% ylabel('$$ g(x_i)-g(x^*) $$','Interpreter','latex')
% title('分布式网络牛顿法')
% legend([pl1 pl2 pl3],agent{1},agent{2},agent{3})
% box on







% err1={err1_DGD,err1_Extra,err1_DIG,err1_D_NC,err1_Acc_DNGD,err1_NNK};
% err2={err2_DGD,err2_Extra,err2_DIG,err2_D_NC,err2_Acc_DNGD,err2_NNK};
% n_title={'DGD Algorithm','Extra Algorithm','DIGing Algorithm','D-NC Algorithm','Acc-DNGD Algorithm','D-NNK Algorithm'};
% n_legends={'error-1','error-2'};
% for i=1:6
%     subplot(2,3,i)
%     grid on
%     p1=plot(log10(err1{1,i}),'-.');
%     hold on
%     p2=plot(log10(err2{1,i}),'-');
%     legend([p1,p2],n_legends{1},n_legends{2})
%     title(n_title{1,i})
%     xlabel('迭代次数')
%     ylabel('log(error)')
% end









