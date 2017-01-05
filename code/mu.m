function [y] = mu(K, sigma, X, Y, x)
    I = eye(length(X));
    if isa(K, 'inline')
        y = K(x, X)' * ((K(X, X) + sigma^2 * I) \ Y);
    else
        y = K(x, X) * ((K(X, X) + sigma^2 * I) \ Y);
    end
    
end