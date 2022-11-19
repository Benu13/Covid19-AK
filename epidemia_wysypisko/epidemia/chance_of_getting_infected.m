function [chance] = chance_of_getting_infected(neighborhood,i,j)
    global chances; 
    global time_in_current_state;   
    global dim;
    global reform_times_and_efficiency;
    global reform;
    %neighborhood = [1 3 5; 1 2 3; 3 6 7];
    chance = chances(neighborhood(2,2),2);
    is_somebody_to_infect_from = 0;
    for k = 1:3
        for l = 1:3
            if neighborhood(k,l) == 3 || neighborhood(k,l) == 5 || neighborhood(k,l) == 6
                is_somebody_to_infect_from = 1;
            end
            if (neighborhood(k,l) == 2)
                if (i ~= 1 && j ~= 1 && i ~= dim && j ~= dim)
                   if time_in_current_state(i-2+k,j-2+l,2) == 3 || time_in_current_state(i-2+k,j-2+l,2) == 5 || time_in_current_state(i-2+k,j-2+l,2) == 6
                       is_somebody_to_infect_from = 1;
                   end
                end
            end
            switch neighborhood(k,l)
                case 1
                    q1 = randi(4);
                    if q1 == 2
                        q1 = 5;
                    end
                case 2
                    q1 = 0;
                case 3
                    q1 = 2;
                case 4
                    q1 = 3;
                case 5
                    q1 = 2;
                case 6
                    q1 = 2;
                case 7
                    q1 = randi([3,5]);
                    if q1 == 3
                        q1 = 1;
                    end
                case 8 
                    q1 = 0;
            end
            if ~(k==2 && l==2)
                [~, neigh_others, less_by] = add_modifiers(neighborhood(k,l),0,0,q1);
                chance = chance + neigh_others - less_by;
            else 
                [chance, ~, ~] = add_modifiers(neighborhood(2,2),chance,0,q1);
            end
        end
    end
    chance = chance - reform_times_and_efficiency(2,reform);
    if is_somebody_to_infect_from == 0
        chance = 0;
    end
    if chance < 0
        chance = 0;
    end
end