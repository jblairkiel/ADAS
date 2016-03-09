%% Downsample a point cloud using different methods
%% Load a point cloud.
load teapot
% View original point cloud
figure;
pcshow(ptCloud);
%% Use the random method to downsample a point cloud
percentage = .10;
ptCloudOut = pcdownsample(ptCloud,'random',percentage);

figure;
pcshow(ptCloudOut);

%% Use the grid method to downsample a point cloud
% Set the 3-D resolution to be (0.1 x 0.1 x 0.1).
gridStep = 0.1;
ptCloudOut = pcdownsample(ptCloud,'gridAverage',gridStep);

figure;
pcshow(ptCloudOut);

%% Use the non-uniform grid method to downsample a point cloud 
maxNumPoints = 10;
ptCloudOut = pcdownsample(ptCloud,'nonuniformGridSample',maxNumPoints);

figure
pcshow(ptCloudOut);