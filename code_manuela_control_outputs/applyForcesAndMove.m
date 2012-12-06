function data = applyForcesAndMove(data)
%APPLYFORCESANDMOVE apply current forces to agents and move them using
%the timestep and current velocity

n_velocity_clamps = 0;

% loop over all floors higher than exit floor
for fi = data.floor_exit:data.floor_count

    % init logical arrays to indicate agents that change the floor or exit
    % the simulation
    floorchange = false(length(data.floor(fi).agents),1);
    exited = false(length(data.floor(fi).agents),1);
    
    % loop over all agents
    for ai=1:length(data.floor(fi).agents)
        % add current force contributions to velocity
        v = data.floor(fi).agents(ai).v + data.dt * ...
            data.floor(fi).agents(ai).f  / data.floor(fi).agents(ai).m;
        
        % clamp velocity
        if norm(v) > data.v_max
            v = v / norm(v) * data.v_max;
            n_velocity_clamps = n_velocity_clamps + 1;
        end
        
        % get agent's new position
        newp = data.floor(fi).agents(ai).p + ...
               v * data.dt / data.meter_per_pixel;
           
        % if the new position is inside a wall, remove perpendicular
        % component of the agent's velocity
        if lerp2(data.floor(fi).img_wall_dist, newp(1), newp(2)) < ...
                 data.floor(fi).agents(ai).r
            
            % get agent's position
            p = data.floor(fi).agents(ai).p;
            
            % get wall distance gradient (which is off course perpendicular
            % to the nearest wall)
            nx = lerp2(data.floor(fi).img_wall_dist_grad_x, p(1), p(2));
            ny = lerp2(data.floor(fi).img_wall_dist_grad_y, p(1), p(2));
            n = [nx ny];
            
            % project out perpendicular component of velocity vector
            v = v - dot(n,v)/dot(n,n)*n;
            
            % get agent's new position
            newp = data.floor(fi).agents(ai).p + ...
                   v * data.dt / data.meter_per_pixel;
        end
        
        % check if agents position is ok
        % repositioning after 50 times clogging
        % deleting if agent has a NaN position
        if ~isnan(newp)
            if data.floor(fi).img_wall(round(newp(1)), round(newp(2)))
               newp = data.floor(fi).agents(ai).p;
               v = [0 0];
               data.floor(fi).agents(ai).clogged = data.floor(fi).agents(ai).clogged + 1;
               fprintf('WARNING: clogging agent %i on floor %i (%i). Position (%f,%f).\n',ai,fi,data.floor(fi).agents(ai).clogged,newp(1),newp(2))
               if data.floor(fi).agents(ai).clogged >= 40
                    nx = rand(1)*2 - 1;
                    ny = rand(1)*2 - 1;
                    n = [nx ny];
                    v = n*data.v_max/2;
                    fprintf('WARNING: agent %i on floor %i velocity set random to get out of wall. Position (%f,%f).\n',ai,fi,newp(1),newp(2))
                   
                   % get agent's new position
                   newp = data.floor(fi).agents(ai).p + ...
                   v * data.dt / data.meter_per_pixel;
                   if isnan(newp)
                        % get rid of disturbing agent
                        fprintf('WARNING: position of an agent is NaN! Deleted this agent.\n')
                        exited(ai) = 1;
                        data.agents_exited = data.agents_exited +1;
                        data.output.deleted_agents=data.output.deleted_agents+1;
                        newp = [1 1];
                   end
               end
            end 
        else
            % get rid of disturbing agent
            fprintf('WARNING: position of an agent is NaN! Deleted this agent.\n')
            exited(ai) = 1;
            data.agents_exited = data.agents_exited +1;
            data.output.deleted_agents=data.output.deleted_agents+1;
            newp = [1 1];
        end
        
        
        % update agent's velocity and position
        data.floor(fi).agents(ai).v = v;
        data.floor(fi).agents(ai).p = newp;
        
        % reset forces for next timestep
        data.floor(fi).agents(ai).f = [0 0];
        
        % check if agent reached a staircase down and indicate floor change
        if data.floor(fi).img_stairs_down(round(newp(1)), round(newp(2)))
            floorchange(ai) = 1;
        end
        
        % check if agent reached an exit
        if data.floor(fi).img_exit(round(newp(1)), round(newp(2)))
            exited(ai) = 1;
            data.agents_exited = data.agents_exited +1;
            
%             fprintf('agent exited from upper loop\n');
           
            %save current exit nr
            data.current_exit = data.exit_nr(round(newp(1)), round(newp(2)));
            
%             fprintf(int2str(data.current_exit));
            
            %update exit_left
            data.exit_left(1,data.current_exit) = data.exit_left(1,data.exit_nr(round(newp(1)), round(newp(2)))) - 1;
          
            %close exit if there is no more free space
            if data.exit_left(1,data.current_exit) < 1
            
                %change current exit to wall
                data.floor(data.floor_exit).img_wall = data.floor(data.floor_exit).img_wall == 1 ...
                              | (data.exit_nr == (data.current_exit));
                data.floor(data.floor_exit).img_exit = data.floor(data.floor_exit).img_exit == 1 ...
                              & (data.exit_nr ~= (data.current_exit));
                          
                %redo initEscapeRoutes and initWallForces with new exit and wall parameters
                data = initEscapeRoutes(data);
                data = initWallForces(data);
                
%                 fprintf('new routes from upper loop\n');
                
            end
        end
    end
    
    % add appropriate agents to next lower floor
    if fi > data.floor_exit
        data.floor(fi-1).agents = [data.floor(fi-1).agents data.floor(fi).agents(floorchange)];
    end
    
    % delete these and exited agents
    data.floor(fi).agents = data.floor(fi).agents(~(floorchange|exited));
