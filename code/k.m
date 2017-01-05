function [y] = k(K, sigma, X, x1, x2)
    I = eye(length(X));
    
    if isa(K, 'inline')
        y = K(x1, x2) - K(x1, X)' * ((K(X, X) + sigma^2 * I) \ K(x2, X));
    else
        y = K(x1, x2) - K(x1, X) * ((K(X, X) + sigma^2 * I) \ K(x2, X)');
    end
end