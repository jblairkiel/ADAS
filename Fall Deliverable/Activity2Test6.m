%% Read movie to fame structure

[obj,pathname] = uigetfile({'*.avi';'*.mp4';'*.*';},'File Selector');
obj = VideoReader(obj);
nFrames = obj.NumberOfFrames;
%nFrames = 250;
vidHeight = obj.Height;
vidWidth = obj.width;

diskElem = strel('disk',10);
mov(1:nFrames) = ...
    struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);

hTextIns = vision.TextInserter(('[Height,Width,Location]=%d,%d [%d,%d]'),'Color',[0 0 255],'LocationSource','Input port','FontSize',24);

numInsert = vision.TextInserter('%d','Location',[20 1040], 'Color', [0 0 255], 'FontSize', 30);

hshapeinBox = vision.ShapeInserter('LineWidth',4,'BorderColor','Custom','CustomBorderColor',[0 0 255]);

F(1:nFrames) = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);
%% Process
h = waitbar(0,'Processing Video 0%');
for k = 1 : nFrames
    perc = k/nFrames;
    waitbar(perc,h,sprintf('Processing Video %d%%',int8(perc*100)))
    frameImage = read(obj,k);
    
    %frameBW = bwareaopen(frameImage, 800);
    framegray2 = im2bw(frameImage, .5);
    framegray = imopen(frameImage, diskElem);
    framegray = rgb2gray(framegray);
    frameBW = bwareaopen(framegray, 150);
    I = imdilate(frameBW, diskElem);
    I2 = imdilate(I,diskElem);
    I3 = imdilate(I2, diskElem);
    I4 = imdilate(I3, diskElem);
    I5 = imdilate(I4, diskElem);
    I6 = imdilate(I5, diskElem);
    framegray = im2bw(I6, .5);
    Ibwopen = imopen(framegray, diskElem);
    hBlob = vision.BlobAnalysis('MinimumBlobArea',900,'MaximumBlobArea',100000);
    
    [objArea,objCentroid,bboxOut] = step(hBlob,Ibwopen);
    newImage = imadd(framegray,framegray2);
    newImage = cat(3,newImage,newImage,newImage);
    Ishape = step(hshapeinBox,newImage,bboxOut);
    numObj = numel(objArea);
    if ~isempty(bboxOut(:,1))  
        Itext = Ishape;
        for j = 1:1:length(bboxOut(:,1))
            Itext = step(hTextIns,Itext,[bboxOut(j,4) bboxOut(j,3) (objCentroid(j,1)-960) (objCentroid(j,2)-540)],[objCentroid(j,1),objCentroid(j,2)+15]);
        end
    else
        Itext = Ishape;
    end
    Itext = step(numInsert,Itext,int8(length(bboxOut(:,1))));
    %F(k) = im2frame(frameImage);
    F(k) = im2frame(im2uint8(Itext));
    objCentroid = 0;
end
close(h);

%% Convert each frame to a binary image with a threshold
%implay(F)
v = VideoWriter('activity2_(The University of Alabama)2test.avi','Uncompressed AVI');
v.FrameRate = 28;
open(v)
writeVideo(v,F);
close(v);
h = msgbox('Activity 2 Program Complete');