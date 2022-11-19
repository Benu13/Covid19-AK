function pop = calc_hosp_chance(per,gov_cont,med_inf)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
p = per;
g= gov_cont;
m = med_inf;
hosp_chance = 0;
if p(1) == 8
    hosp_chance = 1/(200-2*(p(5)+4*m+1.5*g)) + 2*p(4);
end
if p(11) == 1 || p(1) == 9
    hosp_chance = hosp_chance*2;
end
if p(1) == 10
    hosp_chance = (1/(200-2*(p(5)+4*m+1.5*g)) + 2*p(4))*0.25;
end
pop = hosp_chance;
end

