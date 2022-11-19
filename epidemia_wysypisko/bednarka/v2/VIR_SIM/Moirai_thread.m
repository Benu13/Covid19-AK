function [pop_struct_out,omm,nmm] = Moirai_thread(pop_struct,x_inf,y_inf)
%MOIRAI_TRIAL Summary of this function goes here
%   Detailed explanation goes here

%CONSTS
incubation_time = 18;
recovery_time = 28*2;
recovery_time_weak = 35*2; %not implemented
ommm = 0;
nummm = 0;

pop_struct_s = pop_struct;

for i = 1:length(x_inf') 
    pop_struct_s(x_inf(i),y_inf(i),5) = pop_struct_s(x_inf(i),y_inf(i),5) + 1;
    if pop_struct_s(x_inf(i),y_inf(i),5) >= 2 && ...
            pop_struct_s(x_inf(i),y_inf(i),1) ~= 8 && pop_struct_s(x_inf(i),y_inf(i),1) ~= 4     
        rand_temp = rand(1);
        if rand_temp < pop_struct_s(x_inf(i),y_inf(i),5)/(incubation_time)
            pop_struct_s(x_inf(i),y_inf(i),1) = 8;
            nummm = nummm+1;
            ommm = ommm+pop_struct_s(x_inf(i),y_inf(i),5);
            pop_struct_s(x_inf(i),y_inf(i),5) = 1;
        end
    end
    rand_temp = rand(1); %self quarantine
    if rand_temp < pop_struct_s(x_inf(i),y_inf(i),3) && pop_struct_s(x_inf(i),y_inf(i),1) ~= 2 && pop_struct_s(x_inf(i),y_inf(i),1) ~= 4
        pop_struct_s(x_inf(i),y_inf(i),1) = 2;
    end
    
    if pop_struct_s(x_inf(i),y_inf(i),1) == 8
    temp_val = pop_struct_s(x_inf(i),y_inf(i),6);
        pop_struct_s(x_inf(i),y_inf(i),6) = pop_struct_s(x_inf(i),y_inf(i),6) ...
            + (1-temp_val)/(32 - pop_struct_s(x_inf(i),y_inf(i),5));
        
        rand_temp = rand(1); %hospital
        if rand_temp < pop_struct_s(x_inf(i),y_inf(i),6) && pop_struct_s(x_inf(i),y_inf(i),1) ~= 4
            pop_struct_s(x_inf(i),y_inf(i),1) = 4;
        end
    end
    if (pop_struct_s(x_inf(i),y_inf(i),1) == 8||pop_struct_s(x_inf(i),y_inf(i),1) == 4)
        rand_temp = rand(1);
        calc_prob = 1/(recovery_time*1.7-pop_struct_s(x_inf(i),y_inf(i),5));
        if rand_temp < calc_prob %LAST JUDGMENT
            rand_temp = rand(1);
            if rand_temp < pop_struct_s(x_inf(i),y_inf(i),4) 
                pop_struct_s(x_inf(i),y_inf(i),1) = 6;
            else 
                pop_struct_s(x_inf(i),y_inf(i),1) = 5; 
            end
        end
    end
end

omm = ommm;
nmm = nummm;
pop_struct_out = pop_struct_s;
end

 