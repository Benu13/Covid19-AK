a = [ 12 42 71 111 123 152 166 226 310 380]; %czas nadejœcia i-tej wiadomoœci
b = [43 31 34 30 38 40 31 29 36 30]; % czas przetwa¿ania i-tej wiadomoœci

%% FIFO
% Czas oczekiwania i tej wiadomoœci w kolejce 
i_w = 10; % wybieramy index wiadmoœci której czas oczekiwania chcemy obliczyæ

a %wektor czasów nadejœcia wiadomoœci
s %wektor czasów przetworzenia wiadomoœci
c = a; % zmienna pomocnicza, aby nie naruszaæ oryginanych zmiennych
w_t = (0); % wektor czasu oczekiwania ka¿dej wiadomoœci z przedzia³u 1:wybrany index
for i = 1:1:length(a)-1
    if (c(i)+b(i) > c(i+1))
        c(i+1) = c(i)+b(i);
        w_t(i+1) = c(i+1)-a(i+1);
    else
        c(i+1) = c(i+1);
        w_t(i+1) = 0;
    end
end
%czas opuszczenia serweru przez wiadomoœæ
l_t = c+b;
%%
for i=1:9
    j(i+1)= a(i+1)-(a(i))
end