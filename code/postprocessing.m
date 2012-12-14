% post processing of output.mat data from simulation
% to run, you need to load the output first:
% load('output_FILENAME');

% tabula rasa
clc

% read in data from output
agents_per_floor = output.agents_per_floor;
config = output.config;
exit_left = output.exit_left;
simulation_time_real = output.simulation_time;
dt = config.dt;
deleted_agents = output.deleted_agents;


% get users screen size
screen_size = get(0, 'ScreenSize');

% agents on boat
agents_on_boat = sum(agents_per_floor(:,1:1:length(agents_per_floor)));

% check if whole simulation was performed
steps=config.duration/dt-1;
for i=1:steps
    if agents_on_boat(i)<0
        steps=i-2;
        break 
    end
end

simulation_time_sim = steps*dt;

% recalculate agents on boat
agents_on_boat = sum(agents_per_floor(:,1:1:steps));
agents_start = agents_on_boat(1);
agents_left = agents_start-agents_on_boat;

% find out t10, t50, t90, t100
t10=0;
for i=1:steps
    if agents_left(i)<agents_start/10
        t10=t10+dt;
    end
end
if t10~=0
    t10=t10+dt;
end

t50=0;
for i=1:steps
    if agents_left(i)<agents_start/2
        t50=t50+dt;
    end
end
if t50~=0
    t50=t50+dt;
end

t90=0;
for i=1:steps
    if agents_left(i)<agents_start*0.9
        t90=t90+dt;
    end
end
if t90~=0
    t90=t90+dt;
end

t99=0;
for i=1:steps
    if agents_left(i)<agents_start*0.99
        t99=t99+dt;
    end
end
if t99~=0
    t99=t99+dt;
end

t100=0;
if agents_left==agents_start
    for i=1:steps
        if agents_left(i)<agents_start
            t100=t100+dt;
        end
    end
end

% create time axis
if t100~=0
    time = [0:dt:t100];
else
    time = [0:dt:simulation_time_sim];
end
steps = length(time);

% recalculate agents on boat
agents_on_boat = sum(agents_per_floor(:,1:1:steps));
agents_start = agents_on_boat(1);
agents_left = agents_start-agents_on_boat;
agents_per_floor = agents_per_floor(:,1:1:steps);
exit_left = exit_left(:,1:1:steps);

% plot agents left over time
f1 = figure;
hold on
grid on
set(gca,'XTick',[1:1:8],'FontSize',16)
plot(time/60,agents_left/agents_start*100,'LineWidth', 2)
axis([0 8 0 100])
title(sprintf('rescued agents (of total %i agents)',agents_start));
xlabel('time [min]')
ylabel('rescued agents out of all agents [%]')

% plot agents_per_floor over time
f2 = figure;
hold on
grid on
set(gca,'XTick',[1:1:8],'FontSize',16)
list = cell(config.floor_count,1);
color = hsv(config.floor_count);
color(config.floor_exit,:) = [0 0 0];
for i=1:config.floor_count
    plot(time/60,agents_per_floor(i,:),'LineWidth', 2,'color',color(i,:))
    list{i} = [sprintf('floor %i',i)];
end
legend(list)

axis([0 8 0 800])
title(sprintf('agents per floor (of total %i agents)',agents_start));
xlabel('time [min]')
ylabel('agents per floor')

% plot free places in rescue boats over time
f3 = figure;
hold on
grid on
set(gca,'XTick',[1:1:8],'FontSize',16)
list = cell(config.exit_count/2,1);
color = hsv(config.exit_count/2);
for i=1:config.exit_count/2
    plot(time/60,exit_left(i,:),'LineWidth', 2,'color',color(i,:))
    list{i} = [sprintf('boat %i / --- %i',i,i+13)];
end
for i=config.exit_count/2+1:config.exit_count
    plot(time/60,exit_left(i,:),'--','LineWidth', 2,'color',color(i-config.exit_count/2,:))
end
legend(list)

axis([0 8 0 200])
title('rescue boat capacity');
xlabel('time [min]')
ylabel('free places on rescue boat')

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

fprintf('t_10: %f\n', t10)
fprintf('t_50: %f\n', t50)
fprintf('t_90: %f\n', t90)
fprintf('t_99: %f\n', t99)
fprintf('t_100: %f\n', t100)



