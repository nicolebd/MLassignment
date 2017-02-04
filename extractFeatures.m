function [F_x F_y pos] = extractFeatures(data)
% EXTRACTFEATURES extracts features and constructs training example tuples.
%   A separate feature vector is constructed for each x and corresponding y
%   value and the vectors are stored in F_x and F_y respectively. x and y
%   target values are stored in pos as [x1, y1; x2 y2; ...].

    l = size(data, 1); % number of (t, x, y) tuples in dataset
    marker = 2; % points to the first tuple of projectile 1 (ignores (0,0,0))
    vx = 0; % stores x component of initial velocity.
    vy = 0; % stores y component of initial velocity.
    angle = 0;
    
    F_x = zeros(l, 4);
    F_y = zeros(l, 5);
    pos = zeros(l, 2);
    
    % extract features and populate F_x and F_y
    for i = 2:l
      % when we reach the last tuple for a projectile
      if data(i, 1) == 0 || i == l
          
          if i == l
            i = i + 1;
          end
            
          t = data(marker, 1)*0.01;
          
          %extract horizontal velocity which is constant (vx = x/t)
          vx = data(i-1, 2)/(0.01*data(i-1, 1)); 

          %extract intitial vertical velocity (y = vy0*t - 0.5*g*t^2)          
          vy = (data(marker, 3) + 0.5*9.8*t*t)/t;
          
          %initial velocity
          v0 = sqrt(vx*vx + vy*vy);
          
          %extract angle
          angle = asin(vy/v0);
          
          %populate X and pos
          for j = marker:i - 1
              t = data(j,1)*0.01;
              F_x(j, :) = [angle t  vx t*vx];
              F_y(j,:) = [angle vy t t*t vy*t];
              pos(j, :) = [data(j, 2) data(j, 3)]; 
          end
          
          %update marker to point to the next projectile
          marker = i+1;
      end
    end
    
    % count the number of rows containing tuples of 0's (t = 0) and remove them
    % as they do not provide any information.
    count = 0;
    for i = 1:l
          if F_x(i,:) == [0]
              count = count + 1;
          end
    end
    j = 1;
    for i = 1:count
          while F_x(j, 1) != 0
            j = j + 1;
          end
          if F_x(j, 1) == 0
                F_x(j,:) = [];
                F_y(j,:) = [];
                pos(j,:) = [];
          end
    end
end