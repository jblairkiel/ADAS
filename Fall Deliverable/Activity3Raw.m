%% Initialize Variables
rows = 240;
columns = 320;
boxTopEdge = 400;
boxBottomEdge = 820;
boxLeftEdge = 0;
boxRightEdge = 1920;
grayImage = zeros(rows, columns, 'uint8');
leftTriXCoords = [0 0 700];
leftTriYCoords = [0 550 20];
rightTriXCoords = [850 1920 1920];
rightTriYCoords = [0 0 1080];
yellowhueThresholdLow = 0.0;
yellowhueThresholdHigh = 0.45;
yellowsaturationThresholdLow = 0.247;
yellowsaturationThresholdHigh = 1.0;
yellowvalueThresholdLow = .6;
yellowvalueThresholdHigh = 1.0;
whitehueThresholdLow = 0;
whitehueThresholdHigh = 0;
whitesaturationThresholdLow = 0;
whitesaturationThresholdHigh = 0;
whitevalueThresholdLow = .575;
whitevalueThresholdHigh = 1;


%% Read movie to a frame structure
[obj,pathname] = uigetfile({'*.avi';'*.mp4';'*.*';},'File Selector');
obj = VideoReader(obj);
nFrames = obj.NumberOfFrames;
%nFrames = 50;
vidHeight = obj.Height;
vidWidth = obj.Width;

%% Create Masks and Data Structures
%leftTriImage = zeros(vidHeight, vidWidth, 'uint8');
%mask = poly2mask(leftTriXCoords, leftTriYCoords, vidHeight, vidWidth);
%leftTriImage(~mask) = 255;
%rightTriImage = zeros(vidHeight, vidWidth, 'uint8');
%mask = poly2mask(rightTriXCoords, rightTriYCoords, vidHeight, vidWidth);
%rightTriImage(~mask) = 255;
boxImage = false(vidHeight, vidWidth);
[x,y] = meshgrid(1:vidWidth, 1:vidHeight);
boxImage((y>boxTopEdge) & (y<boxBottomEdge) & (x<boxRightEdge) & (x>boxLeftEdge)) = true;

mov(1:nFrames) = ...
    struct('cdata',zeros(vidHeight,vidWidth, 3,'uint8'),...
           'colormap',[]);
       
F(1:nFrames) = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);
%% Process video one frame at a time  
h = waitbar(0,'Processing Video 0%');
for k = 1 : nFrames
    perc = k/nFrames;
    waitbar(perc,h,sprintf('Processing Video %d%%',int8(perc*100)))
    frameImage = read(obj,k);
    frameImage(~boxImage) = 0;
    %frameImage(~leftTriImage) = 0;
    %frameImage(~rightTriImage) = 0;
    hsvImage = rgb2hsv(frameImage);
    hImage = hsvImage(:,:,1);
    sImage = hsvImage(:,:,2);
    vImage = hsvImage(:,:,3);
    
    if (k == 1)
        onehsvImage = hsvImage;
        oneHImage = hsvImage(:,:,1);
        oneSImage = hsvImage(:,:,2);
        oneVImage = hsvImage(:,:,3);
        
    end
    whitehueMask = (hImage >= whitehueThresholdLow) & (hImage <= whitehueThresholdHigh);
    whitesaturationMask = (sImage >= whitesaturationThresholdLow) & (sImage <= whitesaturationThresholdHigh);
    whitevalueMask = (vImage >= whitevalueThresholdLow) & (vImage <= whitevalueThresholdHigh);
    %yellowhueMask = (hImage >= yellowhueThresholdLow) & (hImage <= yellowhueThresholdHigh);
	%yellowsaturationMask = (sImage >= yellowsaturationThresholdLow) & (sImage <= yellowsaturationThresholdHigh);
    %yellowvalueMask = (vImage >= yellowvalueThresholdLow) & (vImage <= yellowvalueThresholdHigh);
    
    
    %moreEdit = bwareaopen(yellowvalueMask,250);
    moreEdit2 = bwareaopen(whitevalueMask,250);

    
    %yellowObjectsMask = uint8(yellowhueMask & yellowsaturationMask & yellowvalueMask);
    %yellowObjectsMask = bwareaopen(yellowObjectsMask,150);
   
    whiteObjectsMask = uint8(whitehueMask & whitesaturationMask & whitevalueMask);
    whiteObjectsMask = bwareaopen(whiteObjectsMask,150);
    
    if (k == 150)
        %oneyellow = yellowObjectsMask;
        onewhite = whiteObjectsMask;
    end
    moreEdit2(~boxImage) = 0;
    %moreEdit2(~rightTriImage) = 0;
    %moreEdit2(~leftTriImage) = 0;
    moreEdit2 = edge(moreEdit2,'prewitt');
    moreEdit2 = repmat(uint8(moreEdit2).*255, [1 1 3]);
    F(k) = im2frame(moreEdit2);
    
end
close(h);


%% Convert each frame to a binary image with a threshold
%implay(F)
v = VideoWriter('activity3_(The University of Alabama).avi','Uncompressed AVI');
v.FrameRate = 25;
open(v)
writeVideo(v,F);
close(v);
h = msgbox('Activity 3 Program Complete');
%movie2avi(F,'Activity3SolutionLastOne.avi','Compression','None')