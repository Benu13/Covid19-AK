function [x_ind,y_ind] = get_neighbours(mode,pop_struct,x_inf,y_inf)
%GET_NE Summary of this function goes here
%   Detailed explanation goes here
pop_mat = pop_struct;

M = zeros(size(pop_mat));
for i=1:1:numel(x_inf)
    M(x_inf(i),y_inf(i))=1;
end
if(mode == 1) % Moore
    C = conv2(M,[1,1,1;1,0,1;1,1,1],'same')>0;
end
if(mode==2) %Neumann
    C = conv2(M,[0,1,0;1,0,1;0,1,0],'same')>0;
end

for i=1:1:numel(x_inf)
    C(x_inf(i),y_inf(i))=0;
end

[x,y] = find(C == 1);

x_ind = x;
y_ind = y;

end

