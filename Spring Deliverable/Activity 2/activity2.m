%% Init VideoReader
obj = VideoReader('activity2Video.mp4');
nFrames = obj.NumberOfFrames;
vidHeight = obj.Height;
vidWidth = obj.Width;

%% Init CascadeOjectDetector
negativeFolder = 'non stop sign images';
load positiveInstances.mat
detectorFile = 'StopSignDetector.xml';
trainCascadeObjectDetector(detectorFile,positiveInstances,negativeFolder,'FalseAlarmRate',0.01,'NumCascadeStages',10);
detector = vision.CascadeObjectDetector(detectorFile);

%% Init Movie Structure
v = VideoWriter('outputVideo.avi');
open(v);

%% Process
h = waitbar(0,'Processing Video 0%');
for k=1:nFrames
    %Applies necessary algorithms to overlay bounding boxes on stopsigns
    %Include Text below or above the box stating dimensions of box(in
    %pixels) and location of the sign center (relative to frame center)   
    perc = k/nFrames;
    waitbar(perc,h,sprintf('Processing Video %d%%',int8(perc*100)));
    frame = read(obj,k);
    bbox = step(detector,frame);
    if bbox
        data = strcat(int2str(bbox(3)),'x',int2str(bbox(4)),' | ',int2str(bbox(1)-960),',',int2str(bbox(2)-540));
    else
        data = '';
    end
    stopSignsLabels = insertObjectAnnotation(frame,'rectangle',bbox,data);

    writeVideo(v,stopSignsLabels);
    k = k+1;
end
close(h);
close(v);
