clc; clear; close all;

dt = 0.01; % time step
t_end = 100;
r = 1; % radius of the road
time_steps = t_end/dt;
v_max = 3;
dmin = pi/30;
dmax = pi/20;
tau = 0.0; % reaction speed in terms of dt

num_cars_list = 1:1:74; % testing multiple densities
results = zeros(length(num_cars_list), 3); % matrix to store results

for n = 1:length(num_cars_list)
    num_cars = num_cars_list(n);
    theta = zeros(num_cars, time_steps); % angular position of cars
    vel = zeros(num_cars, time_steps); % velocity of cars

    % initial conditional
    theta(:, 1) = (1:num_cars) * 0.01 * pi/num_cars;
    vel(:, 1) = 0;

    car_counter = 0; % initialize car counter every iteration
    prev_theta = theta(:, 1); % to track flow

    for k = 1:time_steps
        for i = 1:num_cars
            distance_to_car = mod(theta(mod(i,num_cars)+1, k) - theta(i, k), 2*pi); % need to use inner mod function
                                                                                    % to ensure the last car gets 
                                                                                    % compared to first car
            v_new = vlag(distance_to_car, vel(i, k), dt, tau, dmin, dmax, v_max);
            vel(i, k+1) = v_new;
        end
        theta(:, k+1) = mod(theta(:, k) + dt * vel(:, k), 2*pi); % update angular position
        
        % split into two identical for loops for clarity
        for j = 1:num_cars
            if prev_theta(j) < pi && theta(j, k+1) >= pi % counter for flow
                car_counter = car_counter + 1;
            end
        end

        prev_theta = theta(:, k+1);
    end

    avg_velocity = mean(vel(n, :)); % average the velocity of all cars for certain simulation
    density = num_cars / (2 * pi * r); % calculate density
    flow = car_counter / t_end; % floooow
    results(n, :) = [density, avg_velocity, flow];
end

% plottings
figure;

subplot(3, 1, 1);
plot(results(:, 1), results(:, 2), 'o');
xlabel('Density');
ylabel('Average Velocity');
title('Density vs Average Velocity');
ylim([0, 4])
grid on;

subplot(3, 1, 2);
plot(results(:, 1), results(:, 3), 'o');
xlabel('Density');
ylabel('Flow');
title('Density vs Flow');
grid on;

subplot(3, 1, 3);
plot(results(:, 3), results(:, 2), 'o');
ylabel('Average Velocity');
xlabel('Flow');
title('Flow vs Velocity');
ylim([0, 4])
grid on;


function vv = v(d, dmin, dmax, vmax)
    if (d < dmin)
        vv = 0;
    elseif (d < dmax) 
        vv = vmax * log(d/dmin)/log(dmax/dmin);
    else
        vv = vmax;
    end
end

function v_new = vlag(d, v_old, dt, tau, dmin, dmax, vmax)
    v_new = (dt*v(d, dmin, dmax, vmax) + tau * v_old) / (dt + tau);
end
