function [pop_infect_update] = update_infected(pop_struct,x_neig,y_neig)
%GET_INFECTED Summary of this function goes here
%   Detailed explanation goes here

pop_struct_s = pop_struct;
quar_x = [];
quar_y = [];

% for i = 1:length(x')
%     rand_temp = rand(1);
%     if (rand_temp < pop_struct_s(x(i),y(i),3) && pop_struct_s(x(i),y(i),1) ~= 2)
%         pop_struct_s(x(i),y(i),1)= 2;
%         quar_x = [quar_x x(i)];
%         quar_y = [quar_y y(i)]; 
%     end
% end

for i = 1:length(y_neig')
    rand_temp = rand(1);
    if (rand_temp < pop_struct_s(x_neig(i),y_neig(i),2) && ...
            ismember(pop_struct_s(x_neig(i),y_neig(i),1),[1 7]))
        
        if pop_struct_s(x_neig(i),y_neig(i),1)== 7
            pop_struct_s(x_neig(i),y_neig(i),1) = 3;
            pop_struct_s(x_neig(i),y_neig(i),5) = 1;
            pop_struct_s(x_neig(i),y_neig(i),11) = 1;
       
        else
            pop_struct_s(x_neig(i),y_neig(i),1)= 3;
            pop_struct_s(x_neig(i),y_neig(i),5) = 1;
        end  
    end
end

pop_infect_update = pop_struct_s;
end

