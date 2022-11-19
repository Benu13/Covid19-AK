function pop = calc_deatch_chance(per,c_med_lvl)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
p = per;
hl = c_med_lvl;

if p(11) == 1
    death_chance = 0.09/hl * 7 + 1/(100-p(5));
end
if p(11) == 0
    death_chance = 0.09/hl+ 1/(300-p(5));
end

if p(1) == 4
    death_chance = death_chance/1.5;
end
pop = death_chance;
end

