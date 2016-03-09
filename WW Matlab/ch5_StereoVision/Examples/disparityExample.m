clc
clear
close all

%%
% load the stereo parameters
load('webcamsSceneReconstruction.mat');

% Read in the stereo pair of images.
I1 = imread('sceneReconstructionLeft.jpg');
I2 = imread('sceneReconstructionRight.jpg');

% Display the images before rectification
figure; imshowpair(I1,I2);
title('Unrectified Images');

%% Rectify images

% Rectify the images
[J1, J2] = rectifyStereoImages(I1, I2, stereoParams);

% Display the images after rectification.
figure; imshowpair(J1,J2);
title('Rectified Images');

%% Calculate the disparity map 

% Generate disparity map
% Need to input intensity images
disparityMap = disparity(rgb2gray(J1),rgb2gray(J2));

% Visualize the disparity map
figure; imshow(disparityMap); title('Disparity Map without Display Range');

% Observe that the contrast is extremely high due to the large minimum
% value. Hence the apparent lack of gradient.
min(disparityMap(:))
max(disparityMap(:))

% Decrease the viewed contrast by setting limits
disparityRange = [0 64];
figure; imshow(disparityMap,disparityRange)

% Add some color by changing the color map
title('Disparity Map');
colormap('jet')

% Add a colorbar to get some perspective
colorbar

%% Compare with a disparity map from unrectified images for comparison
% Calculate the disparity map
disparityMapUnrectified = disparity(rgb2gray(I1),rgb2gray(I2));

% Visualize the disparity map 
figure; imshow(disparityMapUnrectified,disparityRange)
title('Disparity Map from Unrectified Images');
colormap('jet')
colorbar
