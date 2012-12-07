function data = addDesiredForce(data)
%ADDDESIREDFORCE add 'desired' force contribution (towards nearest exit or
%staircase)

for fi = 1:data.floor_count

    for ai=1:length(data.floor(fi).agents)
        
        % get agent's data
        p = data.floor(fi).agents(ai).p;
        m = data.floor(fi).agents(ai).m;
        v0 = data.floor(fi).agents(ai).v0;
        v = data.floor(fi).agents(ai).v;
        numbr= data.floor(fi).agents(ai).nr;
        
        %control exit
        
         if data.control_exit==1
            
            %even agents
                if numbr==0;
            % get direction towards nearest exit
                ex = lerp2(data.floor(fi).img_dir_x_even, p(1), p(2));
                ey = lerp2(data.floor(fi).img_dir_y_even, p(1), p(2));
                e = [ex ey];
                end
                
                %odd agents
                if numbr==1;
            % get direction towards nearest exit
                ex = lerp2(data.floor(fi).img_dir_x_odd, p(1), p(2));
                ey = lerp2(data.floor(fi).img_dir_x_odd, p(1), p(2));
                e = [ex ey];
                end
        
                    
                    
        else
        
        
        
        
        % get direction towards nearest exit
        ex = lerp2(data.floor(fi).img_dir_x, p(1), p(2));
        ey = lerp2(data.floor(fi).img_dir_y, p(1), p(2));
        e = [ex ey];
        
        % get force
        Fi = m * (v0*e - v)/data.tau;
        
        % add force
        data.floor(fi).agents(ai).f = data.floor(fi).agents(ai).f + Fi;
         end
    end
end

