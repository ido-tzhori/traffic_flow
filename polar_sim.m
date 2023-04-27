clc; clear; close all;
dt = 0.01; % time step
t_end = 10;
num_cars = 50;
r = 1; % radius of the road
time_steps = t_end/dt;
v_max = 3;
% buffer = pi/70;
dmin = pi/30;% + buffer;
dmax = pi/20;
tau = 0.01; % reaction speed in terms of dt
theta = zeros(num_cars, time_steps); % angular position of cars
vel = zeros(num_cars, time_steps); % velocity of cars

% initial conditional
theta(:, 1) = (1:num_cars) * 2 * pi/num_cars;
vel(:, 1) = v_max*rand(num_cars, 1); % random velocities

for k = 1:time_steps
    for i = 1:num_cars
        distance_to_car = mod(theta(mod(i,num_cars)+1, k) - theta(i, k), 2*pi); % need to use inner mod function
                                                                                % to ensure the last car gets 
                                                                                % compared to first car
        v_new = vlag(distance_to_car, vel(i, k), dt, tau, dmin, dmax, v_max);
        vel(i, k+1) = v_new;
    end
    theta(:, k+1) = mod(theta(:, k) + dt * vel(:, k), 2*pi); % update angular position
end

video_filename = 'crazy.mp4';
v_writer = VideoWriter(video_filename, 'MPEG-4');
open(v_writer);

large_figure = figure;
screen_size = get(0, 'ScreenSize');
figure_width = screen_size(3) * 0.3;
figure_height = screen_size(4) * 0.5;
set(large_figure, 'Position', [(screen_size(3) - figure_width) / 2, (screen_size(4) - figure_height) / 2, figure_width, figure_height]);

cmap = [linspace(1, 0, 200)', linspace(0, 0, 200)', linspace(0, 1, 200)']; % range of colors

car_counter = 0;
prev_theta = theta(:, 1);

for i = 1:time_steps
    clf;
    hold on;
    for j = 1:num_cars
        distance_to_car = mod(theta(mod(j,num_cars) + 1, i) - theta(j, i), 2*pi);
        color_idx = round(200 * (distance_to_car - dmin) / (dmax - dmin)) + 1; 
        color_idx = max(1, min(color_idx, 200));
        plot(r*cos(theta(j,i)), r*sin(theta(j,i)), 'o', 'MarkerSize', 7, 'MarkerFaceColor', cmap(color_idx, :), 'MarkerEdgeColor', cmap(color_idx, :));

        if prev_theta(j) < pi && theta(j, i) >= pi % counter to get the car going past position pi
            car_counter = car_counter + 1;
        end
    end

    prev_theta = theta(:, i);

    text(-r+r/10, 0, sprintf('cars passed: %d', car_counter), 'FontSize', 14);
    text(-r/10, r - r/10, sprintf('time: %.2f', i*dt), 'FontSize', 14);

    hold off;
    axis equal;
    xlim([-r-r/10, r+r/10]);
    ylim([-r-r/10, r+r/10]);
    pause(dt);

    frame = getframe(large_figure);
    writeVideo(v_writer, frame);
end

close(v_writer);

% figure;
% hold on;
% 
% dist = zeros(num_cars, time_steps);
% for i = 1:num_cars
%     for k = 2:time_steps
%         % if car looped then add circumference
%         if theta(i, k) < theta(i, k - 1)
%             dist(i, k) = dist(i, k - 1) + 2 * pi * r;
%         else
%             dist(i, k) = dist(i, k - 1);
%         end
%     end
% 
%     plot(0:dt:(time_steps - 1)*dt, r * theta(i, 1:end-1) + dist(i, :), 'LineWidth', 1.5);
% end
% 
% xlabel('time');
% ylabel('position');
% title('time space diagram');
% grid on;
% hold off;

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
