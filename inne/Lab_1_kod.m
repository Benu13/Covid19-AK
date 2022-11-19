%% zad2 obliczanie czasow (tylko dla FIFO)
clear all; close all;
n = 10;
a = [4 42 70 100 123 145 190 226 310 322];
s = [43 36 34 30 30 40 31 29 36 30];
a_copy = a; 

d = (0); 
c = (0);
for i = 1:n-1
    if (a_copy(i)+s(i) > a_copy(i+1))
        a_copy(i+1) = a_copy(i)+s(i);
        d(i+1) = a_copy(i+1)-a(i+1);
    else
        a_copy(i+1) = a_copy(i+1);
        d(i+1) = 0;
    end
    c(i) = a_copy(i) + s(i);
end
c(10) = a_copy(10) + s(10);

%% zad5 wyliczanie danych dla roznych rodzajow kolejek
clear all; close all;
sim('server');

a = [4 42 70 100 123 145 190 226 310 322];
%s = [43 36 34 30 30 40 31 29 36 30];
s = [53 46 44 40 40 50 41 39 46 40];
r = [4 38 28 30 3 22 45 36 84 12];
d = [0 0 0 0 0 0 0 0 0 0];
c = [0 0 0 0 0 0 0 0 0 0];
w = [0 0 0 0 0 0 0 0 0 0];
for i=1:1:10
    c(order(i)) = dep_time(i,1);
    d(order(i)) = dep_time(i,1)-s(order(i))-a(order(i));
    w(order(i)) = dep_time(i,1) -a(order(i));
end
average_w = mean(w);
average_r = mean(r);
aver_queue_size = aver_queue_size(ceil(c(order(10))/10) + 1,2);