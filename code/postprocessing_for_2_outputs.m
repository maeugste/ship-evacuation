% post processing of output.mat data from simulation
% to run, you need to load the output first:
% load('output_FILENAME');

% tabula rasa
clc

% read in data from output a
agents_per_floor_1 = a.output.agents_per_floor;
config_1 = a.output.config;
exit_left_1 = a.output.exit_left;
simulation_time_real_1 = a.output.simulation_time;
dt_1 = config_1.dt;
deleted_agents_1 = a.output.deleted_agents;

% read in data from output b
agents_per_floor_2 = b.output.agents_per_floor;
config_2 = b.output.config;
exit_left_2 = b.output.exit_left;
simulation_time_real_2 = b.output.simulation_time;
dt_2 = config_2.dt;
deleted_agents_2 = b.output.deleted_agents;

% get users screen size
screen_size = get(0, 'ScreenSize');

% agents on boat
agents_on_boat_1 = sum(agents_per_floor_1(:,1:1:length(agents_per_floor_1)));

% agents on boat
agents_on_boat_2 = sum(agents_per_floor_2(:,1:1:length(agents_per_floor_2)));


% check if whole simulation was performed
steps=a.output.config.duration/dt_1-1;
for i=1:steps
    if agents_on_boat_1(i)<0
        steps=i-2;
        break 
    end
end

simulation_time_sim = steps*dt_1;
% create time axis

    time = [0:dt_1:simulation_time_sim];

steps = length(time);


% recalculate agents on boat
agents_on_boat_1 = sum(agents_per_floor_1(:,1:1:steps));
agents_start_1 = agents_on_boat_1(1);
agents_left_1 = agents_start_1-agents_on_boat_1;
agents_per_floor_1 = agents_per_floor_1(:,1:1:steps);
exit_left_1 = exit_left_1(:,1:1:steps);




agents_on_boat_2 = sum(agents_per_floor_2(:,1:1:steps));
agents_start_2 = agents_on_boat_2(1);
agents_left_2 = agents_start_2-agents_on_boat_2;
agents_per_floor_2 = agents_per_floor_2(:,1:1:steps);
exit_left_2 = exit_left_2(:,1:1:steps);

% plot agents left over time
f1 = figure;
hold on
grid on
set(gca,'XTick',[1:1:8],'FontSize',16)
plot(time/60,agents_left_1/agents_start_1*100,'LineWidth', 2)
hold on
plot(time/60,agents_left_2/agents_start_2*100,'LineWidth', 2)
axis([0 8 0 100])
title(sprintf('rescued agents (of total %i agents)',agents_start));
xlabel('time [min]')
ylabel('rescued agents out of all agents [%]')


% scale plots up to screen size
set(f1, 'Position', [0 0 screen_size(3) screen_size(4) ] );
set(f2, 'Position', [0 0 screen_size(3) screen_size(4) ] );
set(f3, 'Position', [0 0 screen_size(3) screen_size(4) ] );


% print out

fprintf('Timestep: %f s\n', dt)
fprintf('Steps simulated: %i\n', steps)
fprintf('Simulation time: %f min\n', simulation_time_sim/60)
fprintf('Agents on ship on start: %i\n', agents_start)
fprintf('Agents on ship on simulation end: %i\n', agents_on_boat(end))
fprintf('Agents deleted due to NaN-positions: %i\n', deleted_agents)




