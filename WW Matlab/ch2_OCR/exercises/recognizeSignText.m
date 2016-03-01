%% Recognize Traffic Sign Text with OCR
% Copyright 2014-2015 The MathWorks, Inc.

%% Perform OCR with Manual Text Location
% Import image
load stop50
frame = double(stop50);

hf = figure('units','normalized','outerposition',[0 0 1 1]); hold on;
imshow(frame);
set(gcf,'units','normalized','outerposition',[0 0 1 1]);
title('Click and drag to select ROI of Text in Stop Sign');
bbox = round(getPosition(imrect));
close

% Perform OCR
results = ocr(frame,bbox,'TextLayout','Line');
if ~isempty(results.Text)
    loc = results.WordBoundingBoxes;
    textLocation = loc(1:2)+[0 -20];
    frame = insertText(frame,textLocation,results.Text);
    figure; 
    imshow(frame); 
    title('Manual OCR with ROI');
end

%% Perform OCR with Automatic Text Location
% Import image
load stop50
frame = double(stop50);

% Find location of traffic sign
% Convert image from rgb to hsv
frameHsv = rgb2hsv(frame);
% Set up blob analysis object
BO = vision.BlobAnalysis('LabelMatrixOutputPort',true);
% Threshold image
bm = thresholdImageRed(frameHsv);
% Perform morphological opening to get rid of background noise
bm = imopen(bm,strel('disk',1));
bm = imclose(bm,strel('octagon',15));
% Perform blob analysis to find sign
[areaSign,centroidSign,bboxSign,labelSign] = step(BO,bm);

% Find location of text
% Create binary mask with just the largest blob corresponding to the
% traffic sign
bm = (labelSign==1);

% Extract pixels corresponding to the traffic sign using this binary mask
frameMasked = frame;
frameMasked(repmat(~bm,[1 1 3])) = 0;

% Create a binary mask with the text merged into one blob
bm = thresholdImageWhite(frameMasked);
bm = imclose(bm,strel('disk',3));
bm = imfill(bm,'holes');
figure; 
imshow(bm)
title('Binary mask for blob analysis of text region');

% Find the location of this merged text blob
[area,centroid,bbox]= step(BO,bm);
[amax,aidx] = max(area);
mbbox = bbox(aidx,:); 

% Perform OCR on ROI
results = ocr(frame,mbbox);
textLocation = centroid(aidx,:)+[0 -20];
frame = insertShape(frame,'FilledRectangle',[textLocation 30 15]);
frame2 = insertText(frame,textLocation,results.Text);
figure; 
imshow(frame2); 
title('Automatic OCR with Blob Analysis ROI');
