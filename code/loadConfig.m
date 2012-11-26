function config = loadConfig(config_file)
% load the configuration file
%
%  arguments:
%   config_file     string, which configuration file to load
%


% get the path from the config file -> to read the images
config_path = fileparts(config_file);
if strcmp(config_path, '') == 1
    config_path = '.';
end

fid = fopen(config_file);
input = textscan(fid, '%s=%s');
fclose(fid);

keynames = input{1};
values = input{2};

%convert numerical values from string to double
v = str2double(values);
idx = ~isnan(v);
values(idx) = num2cell(v(idx));

config = cell2struct(values, keynames);


% read the images
for i=1:config.floor_count
    
    %building structure
    file = config.(sprintf('floor_%d_build', i));
    file_name = [config_path '/' file];
    img_build = imread(file_name);
    
    % decode images
    config.floor(i).img_wall = (img_build(:, :, 1) ==   0 ...
                              & img_build(:, :, 2) ==   0 ...
                              & img_build(:, :, 3) ==   0);
                          
    config.floor(i).img_spawn = (img_build(:, :, 1) == 255 ...
                               & img_build(:, :, 2) ==   0 ...
                               & img_build(:, :, 3) == 255);

%second possibility: 
%pixel is exit if 1-->0, 3-->0, and if 2 is between 255 and 230 or if no
%red or blue

    config.floor(i).img_exit = (img_build(:, :, 1) ==   0 ...
                              & img_build(:, :, 2) ~=   0 ...
                              & img_build(:, :, 3) ==   0);

                         
    config.floor(i).img_stairs_up = (img_build(:, :, 1) == 255 ...
                                   & img_build(:, :, 2) ==   0 ...
                                   & img_build(:, :, 3) ==   0);
                               
    config.floor(i).img_stairs_down = (img_build(:, :, 1) ==   0 ...
                                     & img_build(:, :, 2) ==   0 ...
                                     & img_build(:, :, 3) == 255);
                                 
                                 
    if i == config.floor_exit
        
        %make the exit_nr matrix where the number of exit is indicated in each
        %pixel

        %make a zeroes matrix as big as img_exit
        config.exit_nr=zeros(size(config.floor(config.floor_exit).img_exit)); 

        %make a zeros vector as long as floor_exit
        config.exit_left = zeros(1,config.exit_count);

        %loop over all exits
        for e=1:config.exit_count 
    
            %build the exit_nr matrix
            config.exit_nr = config.exit_nr + e*( img_build(:, :, 1) == 0 & img_build(:, :, 2) == (256-e) & img_build(:, :, 3) == 0 ) ;
  
            %build the exit_left matrix
            config.exit_left(1,e) = config.(sprintf('exit_%d_nr', e));
  
        end  
    end
                                 
    %init the plot image here, because this won't change
    config.floor(i).img_plot = 5*config.floor(i).img_wall ...
        + 4*config.floor(i).img_stairs_up ...
        + 3*config.floor(i).img_stairs_down ...
        + 2*config.floor(i).img_exit ...
        + 1*config.floor(i).img_spawn;
    config.color_map = [1 1 1; 0.9 0.9 0.9; 0 1 0; 0.4 0.4 1; 1 0.4 0.4; 0 0 0];
end

