clc
clear
close all

% Load the disparity map and stereo parameters
load reconstructParams

%% Reconstruct Scene
% Generate point cloud
ptCloud = reconstructScene(disparityMap, stereoParams);
% Display point cloud
pcshow(ptCloud)
%%
% Threshold point cloud to remove noise
thresholds=[-5000 5000;-1700 1000;0 10000];  
ptCloud = thresholdPC(ptCloud,thresholds);
% View point cloud after thresholding
pcshow(ptCloud);
xlabel('x-axis');
ylabel('y-axis');
zlabel('z-axis');
%%
% View point cloud with color data
% figure;
pcshow(ptCloud,J1)
xlabel('x-axis');
ylabel('y-axis');
zlabel('z-axis');
%%
% Set the camera view
ha = gca;
ha.CameraPosition = [-750 -11500 -36500];
ha.CameraViewAngle = 11;
ha.CameraUpVector = [0 -1 0.25];
%% Create a point cloud object
% Store depth and color data in the point cloud object
ptCloudObj = pointCloud(ptCloud,'Color',J1);
display(ptCloudObj)
% display point cloud
pcshow(ptCloudObj);
title('View Point Cloud Object');
xlabel('x-axis');
ylabel('y-axis');
zlabel('z-axis');
ha = gca;
ha.CameraPosition = [-750 -11500 -36500];
ha.CameraViewAngle = 11;
ha.CameraUpVector = [0 -1 0.25];
%% Extract parts of image corresponding to depth range
K1 = J1;
% create a mask from z component of point cloud which extracts the woman in
% the image
z = ptCloud(:,:,3);
zlow = 3200;
zhigh = 3700;
mask = repmat(z > zlow & z < zhigh,[1 1 3]); 
K1(~mask) = 0;
figure;
imshow(K1)