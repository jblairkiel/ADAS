%% Ground Plane Line Detection
% Use a point cloud to limit line detection to the ground plane
clc
clear
close all

%% Load point cloud
load ptCloud4
% View point cloud
figure
pcshow(ptCloud,'VerticalAxis','Y','VerticalAxisDir','Down')
title('Point Cloud');

%% Fit ground plane
maxDistance = 1;
referenceVector = [0 1 0];
maxAngularDistance = 30*pi/180;
[model,inlierIdx,outlierIdx] = pcfitplane(ptCloud,maxDistance,referenceVector,maxAngularDistance);
% Show extracted ground plane for visualization purposes
ptCloudGround = select(ptCloud,inlierIdx);
figure;
pcshow(ptCloudGround,'VerticalAxis','Y','VerticalAxisDir','Down')
title('Extracted Ground Plane Point Cloud');

%% Ground plane image extraction 
% Extract image from point cloud
frame = ptCloud.Color;
figure
imshow(frame)
title('Color Image');

% Create binary mask where ground pixels are true
nr = size(frame,1);
nc = size(frame,2);
bm = false(nr,nc);
bm(inlierIdx) = true; 
bm = imclose(bm,strel('disk',20));
% View binary mask
figure
imshow(bm);
title('Binary Mask for Ground Points');

% Use mask to set pixels in image to zero
mask = repmat(bm,[1 1 3]);
frame(~mask) = 0;
figure;
imshow(frame);
title('Extracted Ground Plane Image');
    
%% Obtain mask of lines 
% convert colorspace from rgb to grayscale
grayFrame = rgb2gray(frame);

% perform edge detection
edgeFrame = edge(grayFrame);
% convert edge frame to double for auto thresholder
edgeFrame = double(edgeFrame);
% view edges
figure;
imshow(edgeFrame)

% auto threshold the image
hAutothreshold = vision.Autothresholder;
thresholdedFrame = step(hAutothreshold, edgeFrame);

%% Hough Transform
% Perform Hough Transform
[H, Theta, Rho] = hough(thresholdedFrame);
% Visualize hough transform
figure;
imshow(imadjust(mat2gray(H)),'XData',Theta,'YData',Rho,...
'InitialMagnification','fit','Border','tight');
colormap('hot');
xlabel('\theta'), ylabel('\rho'); % debug
axis on, axis normal

% Identify Peaks in Hough Transform
Peaks  = houghpeaks(H,50,'threshold',ceil(0.3*max(H(:))));

% Extract lines from hough transform and peaks
lines = houghlines(thresholdedFrame,Theta,Rho,Peaks,'FillGap',80,'MinLength',7);
    
% % Overlay lines and view results
% xy = zeros(length(lines),4);
% for lidx = 1:length(lines)
%     xy(lidx,:) = [lines(lidx).point1 lines(lidx).point2];  
% end
% frame2 = insertShape(frame,'Line',xy,'Color','green','LineWidth',1);
% figure
% imshow(frame2);    
    
% get rid of all lines that are horizontal
theta = [lines.theta];
thetaHorizontal = (theta > 80 & theta < 100) | (theta < -70 & theta > -100);
lines = lines(~thetaHorizontal);
    
% Overlay lines and view results
xy = zeros(length(lines),4);
for lidx = 1:length(lines)
    xy(lidx,:) = [lines(lidx).point1 lines(lidx).point2];  
end
frame2 = insertShape(frame,'Line',xy,'Color','green','LineWidth',1);
figure;
imshow(frame2);
    