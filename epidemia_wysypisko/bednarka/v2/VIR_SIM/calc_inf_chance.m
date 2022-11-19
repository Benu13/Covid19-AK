function per_o = calc_inf_chance(per,gov_cont,med_inf)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
p = per;
g= gov_cont;
m = med_inf;

inf_chance = (5/(4+(g)^(2.5+1/(10-g))+1/(5+m^(1.2))))/(1+p(7)*0.25-((1-p(8))*p(9)*0.5));

per_o = inf_chance;
end

