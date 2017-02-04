function [X_norm, mu, sigma] = featureNormalize(X)
%FEATURENORMALIZE Normalizes the features in X 
%   FEATURENORMALIZE(X) returns a normalized version of X where
%   the mean value of each feature is 0 and the standard deviation
%   is 1.

X_norm = X;
       
mu = mean(X); % compute mean of each column in X and store in row vector.
sigma = std(X); % compute standard deviation of each column in X and
% store in row vector.

m = size(X,1); % no. of features.

% normalize each feature
X_norm = (X - ones(m, 1)*mu)./(ones(m,1)*sigma);

end
