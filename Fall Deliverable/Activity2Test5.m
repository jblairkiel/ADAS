%% Read movie to fame structure

obj = VideoReader('binaryActivity2Video.mp4');
nFrames = obj.NumberOfFrames;
%nFrames = 50;
vidHeight = obj.Height;
vidWidth = obj.width;

diskElem = strel('disk',6);
mov(1:nFrames) = ...
    struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);

F(1:nFrames) = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);
%% Process
h = waitbar(0,'Processing Video 0%');
for k = 1 : nFrames
    perc = k/nFrames;
    waitbar(perc,h,sprintf('Processing Video %d%%',int8(perc*100)))
    frameImage = read(obj,k);
    
    %frameBW = bwareaopen(frameImage, 800);
    framegray = imopen(frameImage, diskElem);
    framegray = rgb2gray(framegray);
    frameBW = bwareaopen(framegray, 400);
    I = imdilate(frameBW, diskElem);
    I2 = imdilate(I,diskElem);
    I3 = imdilate(I2, diskElem);
    framegray = im2bw(I3, .5);
    Ibwopen = imopen(framegray, diskElem);
    hBlob = vision.BlobAnalysis('MinimumBlobArea',2500,'MaximumBlobArea',10000);
    
    
    [objArea,objCentroid,bboxOut] = step(hBlob,Ibwopen);
    Ishape = insertShape(frameImage,'rectangle',bboxOut,'Linewidth',4);
    numObj = numel(objArea);
    hTextIns = vision.TextInserter('%d','Location',[20 20], 'Color', [255 255 0], 'FontSize', 30);
    Itext = step(hTextIns,Ishape,int32(numObj));
    %F(k) = im2frame(frameImage);
    F(k) = im2frame(Ishape);
end
close(h);

%% Convert each frame to a binary image with a threshold
%implay(F)
v = VideoWriter('activity2_(The University of Alabama).avi','Uncompressed AVI');
v.FrameRate = 25;
open(v)
writeVideo(v,F);
close(v);