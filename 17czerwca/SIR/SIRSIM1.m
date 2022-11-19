function SIRSIM1(fig,day)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
time = 1:1:day;
sim('model_v420.slx',day);
hold(fig,'on');
grid(fig,'on');
plot(fig,time,round(Inf1(1:day,2)),'DisplayName','INFECTED');
plot(fig,time,round(Sick_n(1:day,2)));
plot(fig,time,round(Sick_q(1:day,2)));
plot(fig,time,round(Inf_sick(1:day,2)));
plot(fig,time,round(D(1:day,2)));
plot(fig,time,round(Re(1:day,2)));
legend(fig,'INFECTED','NO SYMPT','IN QUAR','INF AND SICK','DEAD','RECOV');
end

