function [pop_struct_out,omm,nmm] = Moirai_thread(pop_struct,x_inf,y_inf,no_symp,inc_t,rec_t)
%MOIRAI_TRIAL Summary of this function goes here
%   Detailed explanation goes here

%CONSTS
incubation_time = 1.5*inc_t;
recovery_time = rec_t*2;
ommm = 0;
nummm = 0;

pop_struct_s = pop_struct;

for i = 1:length(x_inf') 
    pop_struct_s(x_inf(i),y_inf(i),5) = pop_struct_s(x_inf(i),y_inf(i),5) + 1;
    if (pop_struct_s(x_inf(i),y_inf(i),5) >= 2 && ...
            pop_struct_s(x_inf(i),y_inf(i),1) == 3)    
        if rand(2) < pop_struct_s(x_inf(i),y_inf(i),5)/(incubation_time)
            if (rand(1) < no_symp && pop_struct_s(x_inf(i),y_inf(i),11) == 0)
                pop_struct_s(x_inf(i),y_inf(i),1) = 10;
                pop_struct_s(x_inf(i),y_inf(i),5) = 1;
            else
                pop_struct_s(x_inf(i),y_inf(i),1) = 8;               
                pop_struct_s(x_inf(i),y_inf(i),5) = 1;
            end
        end
    end
    if pop_struct_s(x_inf(i),y_inf(i),1) ~= 3
        %self quarantine
        if rand(1) < pop_struct_s(x_inf(i),y_inf(i),3) && pop_struct_s(x_inf(i),y_inf(i),1) ~= 9 && pop_struct_s(x_inf(i),y_inf(i),1) ~= 4 
            pop_struct_s(x_inf(i),y_inf(i),1) = 9;
        end

        if (pop_struct_s(x_inf(i),y_inf(i),1) == 8 || pop_struct_s(x_inf(i),y_inf(i),1) == 9|| pop_struct_s(x_inf(i),y_inf(i),1) == 10)
            rand_temp = rand(1); %hospital
            if rand_temp < pop_struct_s(x_inf(i),y_inf(i),6)
                pop_struct_s(x_inf(i),y_inf(i),1) = 4;
            end
        end
        if (pop_struct_s(x_inf(i),y_inf(i),1) == 8||pop_struct_s(x_inf(i),y_inf(i),1) == 4|| pop_struct_s(x_inf(i),y_inf(i),1) == 9 ...
     || pop_struct_s(x_inf(i),y_inf(i),1) == 10)
            rand_temp = rand(2);
            calc_prob = pop_struct_s(x_inf(i),y_inf(i),5)/(recovery_time*(1+pop_struct_s(x_inf(i),y_inf(i),11)/2));
            if rand_temp < calc_prob 
                rand_temp = rand(1);
                nummm = nummm+1;
                ommm = ommm+pop_struct_s(x_inf(i),y_inf(i),5);
                if (rand_temp < pop_struct_s(x_inf(i),y_inf(i),4))
                    pop_struct_s(x_inf(i),y_inf(i),1) = 6;
                else 
                    pop_struct_s(x_inf(i),y_inf(i),1) = 5; 
                end
            end
        end
    end
end

omm = ommm;
nmm = nummm;
pop_struct_out = pop_struct_s;
end

 