function per_o = calc_inf_chance(per,gov_cont,med_inf,t_num,panic,density,gov_inp,soc_addapt,base_vir,discipl)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
p = per;
g= gov_cont;
m = med_inf;
gov_i = gov_inp/5;
sa = soc_addapt;
if soc_addapt < g*0.8
    inf_chance = ((1.187/(4+((gov_i*(g)*(soc_addapt)/4)^(2.39))+1/(5+m^(1.2))))/(1+p(7)*base_vir-((1-p(8))*p(9)*0.2))-t_num/30)*(1+panic/100+density/(100+discipl));
else
    inf_chance = ((1.211/(4+((gov_i*(g)*soc_addapt/4)^(1.897))+1/(5+m^(1.2))))/(1+p(7)*base_vir-((1-p(8))*p(9)*0.2))-t_num/30)*(1+panic/100+density/(100+discipl));
    %inf_chance = ((1.8/(4+(gov_i/2*(sa)^(3.4))+1/(5+m^(1.2))))/(1+p(7)*base_vir-((1-p(8))*p(9)*0.2))-t_num/30)*(1+panic/100+density/(100+discipl));
end
per_o = inf_chance;
end

