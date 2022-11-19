function per_o = calc_inf_chance(per,gov_cont,med_inf,t_num)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
p = per;
g= gov_cont;
m = med_inf;

inf_chance = (5/(4+(g)^(2.2)+1/(5+m^(1.4))))/(1+p(7)*0.25-((1-p(8))*p(9)*0.5))-t_num/10;
if g == 5
    inf_chance =(5/(4+(g)^(2.4)+1/(5+m^(1.4))))/(1+p(7)*0.25-((1-p(8))*p(9)*0.5))-t_num/10;
end

per_o = inf_chance;
end

