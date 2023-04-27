v0 = 3; % free flow velocity
pj = 11.77; % density jam
p = 0:0.1:pj; % range of densities

Q = v0 * (1 - p/pj) .* p; % flow based on greenshields
v = v0 * (1 - p/pj); % velocity based on greenshields

pc = pj/2; % critical density
Qmax = v0 * pj/4; % maximum flow

figure;

subplot(3, 1, 1);
plot(p, v, 'o');
xlabel('Density');
ylabel('Average Velocity');
title('Density vs Average Velocity');
ylim([0, 4])
grid on;

subplot(3, 1, 2);
plot(p, Q, 'o');
xlabel('Density');
ylabel('Flow');
title('Density vs Flow');
grid on;

subplot(3, 1, 3);
plot(Q, v, 'o');
ylabel('Average Velocity');
xlabel('Flow');
title('Flow vs Velocity');
ylim([0, 4])
grid on;

% subplot(1, 3, 1);
% plot(p, v, 'o');
% xlabel('Density');
% ylabel('Average Velocity');
% title('Density vs Average Velocity');
% ylim([0, 4])
% grid on;
% 
% subplot(1, 3, 2);
% plot(p, Q, 'o');
% xlabel('Density');
% ylabel('Flow');
% title('Density vs Flow');
% grid on;
% 
% subplot(1, 3, 3);
% plot(Q, v, 'o');
% ylabel('Average Velocity');
% xlabel('Flow');
% title('Flow vs Velocity');
% grid on;
