function J = costFunc(X, y, theta)
%COSTFUNC Compute cost for linear regression with multiple variables.

m = length(y); % number of training examples

Jvec = (X*theta - y);
Jvec = Jvec.*Jvec;
J = sum(Jvec)/(2*m);

end
