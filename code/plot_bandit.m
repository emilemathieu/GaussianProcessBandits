function [] = plot_bandit(X, Y, K, s, f, mu, k, xs)

color_palette = [0.169 0.514 0.729; 0.40 0.761 0.647; 0.992 0.682 0.38; 0.843 0.098 0.11];

plot(xs,f,'color', color_palette(4, :)); hold on;
scatter(X, Y, 80, color_palette(1, :), '+'); hold on;

plot(xs,mu(K, s, X, Y, xs),'.','color', color_palette(1, :)); hold on;

sig = diag(k(K, s, X, xs, xs));
plot(xs,mu(K, s, X, Y, xs)+sig,'--','color', color_palette(1, :)); hold on;
plot(xs,mu(K, s, X, Y, xs)-sig,'--','color', color_palette(1, :)); hold on;