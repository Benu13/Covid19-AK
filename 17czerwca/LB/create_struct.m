function [pop_struct] = create_struct(person,siz_e,sic_ch)
%CREATE_STRUCT Summary of this function goes here
%   Detailed explanation goes here
per(1,1,1)=person.state;
per(1,1,2)=person.get_inf_ch;
per(1,1,3)=person.quarantine_chance;
per(1,1,4)=person.death_chance;
per(1,1,5)=person.time_since_infected;
per(1,1,6)=person.go_to_hosp_chance;
per(1,1,7)=person.self_protecting;
per(1,1,8)=person.prot_by_org;
per(1,1,9)=person.protectiong_others;
per(1,1,10)=person.organizing_protection;
per(1,1,11)=person.was_sick;
per(1,1,12)=person.protected_by_others;
per(1,1,13)=person.days_in_quarantine;

pop = zeros(siz_e,siz_e,13);

for i = 1:siz_e
    for j = 1:siz_e
        pop(i,j,:) = per;
        r_temp = rand(1);
        if(r_temp)<sic_ch
            pop(i,j,1) = 7;
        end
    end
end

pop_struct = pop;
end

