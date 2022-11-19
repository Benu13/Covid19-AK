clear all; close all;
neighborhood_type = 1; %1 - Moore, 2-Neumann
live_plots = 1; %SET ON ONE TO DRAW PLOTS LIVE SET ON ZERO TO ONLY GET STATE MATRIX
random_spawn_when_open_border = 0; %SET ON ONE TO GET RANDOM INFECTED WHEN COUNTRY IS NOT ON LOCKDOWN
border_lockdown = 0; % DAY OF BORDER LOCKDOWN
SIMULATION_TIME = 50;
starting_infected = 4; % Number of infected at the start of simulation
no_symp = 0.25; %percentage of no symptoms cases
%% Country data
population = 10000; 
people_older_than_60 = 0.05; % in %
high_risk = 0.01;% in %
sick = people_older_than_60 + high_risk;
gov_control = 1; %goverment intervention level
inf_camp_lvl = 1; % information campain level
coun_medical_level = 1; %level of country heathcare, 
social_addaptation = 0; %how much society adapted to occurring situation, not implemented

pop_sq = round(sqrt(population));
pop_mat = zeros(round(sqrt(population)));

%% INITIALIZATION 
inf_chance_base = 1;
quar_chance_base = 0;
deatch_chance_base = 0;
prot_chance = 0;
prot_o_chance_base = 0;
org_prot_chance_base = 0;
get_sick_chance = 0;
sick_recover_ch = 0;
go_to_hosp_chance_base = 0;

%TO ADD: SICK AND IN QUARANTAINE
% Person struct 
p.state = 1;
p.get_inf_ch = inf_chance_base; % infection chance
p.quarantine_chance = quar_chance_base;
p.death_chance = deatch_chance_base;
p.time_since_infected = 0; 
%p.org_prot_ch = org_prot_chance_base;
%p.get_sick_chance = get_sick_chance;
%p.sick_recover_chance = sick_recover_ch;
%p.no_sympthoms_chance = 0.25 %not implemented
p.go_to_hosp_chance = go_to_hosp_chance_base;
p.self_protecting = 0;
p.prot_by_org = 0;
p.protectiong_others = 0;
p.organizing_protection = 0;
p.was_sick = 0;
%p.state_before_quarantine = 0;
p.protected_by_others = 0;

% Population array

pop_struct = create_struct(p,pop_sq,sick);
%% Random first sick person
pop_struct = spawn_infected(pop_sq,pop_struct,starting_infected);
%%
summ = 0;
inf_o = 0;
timespan = 1:1:SIMULATION_TIME;
inf_gr_sum = [];
inf_gr_sum2 = [];
inf_gr_sum3 = [];
inf_gr_sum4 = [];
inf_gr_sum5 = [];
inf_gr_sum6 = [];
inf_gr_sum7 = [];
x = 1;
figure('Name','State');
a = 0;
x_i = [];
y_i = [];
x_q = [];

for day = 1:SIMULATION_TIME
    if day == 11+1
        gov_control = 2;
        inf_camp_lvl = 1;
    end
    if day == 18+1
        gov_control = 3;
    end
    if day == 21+1
        gov_control = 4;
    end
    if day == 25+1
        gov_control = 5;
    end
    
    if random_spawn_when_open_border == 1
        if day < border_lockdown
             if rand(1)< 1
                pop_struct = spawn_infected(pop_sq,pop_struct,1);
            end
        end
    end
    
    pop_demo = pop_struct(:,:,1);
    
    % Data update
    %tic
    b = length(x_i');
    [x,y] = find(pop_demo == 3 | pop_demo == 8); % SEEK THE INFECTED
    [xd5,yd5] = find(pop_demo == 8);
    [x_i,y_i] = find(pop_demo == 8 | pop_demo == 4);
    [x2,y2] = find(pop_demo == 3 | pop_demo == 8 | pop_demo == 4); 
    [x_q,y_q] = find(pop_demo == 2);
    [x_neig,y_neig] = get_neighbours(neighborhood_type,pop_demo,x,y);

    pop_struct = eu4_time(pop_struct,x_i,y_i,x_neig,y_neig,neighborhood_type);
    pop_struct = assert_prob(pop_struct,x_i,y_i,x_neig,y_neig,gov_control,inf_camp_lvl,coun_medical_level);

    pop_struct = update_infected(pop_struct,x_neig,y_neig);

    [pop_struct,omm,nmm] = Moirai_thread(pop_struct,x2,y2); % VIP - INFECTED ONLY
    summ = summ + omm;
    inf_o = inf_o + nmm;
    
    %Drawing part
    if live_plots == 1
        c = length(x_i')-b;
        [xdd,ydd] = find(pop_demo == 3);
        [xd2,yd2] = find(pop_demo == 4);
        [xd3,yd3] = find(pop_demo == 5);
        [xd4,yd4] = find(pop_demo == 6);
        
        subplot(3,4,[1,2,5,6,9,10])
        imagesc(pop_demo);
        title(['Day: ' num2str(day)])
        drawnow;
        subplot(3,4,3)
        a = a+c;
        inf_gr_sum = [inf_gr_sum  a];
        plot(1:day, inf_gr_sum)
        title('SUM Hosp&WS'); %ppl in hospital and ppl with symptoms
        drawnow;
        subplot(3,4,4)
        inf_gr_sum2 = [inf_gr_sum2 length(xdd')];
        plot(1:day, inf_gr_sum2)
        title('Infected'); %ppl in hospital and ppl with symptoms
        drawnow;
        subplot(3,4,7)
        inf_gr_sum5 = [inf_gr_sum5 length(x_i')-length(xd2')];
        inf_gr_sum3 = [inf_gr_sum3 length(xd2')];
        hold on
        plot(1:day, inf_gr_sum3)
        plot(1:day, inf_gr_sum5)
        hold off
        title('In hosp&With sympth');
        drawnow;
        subplot(3,4,8)
        inf_gr_sum4 = [inf_gr_sum4 length(x_q')];
        plot(1:day, inf_gr_sum4)
        title('In quarantine');
        drawnow;
        subplot(3,4,11)
        inf_gr_sum7 = [inf_gr_sum7 length(xd3')];
        plot(1:day, inf_gr_sum7)
        title('Recovered');
        drawnow;
        subplot(3,4,12)
        inf_gr_sum6 = [inf_gr_sum6 length(xd4')];
        plot(1:day, inf_gr_sum6)
        title('Dead');
        drawnow;
    else 
        imagesc(pop_demo);
        title(['Day: ' num2str(day)])
        drawnow;
    end
end

% States:
% healthy = 1
% In_quarantine = 2
% infected = 3
% In_hospital = 4
% Recovered = 5
% Dead = 6
% sick = 7
% inf_and_sic = 8
