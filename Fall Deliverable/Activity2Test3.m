%% Start

squareElem = strel('square',6);
channel1Min = 0.398;
channel1Max = 0.498;
channel2Min = 0.355;
channel2Max = 1.000;
channel3Min = 0.000;
channel3Max = 1.000;



%% Read movie to fame structure

obj = VideoReader('binaryActivity2Video.mp4');
%nFrames = obj.NumberOfFrames;
nFrames = 50;
vidHeight = obj.Height;
vidWidth = obj.width;

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
    framegray = imopen(frameImage, squareElem);
    framegray = rgb2gray(framegray);
    frameBW = bwareaopen(framegray, 1300);
    I2 = imdilate(frameBW,squareElem);
    I3 = imdilate(I2, squareElem);
    framegray = im2bw(I3, .5);
    Ibwopen = imopen(framegray, squareElem);
    hBlob = vision.BlobAnalysis('MinimumBlobArea',3500,'MaximumBlobArea',10000);
    
    
    [objArea,objCentroid,bboxOut] = step(hBlob,Ibwopen);
    Ishape = insertShape(frameImage,'rectangle',bboxOut,'Linewidth',4);
    numObj = numel(objArea);
    hTextIns = vision.TextInserter('%d','Location',[20 20], 'Color', [255 255 0], 'FontSize', 30);
    Itext = step(hTextIns,Ishape,int32(numObj));
    %F(k) = im2frame(frameImage);
    F(k) = im2frame(Itext);
end
close(h);

%% Convert each frame to a binary image with a threshold
%implay(F)
movie2avi(F,'Activity2Solution.avi','Compression','None')