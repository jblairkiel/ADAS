%% Load the point cloud.
load('object3d.mat')

%% Display and label the point cloud.
figure
pcshow(ptCloud)
xlabel('X(m)')
ylabel('Y(m)')
zlabel('Z(m)')
title('Original Point Cloud')

%% Set general plane extraction parameters
% Set the maximum point-to-plane distance (2cm) for plane fitting.
maxDistance = 0.02;

% Set the maximum angular distance to 5 degrees.
maxAngularDistance = 5;
%% Set reference vector to extract ground plane
% Z axis is normal to the ground plane
referenceVector = [0,0,1];
%% Extract the ground plane
% Detect the first plane, the table, and extract it from the point cloud.
[model1,inlierIndices,outlierIndices] = pcfitplane(ptCloud,maxDistance,referenceVector,maxAngularDistance);
plane1 = select(ptCloud,inlierIndices);

%% View the extracted ground plane
figure
pcshow(plane1)
title('First Plane with extracted visualization')
%% Alternate way to view ground plane
figure
pcshow(ptCloud);
hold on;
h = plot(model1);
h.FaceAlpha = 0.5; % make the plane translucent
hold off;
title('First plane with plot visualization');
%% Extract the remaining point cloud
remainPtCloud = select(ptCloud,outlierIndices);

%% Plot the remaining points
figure
pcshow(remainPtCloud)
title('Remaining Point Cloud')

%% Ground plane image extraction 
% Set pixels from image not corresponding to ground plane to zero using linear idx

% Extract image from point cloud
frame = ptCloud.Color;
figure
imshow(frame)
title('Color Image');
% Create binary mask
nr = size(frame,1);
nc = size(frame,2);
bm = false(nr,nc);
bm(outlierIndices) = true; 
% View binary mask
figure
imshow(bm);
title('Binary Mask');
% Use mask to set pixels in image to zero
mask = repmat(bm,[1 1 3]);
frame(mask) = 0;
figure;
imshow(frame);
title('Extracted Ground Plane Image');