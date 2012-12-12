function [ output_args ] = Untitled( input_args )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

h=figure();
vidObj=VideoWriter('video.avi');
open(vidObj);

curFrame=getframe(h);
writeVedeo(vidObj,curFrame);




close(vidObj);
end

