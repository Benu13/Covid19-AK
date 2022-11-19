function pop = spawn_infected(len,pop_struct,num)
%SPAWN_INFECTED Summary of this function goes here
%   Detailed explanation goes here

pop_s = pop_struct;
for i =1:num
    X = randi(len);
    Y = randi(len);
    pop_s(X,Y,1)= 3;
end

pop = pop_s;

end

