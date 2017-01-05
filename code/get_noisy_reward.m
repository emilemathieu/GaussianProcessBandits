function [reward] = get_noisy_reward(f, sigma, x)
%%% Return noisy reward
    y = f(x);
    espilon = normrnd(0, sigma);
    reward = y + espilon;
end