%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Program Name : white Object Detection and Tracking                      %
% Author       : Arindam Bose                                             %
% Version      : 1.05                                                     %
% Description  : How to detect and track white objects in Live Video      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialization
thresh = 0.75; % Threshold for white detection
vidDevice = imaq.VideoDevice('winvideo', 1, 'YUY2_640x480', ... % Acquire input video stream
                    'ROI', [1 1 640 480], ...
                    'ReturnedColorSpace', 'rgb');
vidInfo = imaqhwinfo(vidDevice); % Acquire input video property
hblob = vision.BlobAnalysis('AreaOutputPort', false, ... % Set blob analysis handling
                                'CentroidOutputPort', true, ... 
                                'BoundingBoxOutputPort', true', ...
                                'MinimumBlobArea', 400, ...
                                'MaximumCount', 50);
hshapeinsWhiteBox = vision.ShapeInserter('BorderColor', 'Custom', ...
                                        'CustomBorderColor', [1 0 0]); % Set white box handling
htextins = vision.TextInserter('Text', 'Number of White Object(s): %2d', ... % Set text for number of blobs
                                    'Location',  [7 2], ...
                                    'Color', [1 1 1], ... // white color
                                    'Font', 'Courier New', ...
                                    'FontSize', 12);
htextinsCent = vision.TextInserter('Text', '+      X:%6.2f,  Y:%6.2f', ... % set text for centroid
                                    'LocationSource', 'Input port', ...
                                    'Color', [0 0 0], ... // black color
                                    'FontSize', 12);
hVideoIn = vision.VideoPlayer('Name', 'Final Video', ... % Output video player
                                'Position', [100 100 vidInfo.MaxWidth+20 vidInfo.MaxHeight+30]);
nFrame = 0; % Frame number initialization

%% Processing Loop
while(nFrame < 300)
    rgbFrame = step(vidDevice); % Acquire single frame
    rgbFrame = FLIP(rgbFrame,2); % obtain the mirror image for displaying
    bwredFrame = im2bw(rgbFrame(:,:,1), thresh); % obtain the white component from red layer
    bwgreenFrame = im2bw(rgbFrame(:,:,2), thresh); % obtain the white component from green layer
    bwblueFrame = im2bw(rgbFrame(:,:,3), thresh); % obtain the white component from blue layer
    binFrame = bwredFrame & bwgreenFrame & bwblueFrame; % get the common region
    binFrame = medfilt2(binFrame, [3 3]); % Filter out the noise by using median filter
    [centroid, bbox] = step(hblob, binFrame); % Get the centroids and bounding boxes of the blobs
    rgbFrame(1:15,1:215,:) = 0; % put a black region on the output stream
    vidIn = step(hshapeinsWhiteBox, rgbFrame, bbox); % Instert the white box
    for object = 1:1:length(bbox(:,1)) % Write the corresponding centroids
        vidIn = step(htextinsCent, vidIn, [centroid(object,1) centroid(object,2)], [centroid(object,1)-6 centroid(object,2)-9]); 
    end
    vidIn = step(htextins, vidIn, uint8(length(bbox(:,1)))); % Count the number of blobs
    step(hVideoIn, vidIn); % Output video stream
    nFrame = nFrame+1;
end
%% Clearing Memory
release(hVideoIn); % Release all memory and buffer used
release(vidDevice);
clear all;
clc;