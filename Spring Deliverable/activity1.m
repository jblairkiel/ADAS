%Imports the stereo video
%Identifies the vehicle directly in front and draws a bounding box around this vehicle
% Uses the stereo video to estimate the distance to the vehicle in front:
    %Rectifies each stereo frame to ensure the left and right images are aligned
    % Builds a disparity map between the left and right images
    % Reconstructs the disparity map to generate a point cloud
% Uses that point cloud to find the distance to the center of the vehicle bounding box
    % To reduce noise it may be preferable to use an average of a small group of pixels at the center
% Outputs the left side source video with the following items overlaid:
    % Bounding box around the vehicle in front
    % Text above or below the bounding box stating:
        % Estimated distance to the center of the vehicle bounding box
        % Location of the vehicle bounding box center (in pixels measured relative to image center)
        % Note: text should include units and a label for each item (e.g. Distance: 20 meters)
% Outputs a figure plotting the distance to the vehicle in front throughout the duration of the video.