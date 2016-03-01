%% Load and Save Point Clouds

%% Load point cloud from .mat file
load teapot
pcshow(ptCloud)

%% Save a point cloud to a .mat file
save teapotOut ptCloud

%%
% Load point cloud from .ply file
ptCloud = pcread('teapot.ply');
pcshow(ptCloud);
%%
% Write point cloud to .ply file
pcwrite(ptCloud,'teapotOut');

%%
% Cleanup
delete('teapotOut.mat')
delete('teapotOut.ply');