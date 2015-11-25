%% Create Video Reader and frame structures
clear;
clc;

[obj,pathname] = uigetfile({'*.avi';'*.mp4';'*.*';},'File Selector');
obj = VideoReader(obj);
nFrames = obj.NumberOfFrames;
vidHeight = obj.Height;
vidWidth = obj.Width;

mov(1:nFrames) = ...
    struct('cdata',zeros(vidHeight, vidWidth, 3,'uint8'),...
    'colormap',[]);

F(1:nFrames) = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);


%% Process video one frame at a time 
h = waitbar(0,'Processing Video (Part 1 of 2) 0%');
for k = 1 : nFrames
    perc = k/nFrames;
    waitbar(perc,h,sprintf('Processing Video (Part 1 of 2) %d%%',int8(perc*100)));
    frameImage = read(obj,k);
    rMat = frameImage(:,:,1);
    gMat = frameImage(:,:,2);
    bMat = frameImage(:,:,3);
    %Convert to YCbCr Increase the Y component of the video by 20%.
    CBCR = rgb2ycbcr(frameImage);
    yMat = CBCR(:,:,1);
    yAfterMat = (yMat * 1.2);
    cbMat = CBCR(:,:,2);
    crMat = CBCR(:,:,3);
    newCBCR = cat(3,yAfterMat,cbMat,crMat);
    %Convert feed back to RGB.
    newRGB = ycbcr2rgb(newCBCR);
    %Overlay a green box outline over the bottom 1/4 of the image.
    newRGB = insertShape(newRGB,'Rectangle',[1 250 600 85], 'LineWidth',5,'Color','green');
    newRGB = insertText(newRGB,[195 295],'activity1a_The_University_of_Alabama','AnchorPoint','LeftBottom');
    newrMat = newRGB(:,:,1);
    newgMat = newRGB(:,:,2);
    newbMat = newRGB(:,:,3);
    %Add the image to the frame structure
    F(k) = im2frame(newRGB);
end   
%% 
%These are the Validation Plots, The Bottom Plots validate the Y aspect has
%been increased by 20%
figure()
subplot(1,2,1), plot(yMat);
subplot(1,2,2), plot(yAfterMat);
close(h)
%% Save the output video file with the filename activity1a_(SchoolName).?
v = VideoWriter('activity1a_(The University of Alabama).mp4','MPEG-4');
v.FrameRate = 25;
open(v)
writeVideo(v,F);
close(v);
%movie2avi(F,'activity1a.avi','Compression','None');

%% Process the Second Activity One frame at a time
h = waitbar(0,'Processing Video (Part 2 of 2) 0%');
for k = 1 : nFrames
    perc = k/nFrames;
    waitbar(perc,h,sprintf('Processing Video (Part 2 of 2) %d%%',int8(perc*100)));
    frameImage = read(obj,k);
    rMat = frameImage(:,:,1);
    gMat = frameImage(:,:,2);
    bMat = frameImage(:,:,3);
    %Decrease the H component of the video by 20%.
    hsvImage = rgb2hsv(frameImage);
    hMat = hsvImage(:,:,1);
    newhMat = (hMat * .8);
    sMat = hsvImage(:,:,2);
    vMat = hsvImage(:,:,3);
    newHSV = cat(3,newhMat,sMat,vMat);
    %Convert feed back to RGB.
    newRGB = hsv2rgb(newHSV);
    %Overlay a green box with no fill over the bottom 1/4 of the image.
    %In the center of that box, overlay text that states your school name
    %and Activity 1b.
    newRGB = insertShape(newRGB,'Rectangle',[1 250 600 85], 'LineWidth',5,'Color','green');
    newRGB = insertText(newRGB,[195 295],'activity1b_The_University_of_Alabama','AnchorPoint','LeftBottom');
    newrMat = newRGB(:,:,1);
    newgMat = newRGB(:,:,2);
    newbMat = newRGB(:,:,3);
    %Add the image to the frame structure
    F(k) = im2frame(newRGB);
    
    %Team can choose any font and text size as long as the words are legible
end
%% 
close(h);
%These are the Validation Plots, The Bottom Plots validate the H aspect has
%been decreased by 20%
figure()
subplot(1,2,1), plot(hMat);
subplot(1,2,2), plot(newhMat);
%% Save the output video file with the filename ?activity1b_(SchoolName).?
v = VideoWriter('activity1b_(The University of Alabama).mp4','MPEG-4');
v.FrameRate = 25;
open(v)
writeVideo(v,F);
close(v);
h = msgbox('Activity 1 Program Complete');
%movie2avi(F,'activity1b.avi','Compression','None');