function [chance_self, chance_others, less_by] = add_modifiers(state,chance_self,chance_others,q1)
    % 1 - no_security_measures
    % 2 - infecting
    % 3 - self_protecting
    % 4 - protecting_other
    % 5 - organizing_protection
    less_by = 0;
    switch q1
        case 1
            switch state
                case 1
                    chance_self = chance_self + 0.02;
                case 3
                    chance_others = chance_others + 0.1;
                case 4
                    chance_self = chance_self + 0.02;  
            end
        case 2
            chance_others = chance_others + 0.005;
        case 3
            chance_self = chance_self - 0.01;
            chance_others = chance_others - 0.01;
        case 4
            chance_self = chance_self + 0.01;
            chance_others = chance_others + 0.01;
            less_by = less_by + 0.01;
        case 5
            less_by = less_by + 0.01;
    end
end
