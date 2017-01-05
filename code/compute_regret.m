function [regret] = compute_regret(f, A, Y, xs)

[max_f, argmax_f] = max(f);

regret = max_f - f(A);