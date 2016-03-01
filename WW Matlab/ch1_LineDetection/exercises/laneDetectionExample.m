%% Lane Detection Example
% Detect the lines of lanes using the hough transform

% Copyright 2015-2016 The MathWorks

%%
clc
clear
close all

%% Initialize System Objects
% Create a VideoFileReader System object to read video from a file.
VR = vision.VideoFileReader('viplanedeparture.avi');
% Create a VideoPlayer System object to visualize video
VP = vision.VideoPlayer;

%% Initialize Data
idx = 0;
x= 0; 
y= 0;
%% Loop through each frame and find lines
while(~isDone(VR))
    idx = idx + 1;
    
    % Acquire next frame
    frame = step(VR);
    
	%% Extract lower portion of image
    nr = size(frame,1);
    frameLH = frame(7*nr/16:end,:,:);

    %% Create Mask Using ImageFilter and Autothresholding
    % convert colorspace from rgb to grayscale
    grayframe = rgb2gray(frameLH);
    % apply an image filter to extract vertical edges
    hFilter2D = vision.ImageFilter( ...
                        'Coefficients', [-1 0 1], ...
                        'OutputSize', 'Same as first input', ...
                        'PaddingMethod', 'Replicate', ...
                        'Method', 'Correlation');
    filteredFrame = step(hFilter2D,grayframe);
    % auto threshold the image
    hAutothreshold = vision.Autothresholder;
    BM = step(hAutothreshold, filteredFrame);
    % Apply a skeleton morphology to get the thinnest lines
    BM = bwmorph(BM,'skel',Inf);

    %% Perform Hough Transform
    [H, Theta, Rho] = hough(BM);
	
    %% Identify Peaks in Hough Transform
    Peaks  = houghpeaks(H,30,'threshold',ceil(0.3*max(H(:))));

    %% Extract lines from hough transform and peaks
    lines = houghlines(BM,Theta,Rho,Peaks,'FillGap',80,'MinLength',7);

    %% Overlay lines and view results
    xy = zeros(length(lines),4);
    for lidx = 1:length(lines)
        xy(lidx,:) = [lines(lidx).point1 lines(lidx).point2];  
    end
    frame2 = insertShape(frameLH,'Line',xy,'Color','green','LineWidth',1);
	% Update video player
    step(VP,frame2); 
end
frameDisplay = frame;