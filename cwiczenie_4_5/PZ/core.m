%% preparation and data
clear all; close all;
population = 1000;                 % populacja
sick_population = 0.01;             % odsetek chorych na cos
global dim;
dim = round(sqrt(population));
pop = ones(dim,dim);                % macierz stanów populacji
msize = numel(pop);
infected_at_start = 1;
random_infected_appearing = 1;      %losowo pojawiajacy sie zarazeni 1 - on, 0 - off
pop(randperm(msize, sick_population*population)) = 4;   % sick
pop(randperm(msize, infected_at_start)) = 3;
%pop(randi(dim),randi(dim)) = 3;
liczba_testow = 1;                  %stosunek liczby wykonywanych testow do rzeczywistej

global chances;
chances = [0 0.1; 0.05 0.01; 0.3 0; 0 0.15; 0.4 0; 0.3 0; 0 0; 0 0];
chances = chances*1.1;
% bazowe prawdopodobienstwa zarazenie siebie i innych

global reform_times_and_efficiency;
reform_times_and_efficiency = [1 11 18 20 23 30 40; 0.03 0.035 0.04 0.045 0.05 0.055 0.060];
global prob;
prob.F = 0.0008;     % healthy przechodzi na in_quarantine
prob.A = 0.001;      % healty -> sick
prob.B = 0.02;       % sick -> in_quarantine
prob.N = 0.02;       % in_quarantine -> healthy
prob.P = 0.004;      % sick -> healthy
prob.O = 0.005;      % in_quarantine -> sick
                     % D sie liczy sie healthy -> infected
prob.G = 0.005*liczba_testow;      % infected -> in_quarantine
                     % C tez sie liczy sick -> infected_and_sick
prob.E = 0.05;       % infected -> infected_and_sick (procent osob z gwaltownym przebiegiem)
prob.S = 0.03;       % infected_and_sick -> dead (smiertelnosc osob z gwaltownym przebiegiem)
prob.K = 0;          % in_quarantine -> dead
prob.R = 0;          % infected_and_sick -> in_quarantine
prob.H = 0.01;       % infected_and_sick -> recovered
prob.M = 0.1*liczba_testow;        % infected_and_sick -> in_hospital
prob.L = 0.02;       % in_hospital -> dead
prob.J = 0;          % in_quarantine -> in_hospital
prob.T = 0.8;        % in_hospital -> recovered (po 50 dniach, do 50 dni sie skaluje)

global time_in_current_state;
time_in_current_state = zeros(dim,dim,2);
legend = imread('legend.png');
%% iterations
global reform;
reform = 1;   % zmniejszenie zarazliwosci o 5% za kazdy stopien
time = 210;
day = 0;
pop_cop = ones(dim,dim);
figure('Renderer', 'painters', 'Position', [200 150 1200 600])
subplot(2,2,[1,3]);
imshow(create_image(pop),'InitialMagnification', 600);

total_infected = 0;
total_dead = 0;
total_recovered = 0;
k = 15;

while day <= time
    if day == reform_times_and_efficiency(1,1)
        reform = 1;
    elseif day == reform_times_and_efficiency(1,2)
        reform = 2;
    elseif day == reform_times_and_efficiency(1,3)
        reform = 3;
    elseif day == reform_times_and_efficiency(1,4)
        reform = 4;
    elseif day == reform_times_and_efficiency(1,5)
        reform = 5;
    elseif day == reform_times_and_efficiency(1,6)
        reform = 6;
    elseif day == reform_times_and_efficiency(1,7)
        reform = 7;
    end
    if random_infected_appearing
        if day == k
            pop(randperm(msize, 2)) = 3;
            k = k + 15;
        end
    end
    number_of_infected = 0;
    number_of_dead = 0;
    number_of_recovered = 0;
    number_of_hospitalized = 0;
    for i = 1:dim
        for j = 1:dim
            neighborhood = create_neighborhood(i,j,dim,pop);
            new_state = state_change(neighborhood,i,j);
            pop_cop(i,j) = new_state;
            if new_state == 3 || new_state == 5 || new_state == 6
                if new_state == 6
                    number_of_hospitalized  = number_of_hospitalized + 1;
                end
                number_of_infected = number_of_infected + 1;
            elseif new_state == 7
                number_of_recovered = number_of_recovered + 1;
            elseif new_state == 8
                number_of_dead = number_of_dead + 1;
            end
        end
    end
    subplot(2,2,[1,3]);
    img = create_image(pop_cop);
    imshow(img,'InitialMagnification', 100);
    title("day " + num2str(day));
    colormap parula;
    drawnow;
 
    day = day + 1;
    pop = pop_cop;
    
    subplot(2,2,2);
    imshow(legend);

    infected(day) = number_of_infected;
    dead(day) = number_of_dead;
    recovered(day) = number_of_recovered;
    hospitalized(day) = number_of_hospitalized;
    
%     if day ~= 1
%         total_infected = total_infected + infected(day) - infected(day-1);
%         total_dead = total_dead + dead(day) - dead(day-1);
%         total_recovered = total_recovered + recovered(day) - recovered(day-1);
%     end
    subplot(2,2,4);
    grid on; hold on;
    set(gca,'Color',[236/255, 236/255, 236/255]);
    plot(1:day, infected,'m', 'LineWidth', 2); hold on;
    plot(1:day, recovered, 'w','LineWidth', 2); hold on;
    plot(1:day, dead, 'k','LineWidth', 2);
    plot(1:day, hospitalized);
    title("infected: " + num2str(infected(day)) + " dead: " + num2str(dead(day)) + " recovered: " + num2str(recovered(day)) + " hospitalized: " + num2str(hospitalized(day)));
    xlim([0 time]);
    xlabel('dzien od pierwszego przypadku');
    ylabel('liczba osob');
end
 
%%
real_data = load("real_data.mat").data;
figure();
subplot(1,2,1);
plot((real_data(:,2)-real_data(:,4))./666500);
hold on;
plot(((infected+recovered)./population)*100);
title('red - model, blue - real');
xlabel('day');
ylabel('procent zarazonych do calej populacji');

subplot(1,2,2);
plot(real_data(:,4)./666500);
hold on;
plot((dead./population)*100);
xlabel('day');
title('red - model, blue - real');
ylabel('procent zmarlych do calej populacji');
