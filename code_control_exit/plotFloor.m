function plotFloor(data, floor_idx)

if floor_idx == data.floor_exit-1 || floor_idx == data.floor_exit || floor_idx == data.floor_exit+1
    h=subplot(data.floor(floor_idx).building_plot);
       
set(h, 'position',[0,0.35+0.65/3*(floor_idx-data.floor_exit+1),1,0.65/3-0.005]);

hold off;
% the building image
imagesc(data.floor(floor_idx).img_plot);
hold on;

%plot options
colormap(data.color_map);
axis equal;
axis manual; %do not change axis on window resize

set(h, 'Visible', 'off')
% title(sprintf('floor %i', floor_idx))

% plot agents
if ~isempty(data.floor(floor_idx).agents)
    ang = [linspace(0,2*pi, 10) nan]';
    rmul = [cos(ang) sin(ang)] * data.pixel_per_meter;
    draw = cell2mat(arrayfun(@(a) repmat(a.p,length(ang),1) + a.r*rmul, ...
           data.floor(floor_idx).agents, 'UniformOutput', false)');
    line(draw(:,2), draw(:,1), 'Color', 'r');
end

hold off;
end
end
