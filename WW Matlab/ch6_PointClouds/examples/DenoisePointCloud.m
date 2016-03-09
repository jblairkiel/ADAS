clc
clear
close all
%%
% Load point cloud from .mat file
load teapot
% View original point cloud
figure
pcshow(ptCloud)
title('Original Point Cloud');
%% Add noise to point cloud
noise = 6*rand(1000, 3);
noise(:,1) = noise(:,1)-3;
noise(:,2) = noise(:,2)-3;
noise(:,3) = noise(:,3)-1.5;
% View noisy point cloud
ptCloud = pointCloud([ptCloud.Location; noise]);
figure
pcshow(ptCloud)
title('Noisy Point Cloud');
%% Denoise the point cloud
ptCloud = pcdenoise(ptCloud);
figure
pcshow(ptCloud)
title('Denoised Point Cloud');
