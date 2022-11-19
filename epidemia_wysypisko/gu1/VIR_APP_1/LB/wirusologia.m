clear all; close all;
neighborhood_type = 1; %1 - Moore, 2-Neumann
live_plots = 1; %SET ON ONE TO DRAW PLOTS LIVE SET ON ZERO TO ONLY GET STATE MATRIX
random_spawn_when_open_border = 0; %SET ON ONE TO GET RANDOM INFECTED WHEN COUNTRY IS NOT ON LOCKDOWN
border_lockdown = 23; % DAY OF BORDER LOCKDOWN
SIMULATION_TIME = 70;
number_of_test = 0.4; %sum of tests to population ratio 
starting_infected = 1; % Number of infected at the start of simulation
no_symp = 0.25; %percentage of no symptoms cases
reforms_day = [11 18 21 25]; %change in gov_control 11-2 18-3 21-4 25-5
inf_camp_day = [11]; %increase in media information
%% vir inf
inc_t = 6;
rec_t = 28;
av_dr = 0.03;
vir_cont = 1;
%% Country data
population = 10000; 
people_older_than_60 = 0.05; % in %
high_risk = 0.01;% in %
sick = people_older_than_60 + high_risk;
gov_control = 1; %goverment intervention level
inf_camp_lvl = 1; % information campain level

coun_medical_level = 1; %level of country heathcare, 
social_addaptation = 0; %how much society adapted to occurring situation, not implemented
panic_level = 0; %modyficator for panic in society, valid at the beginning of unknown threat
tourism = 3;
gov_inf = 2;
pop_density = 30;
discipline = 70;

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

% Person struct 
p.state = 1;
p.get_inf_ch = inf_chance_base; % infection chance
p.quarantine_chance = quar_chance_base;
p.death_chance = deatch_chance_base;
p.time_since_infected = 0; 
p.go_to_hosp_chance = go_to_hosp_chance_base;
p.self_protecting = 0;
p.prot_by_org = 0;
p.protectiong_others = 0;
p.organizing_protection = 0;
p.was_sick = 0;
p.protected_by_others = 0;
p.days_in_quarantine = 0;

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
%important_num = no_symp + (0.75 - number_of_test); %important number
cmap = jet(10);
figure('Name','State');
colormap(cmap);
a = 0;
x_i = [];
y_i = [];
x_q = [];
xd5 = [];
xd6 = [];
spawn_rate = tourism;
for day = 1:SIMULATION_TIME
    [gov_control, inf_camp_lvl, panic_level,social_addaptation] = assert_reforms(gov_control,inf_camp_lvl,day,panic_level,reforms_day, inf_camp_day,discipline,social_addaptation);
    if random_spawn_when_open_border == 1
        if day < border_lockdown
             if rand(1)< 1
                pop_struct = spawn_infected(pop_sq,pop_struct,spawn_rate);
            end
        end
    end
    
    pop_demo = pop_struct(:,:,1);
    
    % Data update
    %tic
    b = length(xd5');
    [x,y] = find(pop_demo == 3 | pop_demo == 8 | pop_demo == 10); % SEEK THE INFECTED
    [xd5,yd5] = find(pop_demo == 8 | pop_demo == 4);
    [x_i,y_i] = find(pop_demo == 8 | pop_demo == 4 | pop_demo == 9 | pop_demo == 10);
    [x2,y2] = find(pop_demo == 3 | pop_demo == 8 | pop_demo == 4 | pop_demo == 10 | pop_demo == 9); 
    [x_q,y_q] = find(pop_demo == 2);
    [x_neig,y_neig] = get_neighbours(neighborhood_type,pop_demo,x,y);

    
    pop_struct = eu4_time(pop_struct,x_neig,y_neig,neighborhood_type,inf_camp_lvl,panic_level);
    pop_struct = assert_prob(pop_struct,x_i,y_i,x_neig,y_neig,gov_control,inf_camp_lvl,coun_medical_level,number_of_test,...
        av_dr,panic_level, gov_inf, discipline, social_addaptation, pop_density, vir_cont);

    pop_struct = update_infected(pop_struct,x_neig,y_neig,x_q,y_q);

    [pop_struct,omm,nmm] = Moirai_thread(pop_struct,x2,y2,no_symp,inc_t,rec_t);
    summ = summ + omm;
    inf_o = inf_o + nmm;
    
    if(length(xd5')-b) > 0
        c = length(xd5')-b;
    else
        c=0;
    end
   
        
    %Drawing part
    if live_plots == 1
        [xdd,ydd] = find(pop_demo == 3);
        [xd2,yd2] = find(pop_demo == 4);
        [xd3,yd3] = find(pop_demo == 5);
        [xd4,yd4] = find(pop_demo == 6);
        [xd6,yd6] = find(pop_demo == 9);
        
        subplot(3,4,3)
        a = a+c;
        inf_gr_sum = [inf_gr_sum  a];
        plot(1:day, inf_gr_sum)
        title('Confirmed_cases'); %ppl in hospital and ppl with symptoms
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
        subplot(2,2,[1,3])
        imagesc(pop_demo);
        colormap(cmap);
        title(['Day: ' num2str(day)])
        drawnow;
        subplot(2,2,[2,4])
        a = a+c;
        inf_gr_sum = [inf_gr_sum  a];
        plot(1:day, inf_gr_sum)
        title('SUM Hosp&WS'); %ppl in hospital and ppl with symptoms
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
% sick_and_in_qarantine = 9;
% sinck_no_sympthoms = 10;
