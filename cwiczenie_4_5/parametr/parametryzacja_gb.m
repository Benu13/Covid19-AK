clear all; close all;

excel = table2array(readtable("data_gb.xlsx","Range","B3:C99"));
daily_new = excel(:,1)';        % 
total_cases = excel(:,2)';
day = 1:97;


beta1 = 0;
beta2 = 0;
beta3 = 0;
beta4 = 0;
delta1 = 0;
delta2 = 0;
delta3 = 0;
delta4 = 0;
% alfa = 1/60000000;
% alfa = 0.0000000166

T = 97;
best = 10000000000000;
best_set = 0;
for alfa = 0.00000001:0.0000000005:0.00000003
%     for beta1 = 0:0.005:0.01
%         for beta2 = 0:0.005:0.01
%             for beta3 = 0:0.005:0.01
%                 for beta4 = 0:0.005:0.01
%                     for delta1 = 0:0.005:0.01
%                         for delta2 = 0:0.005:0.01
%                             for delta3 = 0:0.005:0.01
%                                 for delta4 = 0:0.005:0.01
                                    out = sim('model_par_gb.slx',T);
                                    s = 0;
                                    for i = 1:97
                                        s = s + abs(total_cases(i) - out.I(i,2));
                                        s = s + abs(daily_new(i) - out.Inf1(i,2));
                                    end
                                    if s <= best
                                        best_set = [alfa beta1 beta2 beta3 beta4 delta1 delta2 delta3 delta4];
                                        best = s;                                        
                                    end
%                                 end
%                             end
%                         end
%                     end
%                 end
%             end
%         end
%     end
end
%%
figure();    
plot(day,daily_new); hold on;
plot(day,out.I(2:98,2));
legend('gb', 'sim');
grid on;
figure();
plot(day,total_cases); hold on;
plot(day,out.Inf1(2:98,2));


