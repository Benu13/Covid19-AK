function SIRSIM(fig,day)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
time = 1:1:day;
sim('modell_v3.mdl',day);
hold(fig,'on');
grid(fig,'on');
plot(fig,time,round(INFECTED(1:day,2)),'DisplayName','INFECTED');
plot(fig,time,round(NO_SYMP(1:day,2)));
plot(fig,time,round(IN_QUAR(1:day,2)));
plot(fig,time,round(INF_AND_SIC(1:day,2)));
plot(fig,time,round(DEAD(1:day,2)));
plot(fig,time,round(RECOVERY(1:day,2)));
legend(fig,'INFECTED','NO SYPT','IN QUAR','INF AND SICK','DEAD','RECOV');
end

