function data = initialize(config)
% initialize the internal data from the config data
%
%  arguments:
%   config      data structure from loadConfig()
%
%  return:
%   data        data structure: all internal data used for the main loop
%
%               all internal data is stored in pixels NOT in meters


data = config;

%for convenience
data.pixel_per_meter = 1/data.meter_per_pixel;

fprintf('Init escape routes...\n');
if data.control_exit~=1
    data = initEscapeRoutes(data);
    
    %control exits
   
   
    
    
else 
    
    data = initEscapeRoutes_even(data);
    data = initEscapeRoutes_odd(data);
end

fprintf('Init wall forces...\n');
data = initWallForces(data);
fprintf('Init agents...\n');
data = initAgents(data);

% maximum influence of agents on each other

data.r_influence = data.pixel_per_meter * ...
    fzero(@(r) data.A * exp((2*data.r_max-r)/data.B) - 1e-4, data.r_max);

fprintf('Init plots...\n');
%init the plots
%exit plot
data.figure_exit=figure;
hold on;
axis([0 data.duration 0 data.total_agent_count]);
title(sprintf('agents that reached the exit (total agents: %i)', data.total_agent_count));

% floors plot
data.figure_floors=figure;
% figure('units','normalized','outerposition',[0 0 1 1])
data.figure_floors_subplots_w = data.floor_count;
data.figure_floors_subplots_h = 4;
for i=1:config.floor_count
        data.floor(i).agents_on_floor_plot = subplot(data.figure_floors_subplots_h, data.figure_floors_subplots_w, 3*data.floor_count - i+1 + data.figure_floors_subplots_w);
        if i == config.floor_exit - 1
            data.floor(i).building_plot = subplot(data.figure_floors_subplots_h, data.figure_floors_subplots_w, [(2*config.floor_count+1):3*config.floor_count]);
        elseif i == config.floor_exit
            data.floor(i).building_plot = subplot(data.figure_floors_subplots_h, data.figure_floors_subplots_w, [(config.floor_count+1):2*config.floor_count]);
        elseif i == config.floor_exit + 1
            data.floor(i).building_plot = subplot(data.figure_floors_subplots_h, data.figure_floors_subplots_w, [1:config.floor_count]);
        end
end

% init output matrizes
data.output = struct;
data.output.config = config;
data.output.agents_per_floor = ones(data.floor_count,data.duration/data.dt).*(-1);
data.output.exit_left = zeros(data.exit_count,data.duration/data.dt);

% prepare output file name
data.output_file_name = ['output_' data.frame_basename];

% prepare video file name
data.video_file_name = ['video_' data.frame_basename '.avi'];

% set deleted_agents to zero
data.output.deleted_agents = 0;



