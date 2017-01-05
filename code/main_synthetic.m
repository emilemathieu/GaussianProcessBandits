%%% Synthetic Data
%cd Desktop/MVA/S1/Graphs/Projet/code/

%% Parameter Definition
sigma = sqrt(0.025); % variance of noise
xs = linspace(0,1,100)'; % [0,1] compact disk discretizations

%% Kernel learning
kernel_MC_samples = 500;
kernel_discretization_size = 100;
training_data = zeros(length(xs), kernel_MC_samples);

for i = 1:kernel_MC_samples
    training_data(:, i) = sample_GP(xs);
end

l = compute_lengthscale(xs, sigma, @kernel_sq_exp, training_data, 0.01, 0.5, kernel_discretization_size)
%l = 0.2;
K = kernel_sq_exp(l);
clear training_data;
%% Experiments

MC_samples = 150; % Number of Monte Carlo sample
T = 100;
data = zeros(length(xs), MC_samples);

for i = 1:kernel_MC_samples
    data(:, i) = sample_GP(xs);
end

run_experiments(data, xs, K, sigma, T, MC_samples, {'UCB', 'mean', 'var', 'TS'})
