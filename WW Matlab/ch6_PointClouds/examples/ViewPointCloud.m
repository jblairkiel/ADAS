%% load point cloud from mat file
load teapot

%% View 1-time visualization of point cloud
tic
pcshow(ptCloud)
toc
%% View a point cloud with the pcplayer method
xlimits = [-5 5];
ylimits = [-5 5];
zlimits = [0 5];
player = pcplayer(xlimits,ylimits,zlimits);

tic
view(player,ptCloud)
toc

%% View a dynamic point cloud
% Specify an affine rotation of 1 degree
x = pi/180;
R = [ cos(x) sin(x) 0 0
     -sin(x) cos(x) 0 0
      0         0   1 0
      0         0   0 1];

tform = affine3d(R);

% Specify the lower and upper limits for the point cloud
lower = min([ptCloud.XLimits ptCloud.YLimits]);
upper = max([ptCloud.XLimits ptCloud.YLimits]);

xlimits = [lower upper];
ylimits = [lower upper];
zlimits = ptCloud.ZLimits;

% Initialize the point cloud player object
player = pcplayer(xlimits,ylimits,zlimits); % uncomment

tic
for i = 1:360
    ptCloud = pctransform(ptCloud,tform);
    
    % visualize with pcshow
%     pcshow(ptCloud) % comment out
%     drawnow % comment out
    
    % visualize with pcplayer
    view(player,ptCloud); % uncomment
end
toc

%% 
% Cleanup
