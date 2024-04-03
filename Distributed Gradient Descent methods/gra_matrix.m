function result=gra_matrix(gra_1,gra_2,gra_3,x)
result=zeros(3);
result(1,:)=gra_1(x(1,1),x(1,2),x(1,3));
result(2,:)=gra_2(x(2,1),x(2,2),x(2,3));
result(3,:)=gra_3(x(3,1),x(3,2),x(3,3));
end

