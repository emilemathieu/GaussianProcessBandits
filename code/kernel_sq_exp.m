function [Kl] = kernel_sq_exp(l)
    Kl = inline(strcat('exp(-0.5/(',num2str(l),')^2*(repmat(p'',size(q))-repmat(q,size(p''))).^2)'));
end