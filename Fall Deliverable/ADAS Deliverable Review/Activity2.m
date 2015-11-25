%% Read movie to fame structure

[obj,pathname] = uigetfile({'*.avi';'*.mp4';'*.*';},'File Selector');
obj = VideoReader(obj);
nFrames = obj.NumberOfFrames;
vidHeight = obj.Height;
vidWidth = obj.width;

%disk structure
diskElem = strel('disk',10);

%raw data frames structure
mov(1:nFrames) = ...
    struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);

%Text inserter for height width and location of each blob
hTextIns = vision.TextInserter(('[Height,Width,Location]=%d,%d [%d,%d]'),'Color',[0 0 255],'LocationSource','Input port','FontSize',24);

%Text inserter for number of blobs in a frame
numInsert = vision.TextInserter('%d','Location',[20 1040], 'Color', [0 0 255], 'FontSize', 30);

%Creates the box to go around each blob
hshapeinBox = vision.ShapeInserter('LineWidth',4,'BorderColor','Custom','CustomBorderColor',[0 0 255]);

%Blob analysis object
hBlob = vision.BlobAnalysis('MinimumBlobArea',900,'MaximumBlobArea',100000);

%Processed frames structure
F(1:nFrames) = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);

%% Process video one frame at a time
h = waitbar(0,'Processing Video 0%');
for k = 1 : nFrames
    perc = k/nFrames;
    waitbar(perc,h,sprintf('Processing Video %d%%',int8(perc*100)))
    frameImage = read(obj,k);
    
    %Reduce the noise in the image and locate the blobs
    framegray2 = im2bw(frameImage, .5);
    framegray = imopen(frameImage, diskElem);
    framegray = rgb2gray(framegray);
    frameBW = bwareaopen(framegray, 150);
    
    %Fill in the blobs by dilation
    I = imdilate(frameBW, diskElem);
    I2 = imdilate(I,diskElem);
    I3 = imdilate(I2, diskElem);
    I4 = imdilate(I3, diskElem);
    I5 = imdilate(I4, diskElem);
    I6 = imdilate(I5, diskElem);
    framegray = im2bw(I3, .5);
    Ibwopen = imopen(framegray, diskElem);
    
    %Analyze each blob, placing a box around the blob and inserting text
    %under it stating the Height, Width, and Location with respect to the
    %center of the frame
    [objArea,objCentroid,bboxOut] = step(hBlob,Ibwopen);
    newImage = imadd(framegray,framegray);
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
    
    %Convert the processed image to an 8bit integer and add it to the
    %processed frames structure
    F(k) = im2frame(im2uint8(Itext));
    objCentroid = 0;
end
close(h);

%% Write the processed frames to the output video file.
v = VideoWriter('activity2_(The University of Alabama).mp4','MPEG-4');
v.FrameRate = 28;
open(v)
writeVideo(v,F);
close(v);
h = msgbox('Activity 2 Program Complete');