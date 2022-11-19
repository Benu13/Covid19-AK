function [output1] = state_change(neighborhood,i,j)
    % output1 - what is next state?
    % przejscia miedzy stanami sa zgodne utworzonym we wstepie grafem
    global prob;
    global time_in_current_state;    
    state = neighborhood(2,2);
    n = rand;
    switch state
        % 1 - healty
        % 2 - in_quarantine
        % 3 - infected
        % 4 - sick
        % 5 - infected_and_sick
        % 6 - in_hospital
        % 7 - recovered
        % 8 - dead
        case 8
            output = 8;
        case 7
            output = 7;
        case 6
            % mozliwe przejscia -> 7,8
            prob_L = prob.L*(-0.5 + 2.5*time_in_current_state(i,j,1)/50);
            if n <= prob_L 
                output = 8;
            elseif n <= prob_L + prob.T * (-1 + 2*time_in_current_state(i,j,1)/50)    
                output = 7;
            else 
                output = 6;
            end
        case 5
            % mozliwe przejscia 2,6,7,8
            if n <= prob.S
                output = 8;
            elseif n <= prob.S + prob.R
                output = 2;
            elseif n <= prob.S + prob.R + prob.H
                output = 7;
            elseif n <= prob.S + prob.R + prob.H + prob.M
                output = 6;
            else 
                output = 5;
            end
        case 4           
            % mozliwe przejscia -> 1,2,5
            chance_of_getting_infection = chance_of_getting_infected(neighborhood,i,j);
            if n <= chance_of_getting_infection
                output = 3;
            elseif n <= chance_of_getting_infection + prob.B
                output = 2;
            elseif n <= chance_of_getting_infection + prob.B + prob.P
                output = 1;
            else
                output = 4;
            end            
            
        case 3 
            % mozliwe przejscia -> 2,5
            if n <= prob.G
                output = 2;
            elseif n <= prob.G + prob.E
                output = 5;
            else
                output = 3;
            end
        case 2 
            % mozliwe przejscia -> 1,4,6,8,3
            if n <= prob.K
                output = 8;
            elseif n <= prob.K + prob.O
                output = 4;
            elseif n <= prob.K + prob.O + prob.J
                output = 6;
            elseif n <= prob.K + prob.O + prob.J + prob.N
                if time_in_current_state(i,j,2) == 3 || time_in_current_state(i,j,2) == 6 || time_in_current_state(i,j,2) == 5
                    output = 3;
                else
                    output = 1;
                end
            else
                output = 2;
            end
        case 1
            % mozliwe przejscia -> 2,3,4
            chance_of_getting_infection = chance_of_getting_infected(neighborhood,i,j);
            is_not_zero = 0;
            if chance_of_getting_infection ~= 0
                is_not_zero = 1;
            end
            if n <=  chance_of_getting_infection
                output = 3;
            elseif n <=  chance_of_getting_infection + prob.F
                output = 2;
            elseif n <=  chance_of_getting_infection + prob.F + prob.A
                output = 4;
            else
%                 if is_not_zero == 1 && rand <= 0.9
%                     output = 2;
%                 else
                    output = 1;
%                 end
            end 
    end

%         case 1 
%             % mozliwe przejscia -> 2,3,4
%             chance_of_getting_infection = chance_of_getting_infected(neighborhood,i,j);
%             if n <=  chance_of_getting_infection
%                 output = 1;
%             elseif n <=  chance_of_getting_infection + prob.F
%                 output = 2;
%             elseif n <=  chance_of_getting_infection + prob.F + prob.A
%                 output = 4;
%             else
%                 output = 1;
%             end  
%         case 2
%             % mozliwe przejscia -> 1,4,6,8,3
%             if n <= prob.K
%                 output = 8;
%             elseif n <= prob.K + prob.O
%                 output = 4;
%             elseif n <= prob.K + prob.O + prob.J
%                 output = 6;
%             elseif n <= prob.K + prob.O + prob.J + prob.N
%                 if time_in_current_state(i,j,2) == (3 || 6 || 5)
%                     output = 1;
%                 else
%                     output = 1;
%                 end
%             else
%                 output = 2;
%             end
%         case 3
%             % mozliwe przejscia -> 2,5
%             if n <= prob.G
%                 output = 2;
%             elseif n <= prob.G + prob.E
%                 output = 5;
%             else
%                 output = 3;
%             end
%         case 4
%             % mozliwe przejscia -> 1,2,5
%             chance_of_getting_infection = chance_of_getting_infected(neighborhood,i,j);
%             if n <= chance_of_getting_infection
%                 output = 1;
%             elseif n <= chance_of_getting_infection + prob.B
%                 output = 2;
%             elseif n <= chance_of_getting_infection + prob.B + prob.P
%                 output = 1;
%             else
%                 output = 4;
%             end
%         case 5
%             % mozliwe przejscia 2,6,7,8
%             if n <= prob.S
%                 output = 8;
%             elseif n <= prob.S + prob.R
%                 output = 2;
%             elseif n <= prob.S + prob.R + prob.H
%                 output = 7;
%             elseif n <= prob.S + prob.R + prob.H + prob.M
%                 output = 6;
%             else 
%                 output = 5;
%             end
%         case 6
%             % mozliwe przejscia -> 7,8
%             prob_L = prob.L*(-0.5 + 2*time_in_current_state(i,j,1)/50);
%             if n <= prob_L 
%                 output = 8;
%             elseif n <= prob_L + prob.T * (-1 + 2*time_in_current_state(i,j,1)/50)    
%                 output = 7;
%             else 
%                 output = 6;
%             end
%         case 7  
%             % mozliwe przejscia -> 7 (recovered jest recovered do konca)
%             output = 7;
%         case 8
%             % mozliwe przejscia -> 8 (na z martwych nie wstanie)
%             output = 8;
%     end
    if(output == state)
        time_in_current_state(i,j,1) = time_in_current_state(i,j) + 1;
    else
        time_in_current_state(i,j,1) = 0;
        time_in_current_state(i,j,2) = state;
    end
        
    output1 = output;
end
