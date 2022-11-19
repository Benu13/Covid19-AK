function [up_pop_str] = eu4_time(pop_struct,x,y,x_neig,y_neig,n_t)
%UNTILTED8 Summary of this function goes not here
%   Detailed explanation goes home

% CONST
weak_chance_sf = 0.35; %chance for sick people to go self protecting
strong_chance_sf = 0.1; %chance for healthy people to go self protecting
mary_sue = 0.0001; %chance for sick people to go mad
strong_chance_po = 0.03; %chance for healthy people to protect others
org_prot_chance = 0.00001; %useless


pop = pop_struct;
pop2 = pop_struct(:,:,1);
len = length(pop);


% THERE'S NO CURE FOR OLD AGE
% YET

% for i = 1:length(x')
%     rand_temp = rand(1);
%     if rand_temp < pop(x(i),y(i)).sick_recover_chance
%         if pop(x(i),y(i)).state == 7
%             pop(x(i),y(i)).state = 1;
%         else
%             pop(x(i),y(i)).was_sick = 0;
%         end
%     end
% end


xx = [x_neig];
yy = [y_neig];
x_w = [];
y_w = [];
x_s = [];
y_s = [];

for i=1:length(xx')
    if pop(xx(i),yy(i),1) == 7
        x_w = [x_w; xx(i)];
        y_w = [y_w; yy(i)];
    end
    if pop(xx(i),yy(i),1) == 1
        x_s = [x_s; xx(i)];
        y_s = [y_s; yy(i)];
    end
end


% EACH MAN FOR HIMSELF
for i = 1:length(x_w')
    temp_rand = rand(1);
    if temp_rand < weak_chance_sf
         pop(x_w(i),y_w(i),7)= 1;
    end
    temp_rand = rand(1);
    if temp_rand < mary_sue
         pop(x_w(i),y_w(i),9) = 1;
         [x_ne,y_ne] = get_neighbours(n_t,pop2,x_w(i),y_w(i));
         for j = 1:length(x_ne')
             pop(x_ne(j),y_ne(j),12) = 1;
             pop(x_w(j),y_w(j),7) = 0;
         end
    end
    temp_rand = rand(1);
    if temp_rand < org_prot_chance && ~pop(x_w(i),y_w(i)).protected_by_others
         [x_ne,y_ne] = get_neighbours(n_t,pop,x_w(i),y_w(i));
         [x_ne,y_ne] = get_neighbours(n_t,pop,x_ne,y_ne);
         for j = 1:length(x_ne')
             pop(x_ne(j),y_ne(j)).protected_by_others = 1;
             pop(x_ne(j),y_ne(j)).self_protecting = 1;
             pop(x_ne(j),y_ne(j)).prot_by_org = 1;
         end
    end
end


for i = 1:length(x_s')
    temp_rand = rand(1);
    if temp_rand < strong_chance_sf
         pop(x_s(i),y_s(i),7) = 1;
    end
    temp_rand = rand(1);
    if (temp_rand < strong_chance_po && pop(x_s(i),y_s(i),1) == 1 ...
        || pop(x_s(i),y_s(i),1) == 5 )
        pop(x_s(i),y_s(i),9) = 1;
        pop(x_s(i),y_s(i),7) = 0;
        [x_ne,y_ne] = get_neighbours(n_t,pop2,x_s(i),y_s(i));
            for j = 1:length(x_ne')
                pop(x_ne(j),y_ne(j),12) = 1;
            end
    end
    temp_rand = rand(1);
    if temp_rand < org_prot_chance && ~pop(x_s(i),y_s(i)).protected_by_others
         [x_ne,y_ne] = get_neighbours(n_t,pop,x_s(i),y_s(i));
         [x_ne,y_ne] = get_neighbours(n_t,pop,x_ne,y_ne);
         for j = 1:length(x_ne')
             pop(x_ne(j),y_ne(j)).protected_by_others = 1;
             pop(x_ne(j),y_ne(j)).self_protecting = 1;
             pop(x_ne(j),y_ne(j)).prot_by_org = 1;
         end
    end
end


up_pop_str = pop;
end


