function per_o = calc_quar_chance(per,gov_cont,med_inf)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
p = per;
g = gov_cont;
m = med_inf;
quar_chance =0;

if p(1) == 1 || p(1) == 3 || p(1) == 10
    quar_chance = (m^(2)/(40))*0.05;
end
if p(1) == 7 
    quar_chance = (m^(2)/(10))*0.2;
end
if p(1) == 8
    quar_chance = (m^(2)/10)*0.1;
end

per_o = quar_chance;

end

