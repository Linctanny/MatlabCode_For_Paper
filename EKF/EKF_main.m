% EKF算法实例的主函数main.m
randn('seed',15);
N=48;
x_00=[1;1;1;1];
P_00=eye(4);
w_mean=[0,0];
w_var=1e-5.*eye(2);
v_mean=0;
v_var=5;
[p1,p3]=EKF(N,x_00,P_00,w_mean,w_var,v_mean,v_var);