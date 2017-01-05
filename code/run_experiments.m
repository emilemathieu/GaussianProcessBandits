function [ucb_score, ts_score] = run_experiments(data, xs, K, sigma, T, MC_samples, algorithms, should_plot)

if nargin < 8, should_plot = 0; end
if nargin < 7, algorithms = {'UCB'}; end

% Initialize empty arrays
regrets = zeros(MC_samples, T, 4);

%parpool(2) and replace for by parfor for parallel computing
for i = 1:MC_samples
    %i
    
    % Sample function
    f = data(:, i);

    % Algorithms maximization
    if any(strcmp('UCB',algorithms))
        [~, Y, A] = UCB(K, sigma, f, @get_noisy_reward, @mu, @k, xs, T, 'none', should_plot);
        regrets(i, :, 1) = compute_regret(f, A, Y, xs);
    end
    if any(strcmp('mean',algorithms))
        [~, Y, A] = UCB(K, sigma, f, @get_noisy_reward, @mu, @k, xs, T, 'mean', should_plot);
        regrets(i, :, 2) = compute_regret(f, A, Y, xs);
    end
    if any(strcmp('var',algorithms))
        [~, Y, A] = UCB(K, sigma, f, @get_noisy_reward, @mu, @k, xs, T, 'var', should_plot);
        regrets(i, :, 3) = compute_regret(f, A, Y, xs);
    end
    if any(strcmp('TS',algorithms))
        [~, Y, A] = TS(K, sigma, f, @get_noisy_reward, @mu, @k, xs, T, should_plot);
        regrets(i, :, 4) = compute_regret(f, A, Y, xs);
    end
end

% Plots
%figure(1);
if any(strcmp('UCB',algorithms))
    plot(mean(regrets(:,:,1)),'LineWidth',1); hold on;
end
if any(strcmp('mean',algorithms))
    plot(mean(regrets(:,:,2)),'LineWidth',1); hold on;
end
if any(strcmp('var',algorithms))
    plot(mean(regrets(:,:,3)),'LineWidth',1); hold on;
end
if any(strcmp('TS',algorithms))
    plot(mean(regrets(:,:,4)),'LineWidth',1); hold on;
end

legend(algorithms);
xlabel('Iterations');
ylabel('Mean Average Regret')
%ylim([0 20]);

%ucb_mean = mean(regrets(:,:,1));
%ucb_score = ucb_mean(end);

%ts_mean = mean(regrets(:,:,4));
%ts_score = ts_mean(end);