%% Card_OCR
% This example runs OCR on the card image from documentation.

% Copyright 2014-2015 The MathWorks, Inc

clc
clear
close all

%% Load input image and view it
frame = imread('businessCard.png');

%% Perform OCR
results = ocr(frame);

%% Insert bounding boxes on detected words in image
frame2 = insertShape(frame,'rectangle',results.WordBoundingBoxes,...
    'LineWidth', 3);
imshow(frame2)

%% Insert detected text in image 
frame3 = insertText(frame2,[550 100],results.Text,'FontSize', 34);
imshow(frame3)