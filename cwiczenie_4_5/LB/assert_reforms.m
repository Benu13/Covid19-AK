function [gov_control,inf_camp_lvl,panic_lvl,sc_adapt] = assert_reforms(gr,mr,day,pan_lvl,ref_day, inf_day,disc,sa)
%ASSERT_REFORMS Summary of this function goes here
%   Detailed explanation goes here
g = gr;
g_ol = g;
m = mr;
panic = pan_lvl;
max_addapt = 5;

if ismember(day,ref_day)
    g = g+1;
end
if ismember(day,inf_day)
    m = m+1;
end

if g==2 && g_ol == 1
    panic = 100-disc;
else
    panic = (panic-disc/30);
end
if panic < 1
         panic = 1;
end
s = sa + disc/950;
sc_adapt = min([max_addapt, s]);

panic_lvl =panic;
inf_camp_lvl =m;
gov_control = g;
end

