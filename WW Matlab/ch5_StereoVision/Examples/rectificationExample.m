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

