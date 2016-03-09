clc
clear
close all

%% Try to perform the same task with a video
LeftImages = imageSet(fullfile(returnTrainingPath,'media','RecordedImages','left'));
RightImages = imageSet(fullfile(returnTrainingPath,'media','RecordedImages','right'));
nimages = LeftImages.Count;
% 
tf = 1/4;
bf = 3/4;

% tf = 1/2;
% bf = 1;

load stereoParams
disparityRange = [0 64];
thresholds=[-5 5; -5 10; 0 30]; 

VP = vision.VideoPlayer;

for frameIdx = 1:nimages
    ILO = imread(LeftImages.ImageLocation{frameIdx});
    IRO = imread(RightImages.ImageLocation{frameIdx}); 

    %% Extract image
    % Extract the middle of the image
    [nr,nc] = size(ILO);
    IL = ILO(tf*nr:bf*nr,:,:);
    IR = IRO(tf*nr:bf*nr,:,:);
    % View the extracted image
    % figure; 
    % imshowpair(IL,IR,'montage'); 
    % title('Extracted Portion of Original Images');
    %% Rectify the Images
    % Load Stereo Parameters
%     load stereoParams
    % Rectify the images.
    [JL, JR] = rectifyStereoImages(IL, IR, stereoParams);

    %% Generate Disparity Map
    % Create the disparity map 
%     disparityRange = [0 64];
    disparityMap = disparity(rgb2gray(JL),rgb2gray(JR),'DisparityRange',disparityRange);
    % View the disparity map
    % figure; 
    % imshow(disparityMap,disparityRange); 
    % title('Disparity Map'); 
    % colormap('jet'); 
    % colorbar;

    %% Reconstruct Point Cloud
    % create an empty stereo parameters object
    ptCloud = reconstructScene(disparityMap, stereoParams);
    % Convert from millimeters to meters.
    ptCloud = ptCloud/1000;
    % Limit the range of Z and X for display.
%     thresholds=[-5 5; -5 10; 0 30];  
    ptCloud = thresholdPC(ptCloud,thresholds);
    % View point cloud
    % figure
    % pcshow(ptCloud, JL)
    % ha = gca;
    % ha.CameraViewAngle = 5;
    % ha.CameraUpVector = [0 -1 0];
    % ha.CameraPosition = [-15 -10 -110];
    % ha.CameraTarget = [0 -2 15];
    % xlabel('X');
    % ylabel('Y');
    % zlabel('Z');
    % title('Point Cloud');

    %% Identify the depth of the vehicle in front
    % show rectified image which corresponds to the point cloud
%     figure
%     imshow(JL)
    COD = vision.CascadeObjectDetector('CarDetector.xml');
    bboxes = step(COD,JL);
%     bboxes = bboxes(2,:);
    % frame = insertShape(JL,'Rectangle',bbox);
    % imshow(frame)
    % title('ROI for car detected with Cascade Object Detector');

    % extract a roi from z layer of point cloud
    x1 = bboxes(:,1);
    x2 = bboxes(:,1)+bboxes(:,3);
    y1 = bboxes(:,2);
    y2 = bboxes(:,2)+bboxes(:,4);
    ptCloudZRoi = ptCloud(y1:y2,x1:x2,3);
    % calculate the average z value or distance
    distance = mean(ptCloudZRoi(:),'omitnan');
    % overlay the average distance onto the image
    frame = insertObjectAnnotation(JL,'rectangle',bboxes,num2str(distance));
%     figure
%     imshow(frame)
%     title('Depth of car extracted from Point Cloud');
    step(VP,frame)
    
end