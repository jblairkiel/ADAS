%% ManualROI_OCR
% This example shows how to use a manually select ROIs to increase the accuracy of OCR

% Copyright 2014-2015 The MathWorks, Inc

clc
clear
close all

%% Load input image and view it
load sign1
imshow(frame)

%% Select ROI

% Get ROI interactively
% roi = round(getPosition(imrect));

%OR

% Provide ROI directly in script
roi = [364,253,363,410];

%% Perform OCR on image with ROI
results = ocr(frame,roi);

%% Insert bounding boxes on detected words in image
frame2 = insertShape(frame,'rectangle',results.WordBoundingBoxes,...
    'LineWidth', 3);
imshow(frame2)

%% Insert detected text in image 
frame3 = insertText(frame2,[700 100],results.Text,'FontSize', 34);
imshow(frame3)