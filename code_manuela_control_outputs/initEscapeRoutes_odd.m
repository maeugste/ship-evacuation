function data = initEscapeRoutes_odd(data)
%INITESCAPEROUTES Summary of this function goes here
%   Detailed explanation goes here
%only odd numbered rescue boats are exits


for i=1:data.floor_count

    boundary_data = zeros(size(data.floor(i).img_wall));
    boundary_data(data.floor(i).img_wall) =  1;
%     %if (i == 1)
%         boundary_data(data.floor(i).img_exit) = -1;
%     %else
%         boundary_data(data.floor(i).img_stairs_down) = -1;
%     %end
    
if i<data.floor_exit
    boundary_data(data.floor(i).img_stairs_up) = -1;
    
elseif i>data.floor_exit
        boundary_data(data.floor(i).img_stairs_down) = -1;
        
else 
        
        temp=logical(mod(data.exit_nr,2));   %matrix in which every number which is even turns to zero, odd turns to one
    
        boundary_data(temp) = -1;      %boundary_data considers only the exits with odd numbers
        
end
    exit_dist = fastSweeping(boundary_data) * data.meter_per_pixel;
    [data.floor(i).img_dir_x_odd, data.floor(i).img_dir_y_odd] = ...
        getNormalizedGradient(boundary_data, -exit_dist);
    
    
    
end



