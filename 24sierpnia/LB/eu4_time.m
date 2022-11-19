function [up_pop_str] = eu4_time(pop_struct,x_neig,y_neig,n_t,med_inf,panic_lvl)
%UNTILTED8 Summary of this function goes not here
%   Detailed explanation goes home

% CONST
org_prot_chance = 0.01; %...
[weak_chance_sf, strong_chance_sf] = calc_sf_chance(med_inf);
[mary_sue, strong_chance_po] = calc_po_chance(med_inf,panic_lvl);
pop = pop_struct;
pop2 = pop_struct(:,:,1);

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
             pop(x_w(i),y_w(i),7) = 0;
         end
    end
    temp_rand = rand(1);
    if temp_rand < org_prot_chance && ~pop(x_w(i),y_w(i),12)
         [x_ne,y_ne] = get_neighbours(n_t,pop2,x_w(i),y_w(i));
         [x_ne,y_ne] = get_neighbours(n_t,pop2,x_ne,y_ne);
         for j = 1:length(x_ne')
             pop(x_ne(j),y_ne(j),9) = 1;
             pop(x_ne(j),y_ne(j),7)= 1;
             pop(x_ne(j),y_ne(j),8) = 1;
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
                pop(x_s(i),y_s(i),7) = 0;
            end
    end
    temp_rand = rand(1);
    if temp_rand < org_prot_chance && ~pop(x_s(i),y_s(i),12)
         [x_ne,y_ne] = get_neighbours(n_t,pop2,x_s(i),y_s(i));
         [x_ne,y_ne] = get_neighbours(n_t,pop2,x_ne,y_ne);
         for j = 1:length(x_ne')
             pop(x_ne(j),y_ne(j),12) = 1;
             pop(x_ne(j),y_ne(j),7) = 1;
             pop(x_ne(j),y_ne(j),8) = 1;
         end
    end
end


up_pop_str = pop;
end


