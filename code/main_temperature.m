%%% Temperature Sensors Data
%cd Desktop/MVA/S1/Graphs/Projet/code/

%% Load Data
path = '../data/temperature/';
data_full = dlmread(strcat(path, '1h_1month.csv'), ',');

sensors = unique(data_full(:,3));
nb_sensors = length(sensors);

datetimes = unique(data_full(:,2));
nb_times = length(datetimes);

%% Process Data - Filter sensors
count_sensor = [];

for i = 1:nb_sensors
    sensor = sensors(i);
    size_i = size(find(data_full(:,3) == sensor), 1);
    count_sensor = [count_sensor size_i];
end

sensors_kept = find(count_sensor >= 550);
data_sensors_kept = data_full(any(data_full(:,3) == sensors_kept, 2), :);
nb_sensors_kept = length(sensors_kept);

%% Process Data - filter datetimes
min_size = 1000; max_size = -1;
count_datetime = [];
datetime_to_delete = [];

for t = 1:nb_times
    time = datetimes(t);
    size_t = size(find(data_sensors_kept(:,2) == time), 1);
    count_datetime = [count_datetime size_t];
    if size_t < min_size, min_size = size_t; end
    if size_t > max_size, max_size = size_t; end
    if size_t ~= nb_sensors_kept
        datetime_to_delete = [datetime_to_delete time];
    end
end

data = data_sensors_kept(all(data_sensors_kept(:,2) ~= datetime_to_delete, 2), :);
data = data(:, 2:end);
clear data_sensors_kept;

%%  Process Data - Reshape, normalize and shuffle
data = sortrows(data, [1 2]);
data = reshape(data(:,3), [nb_sensors_kept, length(data)/nb_sensors_kept]);

data = data - mean(data, 2);
data = data(:,randperm(size(data,2)));

%% Parameters Definition
sigma = sqrt(0.5);
xs = (1:size(data, 1))';

%% Learn covariance
kernel_learning_data = data(:, 1:round(length(data) * 2/3));
K = cov(kernel_learning_data');
K = K ./ mean(K(:));
clear kernel_learning_data;

%% Experiments
data_start_index = round(length(data)*2/3)+1;
%MC_samples = 150; %2000
MC_samples = size(data,2) - data_start_index %max value
T = 45; %45
sigma = sqrt(5);
run_experiments(data(:, data_start_index:end), xs, K, sigma, T, MC_samples, {'UCB', 'mean', 'var','TS'})

%%
ucb_scores = zeros(length(sigmas),1);
ts_scores = zeros(length(sigmas),1);

sigmas = linspace(0.000001,1,30);
for j = 1:length(sigmas)
    sigma = sqrt(sigmas(j))
    figure(j);
    [ucb_score, ts_score] = run_experiments(data(:, data_start_index:end), xs, K, sigma, T, MC_samples, {'UCB', 'TS'});
    ucb_scores(j) = ucb_score;
    ts_scores(j) = ts_score;
end
close all
figure(1000); plot(sqrt(sigmas), ucb_scores); hold on; plot(sqrt(sigmas), ts_scores);