end





% loop over all floors lower than exit floor
for fi = 1:data.floor_exit

    % init logical arrays to indicate agents that change the floor or exit
    % the simulation
    floorchange = false(length(data.floor(fi).agents),1);
    exited = false(length(data.floor(fi).agents),1);
    
    % loop over all agents
    for ai=1:length(data.floor(fi).agents)
        % add current force contributions to velocity
        v = data.floor(fi).agents(ai).v + data.dt * ...
            data.floor(fi).agents(ai).f  / data.floor(fi).agents(ai).m;
        
        % clamp velocity
        if norm(v) > data.v_max
            v = v / norm(v) * data.v_max;
            n_velocity_clamps = n_velocity_clamps + 1;
        end
        
        % get agent's new position
        newp = data.floor(fi).agents(ai).p + ...
               v * data.dt / data.meter_per_pixel;
           
        % if the new position is inside a wall, remove perpendicular
        % component of the agent's velocity
        if lerp2(data.floor(fi).img_wall_dist, newp(1), newp(2)) < ...
                 data.floor(fi).agents(ai).r
            
            % get agent's position
            p = data.floor(fi).agents(ai).p;
            
            % get wall distance gradient (which is of course perpendicular
            % to the nearest wall)
            nx = lerp2(data.floor(fi).img_wall_dist_grad_x, p(1), p(2));
            ny = lerp2(data.floor(fi).img_wall_dist_grad_y, p(1), p(2));
            n = [nx ny];
            
            % project out perpendicular component of velocity vector
            v = v - dot(n,v)/dot(n,n)*n;
            
            % get agent's new position
            newp = data.floor(fi).agents(ai).p + ...
                   v * data.dt / data.meter_per_pixel;
        end
        
        
        % check if agents position is ok
        % repositioning after 50 times clogging
        % deleting if agent has a NaN position
        if ~isnan(newp)
            if data.floor(fi).img_wall(round(newp(1)), round(newp(2)))
               newp = data.floor(fi).agents(ai).p;
               v = [0 0];
               data.floor(fi).agents(ai).clogged = data.floor(fi).agents(ai).clogged + 1;
               fprintf('WARNING: clogging agent %i on floor %i (%i). Position (%f,%f).\n',ai,fi,data.floor(fi).agents(ai).clogged,newp(1),newp(2))
               if data.floor(fi).agents(ai).clogged >= 40
                    nx = rand(1)*2 - 1;
                    ny = rand(1)*2 - 1;
                    n = [nx ny];
                    v = n*data.v_max/2;
                    fprintf('WARNING: agent %i on floor %i velocity set random to get out of wall. Position (%f,%f).\n',ai,fi,newp(1),newp(2))
                   
                   % get agent's new position
                   newp = data.floor(fi).agents(ai).p + ...
                   v * data.dt / data.meter_per_pixel;
                   if isnan(newp)
                        % get rid of disturbing agent
                        fprintf('WARNING: position of an agent is NaN! Deleted this agent.\n')
                        exited(ai) = 1;
                        data.agents_exited = data.agents_exited +1;
                        data.output.deleted_agents=data.output.deleted_agents+1;
                        newp = [1 1];
                   end
               end
            end 
        else
            % get rid of disturbing agent
            fprintf('WARNING: position of an agent is NaN! Deleted this agent.\n')
            exited(ai) = 1;
            data.agents_exited = data.agents_exited +1;
            data.output.deleted_agents=data.output.deleted_agents+1;
            newp = [1 1];
        end
        
        % update agent's velocity and position
        data.floor(fi).agents(ai).v = v;
        data.floor(fi).agents(ai).p = newp;
        
        % reset forces for next timestep
        data.floor(fi).agents(ai).f = [0 0];
        
        % check if agent reached a staircase up and indicate floor change
        if data.floor(fi).img_stairs_up(round(newp(1)), round(newp(2)))
            floorchange(ai) = 1;
        end
        
        % check if agent reached an exit
        if data.floor(fi).img_exit(round(newp(1)), round(newp(2)))
            exited(ai) = 1;
            data.agents_exited = data.agents_exited +1;
            
%             fprintf('agent exited from lower loop\n');
            
            %save current exit nr
            data.current_exit = data.exit_nr(round(newp(1)), round(newp(2)));
                       
            %update exit_left
            data.exit_left(1,data.current_exit) = data.exit_left(1,data.exit_nr(round(newp(1)), round(newp(2)))) - 1;
          
                        %close exit if there is no more free space
            if data.exit_left(1,data.current_exit) < 1
            
                %change current exit to wall
                data.floor(data.floor_exit).img_wall = data.floor(data.floor_exit).img_wall == 1 ...
                              | (data.exit_nr == (data.current_exit));
                data.floor(data.floor_exit).img_exit = data.floor(data.floor_exit).img_exit == 1 ...
                              & (data.exit_nr ~= (data.current_exit));
                          
                %redo initEscapeRoutes and initWallForces with new exit and wall parameters
                data = initEscapeRoutes(data);
                data = initWallForces(data);    
                
%                 fprintf('new routes from lower loop\n');
                
            end
        
        end
    end
    
    % add appropriate agents to next lower floor
    if fi < data.floor_exit
        data.floor(fi+1).agents = [data.floor(fi+1).agents ...
                                   data.floor(fi).agents(floorchange)];
    end
    
    % delete these and exited agents
    data.floor(fi).agents = data.floor(fi).agents(~(floorchange|exited));
end

% if n_velocity_clamps > 0
%     fprintf(['WARNING: clamped velocity of %d agents, ' ...
%             'possible simulation instability.\n'], n_velocity_clamps);
% end