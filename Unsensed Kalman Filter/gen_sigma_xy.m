function sigma_xy=gen_sigma_xy(x_temp,mean_x,y_temp,mean_y,w)
n=size(x_temp,1);
sigma_xy=0;
for i =1:2*n+1
    sigma_xy=sigma_xy+w(i)*(x_temp(:,i)-mean_x)*(y_temp(:,i)-mean_y)';
end
end