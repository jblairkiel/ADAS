%% AutomaticROI_OCR
% Automatically generate a ROI for OCR by performing blob analysis on the
% sign's filled in binary mask.

% Copyright 2014-2015 The MathWorks

clc
clear 
close all

%% Load origframeal frameput image
load sign1

%% Color Threshold frameput image

% Convert RGB image to chosen color space
frame2 = rgb2ycbcr(frame);

% Defframee thresholds for channel 1 based on histogram settframegs
channel1Mframe = 215.000;
channel1Max = 255.000;

% Defframee thresholds for channel 2 based on histogram settframegs
channel2Mframe = 0.000;
channel2Max = 255.000;

% Defframee thresholds for channel 3 based on histogram settframegs
channel3Mframe = 0.000;
channel3Max = 255.000;

% Create mask based on chosen histogram thresholds
BW = (frame2(:,:,1) >= channel1Mframe ) & (frame2(:,:,1) <= channel1Max) & ...
    (frame2(:,:,2) >= channel2Mframe ) & (frame2(:,:,2) <= channel2Max) & ...
    (frame2(:,:,3) >= channel3Mframe ) & (frame2(:,:,3) <= channel3Max);

%% View BW image
figure; imshow(BW)

%%
BW_filled = imfill(BW,'holes');
% figure; imshow(BW_filled); % debug

%%
BA = vision.BlobAnalysis('MaximumCount',1000);
[area,centroid,bbox] = step(BA,BW_filled);

%% Sort results by area
[as,is] = sort(area);
imax = is(end);

amax = area(imax);
display(amax)

%% Extract ROI encompassing sign
roi = bbox(imax,:);

%% Display ROI
frame3 = insertShape(frame,'Rectangle',roi);
% figure; imshow(frame3); % debug
figure; imshowpair(BW_filled,frame3,'montage')

%% Perform OCR on BW image
% Input RGB image
results = ocr(frame,roi);

% or

% Input Binary Mask
% results = ocr(BW,roi);

%% frame insert detected text frame image 
frame4 = insertText(frame,[700 100],results.Text,'FontSize', 34);

%% Visualize results
figure; imshow(frame4)
