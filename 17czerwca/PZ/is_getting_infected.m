function [output] = state_change(state, global_modifier, neighborhood)
    switch state
        % 1 - healty
        % 2 - in_quarantine
        % 3 - infected
        % 4 - sick
        % 5 - infected_and_sick
        % 6 - in_hospital
        % 7 - recovered
        % 8 - dead
        case 1 
            % mozliwe przejscia -> 2,3,4
            chance_of_getting_sick = A;
            chance_of_getting_infected = chances(1,2);
            for k = 1:3
                for l = 1:3
                    if ~(k==2 && l==2)
                        switch neighborhood
                            case 1
                                chance_of_getting_infected 
                        end
                    end
                end
            end
            chance_of_getting_infected = 
            chance_of_going_quarantine = 0.002;
            

    end
end
