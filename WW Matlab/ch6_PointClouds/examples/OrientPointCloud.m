%% Orient a Point Cloud Visualization with the -Y Axis Upward
%% load a point cloud
load livingRoom
%% show the point cloud
pcshow(ptCloud)
%% add axis labels to get orientation
xlabel('x-axis');
ylabel('y-axis');
zlabel('z-axis');
%% we need to set the -y axis as the vertical axis
pcshow(ptCloud,'VerticalAxis','Y','VerticalAxisDir','Down');
xlabel('x-axis');
ylabel('y-axis');
zlabel('z-axis');