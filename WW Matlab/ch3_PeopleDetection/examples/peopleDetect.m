close all
clear
clc
%% Load the input image.
I = imread('visionteam1.jpg');

%% Create a people detector
peopleDetector = vision.PeopleDetector;

%% Detect people using the people detector object.
[bboxes,scores] = step(peopleDetector,I);

%% Annotate detected people.
I = insertObjectAnnotation(I,'rectangle',bboxes,scores);
figure, imshow(I)
title('Detected people and detection scores');