function [theta, J] = gradientDescent(X, y, theta, alpha, num_iters)
%GRADIENTDESCENT Performs gradient descent to learn theta.

m = length(y); % number of training examples
J = zeros(num_iters, 1);

for iter = 1:num_iters
    theta_d = alpha*(X'*(X*theta - y))/m;
    theta = theta - theta_d;
        
    J(iter) = costFunc(X, y, theta);

end

end
