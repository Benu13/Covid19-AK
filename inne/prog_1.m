a = [ 12 42 71 111 123 152 166 226 310 380]; %czas nadej�cia i-tej wiadomo�ci
b = [43 31 34 30 38 40 31 29 36 30]; % czas przetwa�ania i-tej wiadomo�ci

%% FIFO
% Czas oczekiwania i tej wiadomo�ci w kolejce 
i_w = 10; % wybieramy index wiadmo�ci kt�rej czas oczekiwania chcemy obliczy�

a %wektor czas�w nadej�cia wiadomo�ci
s %wektor czas�w przetworzenia wiadomo�ci
c = a; % zmienna pomocnicza, aby nie narusza� oryginanych zmiennych
w_t = (0); % wektor czasu oczekiwania ka�dej wiadomo�ci z przedzia�u 1:wybrany index
for i = 1:1:length(a)-1
    if (c(i)+b(i) > c(i+1))
        c(i+1) = c(i)+b(i);
        w_t(i+1) = c(i+1)-a(i+1);
    else
        c(i+1) = c(i+1);
        w_t(i+1) = 0;
    end
end
%czas opuszczenia serweru przez wiadomo��
l_t = c+b;
%%
for i=1:9
    j(i+1)= a(i+1)-(a(i))
end