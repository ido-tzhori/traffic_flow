clc; clear;
dx = 1; % x step size
dt = 0.01; % time step
t_end = 100;
num_cars = 100;
l = 10; % length of the road
time_steps = t_end/dt;
v_max = 3;
dmin = 0.5;
dmax = 0.2;
tau = 0.02; % note sure what this represents
p = zeros(num_cars, time_steps); % position of cars
vel = zeros(num_cars, time_steps); % velocity of cars
stoplight_position = 5;
stoplight_interval = 100; % toggle every n time steps

% initial conditional
p(:, 1) = linspace(0, l/8, num_cars)';
vel(:, 1) = rand(num_cars, 1); % random velocities

for k = 1:time_steps
    stoplight_on = mod(floor(k / stoplight_interval), 2) == 0;
    for i = 1:num_cars
        if i == num_cars % handle last car
            distance_to_car = l;
        else
            distance_to_car = abs(p(i, k) - p(i + 1, k));
        end
        if stoplight_on && p(i, k) >= stoplight_position - dmin && p(i, k) < stoplight_position
            distance_to_car = min(distance_to_car, stoplight_position - p(i, k));
        end
        v_new = vlag(distance_to_car, vel(i, k), dt, tau, dmin, dmax, v_max, p(i,k), l);
        vel(i, k+1) = v_new;
    end
    p(:, k+1) = p(:, k) + dt * vel(:, k);
end


% flow = zeros(1, time_steps);
% density = zeros(1, time_steps);
% speed = zeros(1, time_steps);
% 
% for k = 1:time_steps
%     density(k) = num_cars / l;
%     speed(k) = mean(vel(:, k));
%     flow(k) = density(k) * speed(k);
% end
% 
% % Plot the flow-density graph
% figure(2)
% plot(density, flow, '-o');
% xlabel('Density (k)');
% ylabel('Flow (q)');
% title('Flow-Density');
% 
% % Plot the flow-speed graph
% figure(3)
% plot(speed, flow, '-o');
% xlabel('Speed (v)');
% ylabel('Flow (q)');
% title('Flow-Speed');

figure(1)

for i = 1:time_steps
    stoplight_on = mod(floor(i / stoplight_interval), 2) == 0;
    stoplight_color = 'r';
    if ~stoplight_on
        stoplight_color = 'g';
    end
    plot(stoplight_position, 0, 'o', 'MarkerFaceColor', stoplight_color, 'MarkerEdgeColor', stoplight_color, 'MarkerSize', 7);
    hold on;
    plot(p(:, i), zeros(num_cars, 1), 'ok', 'MarkerSize', 7);
    xlim([0, 2 * l]);
    ylim([-0.5, 0.5]);
    hold off;
    pause(dt);
end

function vv = v(d, dmin, dmax, vmax)
    if (d < dmin)
        vv = 0;
    elseif (d < dmax) 
        vv = vmax * log(d/dmin)/log(dmax/dmin);
    else
        vv = vmax;
    end
end

function v_new = vlag(d, v_old, dt, tau, dmin, dmax, vmax, p, l)
%     if d > l + p
%         v_new = 0;
%     else
    v_new = (dt*v(d, dmin, dmax, vmax) + tau * v_old) / (dt + tau);
end
