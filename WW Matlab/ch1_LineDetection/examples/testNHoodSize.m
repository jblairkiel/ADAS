function testNHoodSize(nhood)
%% testNHoodSize
% Visualize the hough transform detected line segments given an input
% Neighborhood Size. This neighborhood size is passed to the corresponding
% houghpeaks property.

% Copyright 2014-2015 The MathWorks

%% Find the dead worms in an image
worms = imread('wormsBW1.png');
wormSkel = bwmorph(worms,'skel',Inf);
[H, T, R] = hough(wormSkel);
%%
peaks = houghpeaks(H, 30,'NHoodSize', nhood);
lines = houghlines(wormSkel, T, R, peaks);
numLines = length(lines);

%% Visualize worm lengths
% plot the lines
figure, imshow(wormSkel,'InitialMagnification','fit'), hold on;
title({['NHoodSize = ', mat2str(nhood)],...
        ['Number of line segments = ',num2str(numLines)]});

map = rand(numLines,3);

%% Visualize line segments
for k = 1:numLines
    xy = [lines(k).point1; lines(k).point2]; 
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color',map(k,:),...);
         'Marker', 'x', 'MarkerEdgeColor', 'red');
end
