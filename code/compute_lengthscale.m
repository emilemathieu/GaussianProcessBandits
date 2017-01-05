function [l] = compute_lengthscale(xs, sigma, kernel, data, domain_start, domain_end, size_discretization)

nb_MC_samples = size(data, 1);
I = eye(length(xs));
lengthscales = linspace(domain_start, domain_end, size_discretization);
E = zeros(nb_MC_samples, length(lengthscales));

for i = 1:length(lengthscales)
    i
    l = lengthscales(i);
    
    Kl = kernel(l);
    K = Kl(xs,xs) + sigma^2 * I;
    log_det = log(det(K));

    for j = 1:nb_MC_samples
        y = data(:, j);
        E(j, i) = 0.5 * (log_det + y' * (K \ y));
    end
end

E = mean(E,1);
[~, best_lengthscale_index] = min(E);
l = lengthscales(best_lengthscale_index);

plot(lengthscales, E,'LineWidth',1); hold on;
%axis([min(lengthscales) max(lengthscales)], [min(E)*1.1 max(E)*1.1])
ylim([min(E)*1.1 max(E)*1.1]);
plot([l l], [min(E)*1.1 max(E)*1.1],'--','LineWidth',1)
xlabel('lengthscale');
ylabel('- log likelihood');

