function [f] = sample_GP(xs, l)
    %%% f ~ GP
    % l:length-scale parameter
    if nargin < 2, l=0.2; end

    keps = 1e-9;
    ns = size(xs,1);
    kernel = kernel_sq_exp(l);
    %kernel = inline('exp(-0.5/(0.2)^2*(repmat(p'',size(q))-repmat(q,size(p''))).^2)');
    f = 0 + chol(kernel(xs, xs)+keps*eye(ns))'*randn(ns,1);
end