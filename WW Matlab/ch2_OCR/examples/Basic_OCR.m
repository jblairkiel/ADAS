%% Basic_OCR
% This example shows the simplest implementation of OCR. Results are not
% accurate.

% Copyright 2014-2015 The MathWorks, Inc

clc
clear
close all

%% Load input image and view it
load sign1
imshow(frame)

%% Perform OCR
results = ocr(frame);

%% Insert bounding boxes on detected words in image
frame2 = insertShape(frame,'rectangle',results.WordBoundingBoxes,...
    'LineWidth', 3);
imshow(frame2)

%% Insert detected text in image 
frame3 = insertText(frame2,[700 100],results.Text,'FontSize', 34);
imshow(frame3)