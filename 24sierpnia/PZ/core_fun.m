function core_fun(population, time, sick_p, is, tests, ria, HQ,HS,SQ, SH,QS,...
    QH,IQ,IIS,ISD,QD,ISQ,ISR,ISH,HD,HR,CHAN,REF,fig,fig2,lege,fig3,lpo)
%% preparation and data

% symulacja dla ponizszych parametrow nie jest skalibrowana do niczego, po
% prostu pokazuje ze dziala
% wyniki kalibracji do rzeczywistosci umiescilem w sprawozdaniu

%clear all; close all;
% population = 1000;                     % populacja
% time = 200;                              % czas symulacji
sick_population = sick_p;                 % odsetek chorych na cos
global dim;
dim = round(sqrt(population));
pop = ones(dim,dim);                    % macierz stanów populacji
msize = numel(pop);
infected_at_start = is;
liczba_testow = tests;                      %stosunek liczby wykonywanych testow do rzeczywistej
random_infected_appearing = ria;           %losowo pojawiajacy sie zarazeni 1 - on, 0 - off
pop(randperm(msize, sick_population*population)) = 4;   % sick
pop(randperm(msize, infected_at_start)) = 3;
%pop(randi(dim),randi(dim)) = 3;


global chances;
chances = CHAN;
chances = chances*1;
% bazowe prawdopodobienstwa zarazenie siebie i innych

global reform_times_and_efficiency;
reform_times_and_efficiency = REF;
global prob;
prob.F = HQ;             % healthy przechodzi na in_quarantine
prob.A = HS;         % healty -> sick
prob.B = SQ;          % sick -> in_quarantine
prob.N = QH;          % in_quarantine -> healthy
prob.P = SH;         % sick -> healthy
prob.O = QS;         % in_quarantine -> sick
                        % D sie liczy sie healthy -> infected
prob.G = IQ;         % infected -> in_quarantine
                        % C tez sie liczy sick -> infected_and_sick
prob.E = IIS;          % infected -> infected_and_sick (procent osob z gwaltownym przebiegiem)
prob.S = ISD;         % infected_and_sick -> dead (smiertelnosc osob z gwaltownym przebiegiem)
prob.K = QD;             % in_quarantine -> dead
prob.R = ISQ;             % infected_and_sick -> in_quarantine
prob.H = ISR;          % infected_and_sick -> recovered
prob.M = ISH*liczba_testow;        % infected_and_sick -> in_hospital
prob.L = HD;         % in_hospital -> dead
prob.J = QH;             % in_quarantine -> in_hospital
prob.T = HR;           % in_hospital -> recovered (po 50 dniach, do 50 dni sie skaluje)


global time_in_current_state;
time_in_current_state = zeros(dim,dim,2);
legend = imread('legend3.png');

%% iterations
global reform;
reform = 1;         % aktualny poziom w akcje 2

day = 0;
pop_cop = ones(dim,dim);
% figure('Renderer', 'painters', 'Position', [200 150 1200 600])
% subplot(2,2,[1,3]);
% imshow(create_image(pop),'InitialMagnification', 600);

total_infected = 0;
total_dead = 0;
total_recovered = 0;
k = 20;
xlabel('dzien od pierwszego przypadku','Parent',fig3);
ylabel('liczba osob','Parent',fig3);

while day <= time
    
    % wprowadzanie rzadowych ograniczen
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
    
    %   losowi zarazeni w losowych miejscach
    if random_infected_appearing == 1
        if day == k
            pop(randperm(msize, 1)) = 3;
            k = k + 20;
        end
    end
    
    % do danych statystycznych
    number_of_infected = 0;
    number_of_dead = 0;
    number_of_recovered = 0;
    number_of_hospitalized = 0;
    
    % start algorytmu
    for i = 1:dim
        for j = 1:dim
            neighborhood = create_neighborhood(i,j,dim,pop);
            new_state = state_change(neighborhood,i,j);
            % tworzenie sasiedztwa i nowego stanu
            
            % dodawania pikseli o okreslonym stanie do statystyk
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

    img = create_image(pop_cop);
    imshow(img,'InitialMagnification', 100,'Parent',fig);
    title("day " + num2str(day),'Parent',fig);

    drawnow;
 
    day = day + 1;
    pop = pop_cop;
    

    infected(day) = number_of_infected;
    dead(day) = number_of_dead;
    recovered(day) = number_of_recovered;
    hospitalized(day) = number_of_hospitalized;
    
    if lpo
        hold(fig3,'on')
        %set(gca,'Color',[236/255, 236/255, 236/255],'Parent',fig3);
        plot(1:day, infected,'m', 'LineWidth', 2,'Parent',fig3); 
        plot(1:day, recovered, 'w','LineWidth', 2,'Parent',fig3); 
        plot(1:day, dead, 'k','LineWidth', 2,'Parent',fig3);
        plot(1:day, hospitalized,'Color',[200/255,0,200/255],'LineWidth', 2,'Parent',fig3); 
        title("infected: " + num2str(infected(day)) + " dead: " + num2str(dead(day)) + " recovered: " + num2str(recovered(day)) + " hospitalized: " + num2str(hospitalized(day)),'Parent',fig3);
        %xlim([0 time],'Parent',fig3);
        drawnow
    end
end
 
%%
% real_data = load("real_data.mat").data;
% figure();
% subplot(1,2,1);
% plot((real_data(:,2)-real_data(:,4))./666500);
% hold on;
% plot(((infected+recovered)./population)*100);
% title('red - model, blue - real');
% xlabel('day');
% ylabel('procent zarazonych do calej populacji');
% 
% subplot(1,2,2);
% plot(real_data(:,4)./666500);
% hold on;
% plot((dead./population)*100);
% xlabel('day');
% title('red - model, blue - real');
% ylabel('procent zmarlych do calej populacji');
end

