function SIRSIM1(fig,day,al, b1, b2, b3, b4, d1, d2, ...
    d3, d4, population, test_rate)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
time = 1:1:day;

sim('model_par_gb_2018a.mdl',day*10);
hold(fig,'on');
grid(fig,'on');
plot(fig,time,round(ans.Inf1(1:day,2)),'DisplayName','INFECTED');
plot(fig,time,round(ans.Sick_n(1:day,2)));
plot(fig,time,round(ans.Sick_q(1:day,2)));
plot(fig,time,round(ans.Inf_sick(1:day,2)));
plot(fig,time,round(ans.D(1:day,2)));
plot(fig,time,round(ans.Re(1:day,2)));
plot(fig,time,round(ans.H(1:day,2)));
legend(fig,'INFECTED','NO SYMPT','IN QUAR','INF AND SICK','DEAD','RECOV','HEALTHY');
end

