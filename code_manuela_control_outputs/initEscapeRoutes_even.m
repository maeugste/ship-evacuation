function data = initEscapeRoutes_even(data)
%INITESCAPEROUTES Summary of this function goes here
%   Detailed explanation goes here
%only even numbered rescue boats are exits


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
        data.floor(i).img_stairs_down;
else
   
     
        temp1=double(mod(data.exit_nr,2));   %matrix in which every number which is even turns to zero, odd turns to one
        temp2=logical((data.floor(i).img_exit)-(temp1));
        boundary_data(temp2)=-1;             %boundary_data considers only the exits with even numbers --> set -1 where those are
        
end
    exit_dist = fastSweeping(boundary_data) * data.meter_per_pixel;
    [data.floor(i).img_dir_x_even, data.floor(i).img_dir_y_even] = ...
        getNormalizedGradient(boundary_data, -exit_dist);
    
    
    
end



