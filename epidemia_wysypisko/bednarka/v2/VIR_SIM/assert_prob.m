function pop_out = assert_prob(pop_struct,x,y,x_neig,y_neig,gov_c,med_i,medi_lvl)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
pop = pop_struct;
gov_cont = gov_c;
med_inf =med_i;
x_n = x_neig;
y_n = y_neig;
x_i = x;
y_i = y;
c_med_lvl = medi_lvl;


for i =1:length(x_n')
    pop(x_n(i),y_n(i),2) = calc_inf_chance(pop(x_n(i),y_n(i),:),gov_cont,med_inf); %chance to get infected
    pop(x_n(i),y_n(i),3) = calc_quar_chance(pop(x_n(i),y_n(i),:),gov_cont,med_inf); %quarantine chance
end
for i = 1:length(x_i')
    pop(x_i(i),y_i(i),6) = calc_hosp_chance(pop(x_i(i),y_i(i),:),gov_cont,med_inf);% hospitalization chance
    pop(x_i(i),y_i(i),4) = calc_deatch_chance(pop(x_i(i),y_i(i),:),c_med_lvl);
end

 
pop_out = pop;