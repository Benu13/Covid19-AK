function [pop_state_mat] = reshape_of_my_heart(pop_struct)
%RE-shape of my heart Summary of this function goes here
%   Detailed explanation goes here
pop_sq = length(pop_struct);
Pop_demo = [pop_struct(:,:).state];
pop_state_mat = reshape(Pop_demo,pop_sq,pop_sq);
end

