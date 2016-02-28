%%Imports the stereo video

load('stereoCalibrationParams.mat');

stereoVidLeft = 'stereoVidLeft.mp4';
stereoVidRight = 'stereoVidRight.mp4';

readerLeft = vision.VideoFileReader(stereoVidLeft, 'VideoOutputDataType','uint8');
readerRight = vision.VideoFileReader(sterioVidRight, 'VideoOutputDataType','uint8');

%Set the outputVideoParams
obj = VideoReader(stereoVidLeft);
nFrames = obj.NumberofFrames;

%Read and Rectify Video Frames
frameLeft = readerLeft.step();
frameRight = readerRight.step();

[frameLeftRect, frameRightRect] = rectifyStereoImages(frameLeft,frameRight,stereoParams);

%Disparity
frameLeftGray = rbg2gray(frameLeftRect);
frameRightGray = rgb2gray(frameRightRect);

disparityMap = disparity(frameLeftGray,frameRightGray);

%Reconstruct 3-D Scene
point3D = reconstructScene(disparityMap,stereoParams);

z = point3D(:,:,3);
z(z<0|Z>8000) = NaN;
point3D(:,:,3) = z;

    %showPointCloud(point3D,frameLeftRect,'VerticalAxis','Y','VerticalAxisDir','Down');
    
%Identifies the vehicle directly in front and draws a bounding box around this vehicle
for k = 1 : nFrames
    perc = k/nFrames;
    waitbar(perc,h,sprintf('Processing Video %d%%',int8(perc*100)));

    % Uses the stereo video to estimate the distance to the vehicle in front:
        frameLeft = readerLeft.step();
        frameRight = readerRight.step();
        
        %Rectifies each stereo frame to ensure the left and right images are aligned
        [frameLeftrect, frameRightRect] = rectifyStereoImages(frameLeft, frameRight, stereoParams);
        frameLeftGray = rgb2gray(frameLeftRect);
        frameRightGray = rgb2gray(frameRightRect);
        
        % Builds a disparity map between the left and right images
        disparityMap = disparity(frameLeftGray, framerightGray);
        
        % Reconstructs the disparity map to generate a point cloud
        point3D = reconstructScene(disparityMap,stereoParams);
    
    % Uses that point cloud to find the distance to the center of the vehicle bounding box
        % To reduce noise it may be preferable to use an average of a small group of pixels at the center
        ptCloud = pcdenoise(point3D);
        
    % Outputs the left side source video with the following items overlaid:
        % Bounding box around the vehicle in front
        % Text above or below the bounding box stating:
            % Estimated distance to the center of the vehicle bounding box
            % Location of the vehicle bounding box center (in pixels measured relative to image center)
            % Note: text should include units and a label for each item (e.g. Distance: 20 meters)
end
% Outputs a figure plotting the distance to the vehicle in front throughout the duration of the video.