function [gov_control,inf_camp_lvl,panic_lvl] = assert_reforms(gr,mr,day,pan_lvl)
%ASSERT_REFORMS Summary of this function goes here
%   Detailed explanation goes here
g = gr;
m = mr;
panic = pan_lvl;

if day == 11+2
    g = 2;
    m = 2;
end
if day == 18+2
    g = 3;
end
if day == 21+2
    g = 4;
end
if day == 25+2
    g = 5;
end

if day>11
    panic = 100;
    panic = (panic-10*(day-11));
    if panic < 10
         panic = 10;
    end
else
    panic = 10;
end

panic_lvl =panic;
inf_camp_lvl =m;
gov_control = g;
end

