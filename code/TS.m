function [X, Y, A] = TS(K, sigma, f, get_reward, mu, k, xs, T, should_plot)

if nargin < 9, should_plot = 0; end
ns = size(xs,1); keps = 1e-9;
color_palette = [0.169 0.514 0.729; 0.40 0.761 0.647; 0.992 0.682 0.38; 0.843 0.098 0.11];

% Initial empty samples arrays
A = zeros(T, 1);
X = []'; Y = []';

for t=1:T
   
    if t > 1
        % Sample function f from GP
        mu_tilde = mu(K, sigma, X, Y, xs);
        k_tilde = k(K, sigma, X, xs, xs);

        f_sampled = mu_tilde + chol(k_tilde+keps*eye(ns))'*randn(ns,1);
        
        % Choose greedy action
        [~, idx_max] = max(f_sampled);
        x_new = idx_max;
    else
        x_new = randi([1 ns],1,1);
        %x_new = min(xs) + rand() * (max(xs) - min(xs));
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
    
    if should_plot && t >1
        pause(0.1)
        figure(1);
        clf
        plot(xs,f_sampled,'color', color_palette(2, :)); hold on;
        plot(xs,f,'color', color_palette(4, :)); hold on;
        plot(xs,mu(K, sigma, X, Y, xs),'.','color', color_palette(1, :)); hold on;
        ylim([-15 15])
        sig = diag(k(K, sigma, X, xs, xs));
        plot(xs,mu(K, sigma, X, Y, xs)+sig,'--','color', color_palette(1, :)); hold on;
        plot(xs,mu(K, sigma, X, Y, xs)-sig,'--','color', color_palette(1, :)); hold on;
        scatter(X(end), Y(end), 80, color_palette(1, :), '+'); hold on;
    end
end
