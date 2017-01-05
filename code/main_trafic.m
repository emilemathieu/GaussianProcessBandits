%%% Trafic Sensors Data
%cd Desktop/MVA/S1/Graphs/Projet/code/

%% Load Data
path = '../data/traffic/';

! rm -rf ../data/traffic/san_diego_sb5_copy.csv
! cp ../data/traffic/san_diego_sb5_filtered_6-11am.csv ../data/traffic/san_diego_sb5_copy.csv
! sed -i .bak 's/no/NaN/g' ../data/traffic/san_diego_sb5_copy.csv
! rm ../data/traffic/san_diego_sb5_copy.csv.bak

data = dlmread(strcat(path, 'san_diego_sb5_copy.csv'), ' ');

%% Preprocess Data
[counts, ids] = hist(data(:,1), unique(data(:,1)));
ids_to_delete = ids(find(counts < max(counts)));
data(any(data(:,1) == ids_to_delete', 2), :) = [];

N = length(unique(data(:,1)));
data = reshape(data(:,2), [N, length(data)/N]);
data = data(~any(isnan(data), 2), :);

data = data(:,randperm(size(data,2)));
data = data - mean(data, 2);
data = -data;

%% Parameters
sigma = sqrt(4.78);
xs = (1:size(data, 1))';

%% Learn covariance
kernel_learning_data = data(:, 1:round(length(data) * 2/3));
K = cov(kernel_learning_data');
K = K ./ mean(K(:));
clear kernel_learning_data;

%% Experiments
data_start_index = round(length(data)*2/3)+1;
T = 50; %350
%MC_samples = 100; %900
MC_samples = size(data,2) - data_start_index %max value

run_experiments(data(:, data_start_index:end), xs, K, sigma, T, MC_samples, {'UCB', 'mean','var','TS'})