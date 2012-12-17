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
data = initEscapeRoutes(data);
fprintf('Init wall forces...\n');
data = initWallForces(data);
fprintf('Init agents...\n');
data = initAgents(data);

% maximum influence of agents on each other

data.r_influence = data.pixel_per_meter * ...
    fzero(@(r) data.A * exp((2*data.r_max-r)/data.B) - 1e-4, data.r_max);

fprintf('Init plots...\n');
% get users screen size
screen_size = get(0, 'ScreenSize');


%init the plots
%exit plot
data.figure_exit=figure;

% scale plot up to screen size
set(data.figure_exit, 'Position', [0 0 screen_size(3) screen_size(4) ] );

hold on;
axis([0 data.duration 0 data.total_agent_count]);
title(sprintf('agents that reached the exit (total agents: %i)', data.total_agent_count));

% floors plot
data.figure_floors=figure;

% scale plot up to screen size
set(data.figure_floors, 'Position', [0 0 screen_size(3) screen_size(4) ] );

% figure('units','normalized','outerposition',[0 0 1 1])
data.figure_floors_subplots_w = data.floor_count+1;
data.figure_floors_subplots_h = 4;
for i=1:config.floor_count
        data.floor(i).agents_on_floor_plot = subplot(data.figure_floors_subplots_h, data.figure_floors_subplots_w, 3*data.floor_count - i+3 + data.figure_floors_subplots_w);
        if i == config.floor_exit - 1
            data.floor(i).building_plot = subplot(data.figure_floors_subplots_h, data.figure_floors_subplots_w, [(2*config.floor_count+1)+2:3*config.floor_count]+3);
            text(0,0,sprintf('%i', i));
        elseif i == config.floor_exit
            data.floor(i).building_plot = subplot(data.figure_floors_subplots_h, data.figure_floors_subplots_w, [(config.floor_count+1)+1:2*config.floor_count]+2);
        elseif i == config.floor_exit + 1
            data.floor(i).building_plot = subplot(data.figure_floors_subplots_h, data.figure_floors_subplots_w, [1:config.floor_count+1]);
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
data.video_file_name = ['video_hq_' data.frame_basename '.avi'];

% set deleted_agents to zero
data.output.deleted_agents = 0;


