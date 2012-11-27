function simulate(config_file)
% run this to start the simulation

if nargin==0
    config_file='../data/config1.conf';
end

fprintf('Load config file...\n');
config = loadConfig(config_file);

data = initialize(config);

data.step = 1;
data.time = 0;
fprintf('Start simulation...\n');

% tic until simulation end
simstart = tic;

%make video while simulation
if data.save_frames==1
           vidObj=VideoWriter(data.video_file_name);
           open(vidObj);
        end

while (data.time < data.duration)
    % tic until timestep end
    tstart=tic;
    data = addDesiredForce(data);
    data = addWallForce(data);
    data = addAgentRepulsiveForce(data);
    data = applyForcesAndMove(data);
    
    % dump agents_per_floor to output
    for floor=1:data.floor_count
          data.output.agents_per_floor(floor,data.step) = length(data.floor(floor).agents);
    end
    
    % dump exit_left to output
    data.output.exit_left(:,data.step) = data.exit_left';
       
    if mod(data.step,data.save_step) == 0
        
        % do the plotting
        set(0,'CurrentFigure',data.figure_floors);
        for floor=1:data.floor_count
            plotAgentsPerFloor(data, floor);
            plotFloor(data, floor);
        end

        if data.save_frames==1
%             print('-depsc2',sprintf('frames/%s_%04i.eps', ...
%                 data.frame_basename,data.step), data.figure_floors);

%          make video while simulate   
            currFrame=getframe(data.figure_floors);
            writeVideo(vidObj,currFrame);
            
        end
        
        set(0,'CurrentFigure',data.figure_exit);
        plotExitedAgents(data);
        
        if data.agents_exited == data.total_agent_count
            fprintf('All agents are now saved (or are they?). Time: %.2f sec\n', data.time);
            fprintf('Total Agents: %i\n', data.total_agent_count);
            
            print('-depsc2',sprintf('frames/exited_agents_%s.eps', ...
                data.frame_basename), data.figure_floors);
            break;
        end
        
        % toc of timestep
        data.telapsed = toc(tstart);
        % toc of whole simulation
        data.output.simulation_time = toc(simstart);
                
        % save output  
        output = data.output;
        save(data.output_file_name,'output')
        fprintf('Frame %i done (took %.3fs; %.3fs out of %.3gs simulated).\n', data.step, data.telapsed, data.time, data.duration);
        
    end
    
    % update step
    data.step = data.step+1;
    
    % update time
    if (data.time + data.dt > data.duration)
        data.dt = data.duration - data.time;
        data.time = data.duration;
    else
        data.time = data.time + data.dt;
    end
    
end

%make video while simulation
close(vidObj);

% toc of whole simulation
data.output.simulation_time = toc(simstart);

% save complete simulation
output = data.output;
save('output','output')
fprintf('Simulation done in %i seconds and saved data to output file.\n', data.output.simulation_time);


