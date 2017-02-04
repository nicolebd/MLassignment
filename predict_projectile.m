% This script will train a linear regressor to predict the x and y values of
% for a projectile at a given time instant based on the values of its initial
% velocity and angle.

clear ; close all; clc

fprintf('Loading data ...\n');

% Load data and extract features
data = load('projectiles.csv');
[Fx Fy pos] = extractFeatures(data);
m = size(Fx, 1);

% Scale features and set them to zero mean
fprintf('Normalizing Features ...\n');

[Fx mu_x sigma_x] = featureNormalize(Fx);
[Fy mu_y sigma_y] = featureNormalize(Fy);

% Add intercept term to X
Fx = [ones(m, 1) Fx];
Fy = [ones(m, 1) Fy];

fprintf('Press enter to train ...\n');
pause;
 
% Set alpha and number of iterations
alpha = 0.01;
num_iters = 10000;

% Run Gradient Descent 
thetax = zeros(5, 1);
[thetax, J_x] = gradientDescent(Fx, pos(:,1), thetax, alpha, num_iters);

thetay = zeros(6, 1);
[thetay, J_y] = gradientDescent(Fy, pos(:,2), thetay, alpha, num_iters);

% Plot the convergence graph for x and y
figure;
plot(1:numel(J_x), J_x, '-b', 'LineWidth', 2);
xlabel('Number of iterations');
ylabel('Cost X');
figure;
plot(1:numel(J_y), J_y, '-b', 'LineWidth', 2);
xlabel('Number of iterations');
ylabel('Cost Y');

% Display theta values
fprintf('Theta_x: \n');
fprintf(' %f \n', thetax);
fprintf('\n');
fprintf('Theta_y: \n');
fprintf(' %f \n', thetay);
fprintf('\n');

u = input('Please enter the initial velocity (m/s): ');
angle = input('Please enter the angle (degrees): ');

angle = angle * pi/180; % converting to radians
vx0 = u*cos(angle);
vy0 = u*sin(angle);

fprintf('\n[t],  [x],       [y]');
fprintf('\n%d, %f, %f', 0,0,0);
% Estimate the points
for i = 1:100
  xpred = [angle i*0.01 vx0 i*0.01*vx0];
  xpred = (xpred - mu_x)./sigma_x;
  xpred = [1 xpred];
  
  ypred = [angle vy0 i*0.01 i*i*0.01*0.01 vy0*i*0.01];
  ypred = (ypred - mu_y)./sigma_y;
  ypred = [1 ypred];
  
  x = xpred*thetax;
  y = ypred*thetay;
  
  % if y is -ve stop, as projectile has reached the ground
  if (y < 0)
    break;
  end
  fprintf('\n%d, %f, %f', i,x,y);
end

fprintf('\n');
