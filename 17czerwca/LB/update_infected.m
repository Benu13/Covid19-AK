function [pop_infect_update,quar_xx,quar_yy] = update_infected(pop_struct,x_neig,y_neig,x_q,y_q)
%GET_INFECTED Summary of this function goes here
%   Detailed explanation goes here

pop_struct_s = pop_struct;
quar_x = [];
quar_y = [];



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
    rand_temp = rand(1);
    if (rand_temp < pop_struct_s(x_neig(i),y_neig(i),3) && pop_struct_s(x_neig(i),y_neig(i),1) ~= 2)
        pop_struct_s(x_neig(i),y_neig(i),1)= 2;
        if pop_struct_s(x_neig(i),y_neig(i),1)== 7
            pop_struct_s(x_neig(i),y_neig(i),11) = 1;
        end
        quar_x = [quar_x; x_neig(i)];
        quar_y = [quar_y; x_neig(i)]; 
    end
end


for i = 1:length(x_q')
    if rand(i) < 40/pop_struct_s(x_q(i),y_q(i),13)
        if pop_struct_s(x_q(i),y_q(i),11) == 1
            pop_struct_s(x_q(i),y_q(i),1) = 7;
        else
            pop_struct_s(x_q(i),y_q(i),1) = 1;
        end
    end
    pop_struct_s(x_q(i),y_q(i),13) = pop_struct_s(x_q(i),y_q(i),13)+1;
end

quar_xx = quar_x;
quar_yy = quar_y;
pop_infect_update = pop_struct_s;
end

