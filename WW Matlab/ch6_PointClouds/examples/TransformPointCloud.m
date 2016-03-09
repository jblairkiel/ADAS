%% Transform Point Cloud
% Load the point cloud mat file
load livingRoom
% View the point cloud
pcshow(ptCloud,'VerticalAxis','Y','VerticalAxisDir','Down')
xlabel('x-axis')
ylabel('y-axis');
zlabel('z-axis');

%%
% Rotate the point cloud down parallel to the x-y plane
angle = -pi/10;
A = [1,0,0,0;...
     0, cos(angle), sin(angle), 0; ...
     0, -sin(angle), cos(angle), 0; ...
     0 0 0 1];
tform = affine3d(A);
ptCloudScene = pctransform(ptCloud, tform);
pcshow(ptCloudScene,'VerticalAxis','Y','VerticalAxisDir','Down')
title('Rotated point cloud')
xlabel('X (m)')
ylabel('Y (m)')
zlabel('Z (m)')

