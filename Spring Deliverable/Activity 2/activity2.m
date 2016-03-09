%%Read movie to frame structure

obj = VideoReader('activity2Video.mp4');
nFrames = 0;
vidHeight = obj.Height;
vidWidth = obj.Width;

mov(1:nFrames) = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);

F(1:nFrames) = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);
v = VideoWriter('outputVideo.avi');
%%Process
h = waitbar(0,'Processing Video 0%');
while hasFrame(obj)
    nFrames = nFrames + 1;
    frame = readFrame(vidObj);
    %Applies necessary algorithms to overlay bounding boxes on stopsigns
    %Include Text below or above the box stating dimensions of box(in
    %pixels) and location of the sign center (relative to frame center) 
    
    
    
    
    writeVideo(v,pFrame);
end
close(h);
close(v);
