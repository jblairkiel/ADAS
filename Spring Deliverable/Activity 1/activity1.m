%%Imports the stereo video


stereoParams = 'StereoCalibration/stereoParameters.mat';
stereoVidLeft = 'StereoVideos/left/';
stereoVidRight = 'StereoVideos/right/';

readerLeft = vision.VideoFileReader(stereoVidLeft, 'VideoOutputDataType','uint8');
readerRight = vision.VideoFileReader(sterioVidRight, 'VideoOutputDataType','uint8');

%Set the outputVideoParams

obj = VideoReader(stereoVidLeft);
nFrames = obj.NumberofFrames;
F(1:nFrames) = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);


%Train detectors
negativeFolder = 'TrainingImages/notcars';
load positiveInstances
positiveInstances = data;
detectorFile = 'CarDetector.xml';
trainCascadeObjectDetector(detectorFile, positiveInstances, negativeFolder, 'FalseAlarmRate',0.01,'NumCascadeStages',10);
detector = visionCascadeObjectDetector(detectorFile);

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
        
        %Detect Cars
        bboxes = step(detector,frameLeftGray);
        
        % Builds a disparity map between the left and right images
        disparityMap = disparity(frameLeftGray, framerightGray);
        
        % Reconstructs the disparity map to generate a point cloud
        point3D = reconstructScene(disparityMap,stereoParams);
    
    % Uses that point cloud to find the distance to the center of the vehicle bounding box
        % To reduce noise it may be preferable to use an average of a small group of pixels at the center
        ptCloud = pcdenoise(point3D);
        ptCloud = ptCloud/1000;
        if ~isempty(bboxes)
            centroids = [round(bboxes(:,1) + bboxes(:,3)/2),round(bboxes(:,2) +bboxes(:,4)/2)];
            %Find the 3-D world coordinates
            centroidsIdx = sub2ind(size(disparityMap),centroids(:,2),centroids(:,1));
            X = point3D(:,:,1);
            Y = point3D(:,:,2);
            Z = point3D(:,:,3);
            centroids3D = [X(centroidsIdx),Y(centroidsIdx), Z(centroidsIdx)];
            
            %Distance from camera in meters
            dists = sqrt(sum(centroids3D .^2,2))/1000;
            
            %Display the detected cars and distances
            labels = cell(1,numel(dists));
            for i=1:numel(dists)
                labels{i} = sprintf('%.2f meters',dists(i));
            end
            dispFrame = insertObjectAnnotation(frameLeftRect, 'rectangle',bboxes,labels);
        
        else
            dispFrame = frameLeftRect;
        end
    % Outputs the left side source video with the following items overlaid:
        % Bounding box around the vehicle in front
        % Text above or below the bounding box stating:
            % Estimated distance to the center of the vehicle bounding box
            % Location of the vehicle bounding box center (in pixels measured relative to image center)
            % Note: text should include units and a label for each item (e.g. Distance: 20 meters)
        F(k) = im2frame(dispFrame);
end
% Outputs a figure plotting the distance to the vehicle in front throughout the duration of the video.