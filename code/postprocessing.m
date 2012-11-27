% post processing of output.mat data from simulation
% to run, you need to load the output first:
% load('output_FILENAME');


% read in data from output
agents_per_floor = output.agents_per_floor;
config = output.config;
exit_left = output.exit_left;
simulation_time_real = output.simulation_time;
dt = config.dt;

% agents on boat
agents_on_boat = sum(agents_per_floor(:,1:1:length(agents_per_floor)));

% check if whole simulation was performed
steps=config.duration/dt;
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
t10=-1;
for i=1:steps
    if agents_left>agents_start/10
        t10=steps*dt
        break
    end
end

t50=-1;
for i=1:steps
    if agents_left>agents_start/2
        t50=steps*dt
        break
    end
end

t90=-1;
for i=1:steps
    if agents_left>agents_start*0.9
        t90=steps*dt
        break
    end
end

t100=-1;
for i=1:steps
    if agents_left==agents_start
        t100=steps*dt
        break
    end
end

% create time axis
if t100~=-1
    time = [0:dt:t100];
else
    time = [0:dt:simulation_time_sim];
end
steps = length(time);

% recalculate agents on boat
agents_on_boat = sum(agents_per_floor(:,1:1:steps));
agents_start = agents_on_boat(1);
agents_left = agents_start-agents_on_boat;

% plot agents left over time
agents_left_over_time = figure
hold on
grid on
set(gca,'FontSize',16)
plot(time,agents_left/agents_start*100,'LineWidth', 2)
axis([0 time(end) 0 agents_left(end)/agents_start*100])
title('rescued agents');
xlabel('time [s]')
ylabel('rescued agents out of all agents [%]')
