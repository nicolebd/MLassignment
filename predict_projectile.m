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

thetay = zeros(3, 1);
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

ch = input('Press enter to test sample input or press [q] to quit. ', 's');
c = 0; % file number to be written to
name = 'predicted_data_'; % file name prefix
while isempty(ch) || ch ~= 'q'
  c = c + 1;
  u = input('Please enter the initial velocity (m/s): ');
  angle = input('Please enter the angle (degrees): ');

  angle = angle * pi/180; % converting to radians
  vx0 = u*cos(angle);
  vy0 = u*sin(angle);
  
  fprintf('\n[t],  [x],       [y]');
  fprintf('\n%d, %f, %f', 0,0,0);
  % Estimate the points
  values = zeros(1,3); % stores predicted (t, x, y) values
  for i = 1:100
    xpred = [angle i*0.1 vx0 i*0.1*vx0];
    xpred = (xpred - mu_x)./sigma_x;
    xpred = [1 xpred];
    x = xpred*thetax;
  
    ypred = [i*i*0.1*0.1 vy0*i*0.1];
    ypred = (ypred - mu_y)./sigma_y;
    ypred = [1 ypred];
    y = ypred*thetay;
  
    % if y is -ve stop, as projectile has reached the ground
    if (y < 0)
      break;
    end
    values(i+1,:) = [i x y];
    fprintf('\n%d, %f, %f', i,x,y);
  end
  % write to csv file
  filename = [name num2str(c) '.csv'];
  csvwrite(filename, values);
  fprintf('\n\n');
  ch = input('Press enter to continue testing or press [q] to quit. ','s');
end

fprintf('\n');
