function [X, Y, A] = UCB(K, sigma, f, get_reward, mu, k, xs, T, naive_type, should_plot)

if nargin < 10, should_plot = 0; end
if nargin < 9, naive_type = 'none'; end

ns = size(xs,1);
delta = 0.1;
color_palette = [0.169 0.514 0.729; 0.40 0.761 0.647; 0.992 0.682 0.38; 0.843 0.098 0.11];

% Initial empty samples arrays
A = zeros(T, 1);
X = []'; Y = []';

for t=1:T
   beta = 2 * log(t^2*pi^2/(6*delta));
   %beta = beta / 5; % Heuristically better according to paper
   beta = beta * 10;

    if t > 1
        mu_hat = mu(K, sigma, X, Y, xs);
        mu_hat = mu_hat(:);
        sigma_hat = sqrt(diag(k(K, sigma, X, xs, xs)));
        sigma_hat = sigma_hat(:);
        
        % Define utility
        if strcmp(naive_type, 'mean')
            utility = mu_hat;
        elseif strcmp(naive_type, 'var')
            utility = sigma_hat;
        else
            utility = mu_hat + sqrt(beta) * sigma_hat;
        end
        
        % Choose greedy action
        [~, idx_max] = max(utility);
        x_new = idx_max;
    else
        x_new = randi([1 ns],1,1);
    end

    r = get_reward(f, sigma, x_new);
    
    % Add action and reward
    if max(xs) > 1
        X = [X' x_new]';
    else
        X = [X' x_new/ns]';
    end

    Y = [Y' r]';
    A(t) = x_new;
    
    if should_plot
        pause(0.1);
        figure(1);
        clf
        plot(xs,f,'color', color_palette(4, :)); hold on;
        plot(xs,mu(K, sigma, X, Y, xs),'.','color', color_palette(1, :)); hold on;
        ylim([-15 15])
        sig = diag(k(K, sigma, X, xs, xs));
        plot(xs,mu(K, sigma, X, Y, xs)+sqrt(beta)*sig,'--','color', color_palette(1, :)); hold on;
        plot(xs,mu(K, sigma, X, Y, xs)-sqrt(beta)*sig,'--','color', color_palette(1, :)); hold on;
        scatter(X(end), Y(end), 80, color_palette(1, :), '+'); hold on;
    end
end
