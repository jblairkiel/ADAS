%%
frame = imread('visionteam1.jpg');
figure;
subplot(2,2,1)
imshow(frame)

%%
pd = vision.PeopleDetector;
bbox = step(pd,frame);

%%
frameShape = insertShape(frame,'rectangle',bbox);
subplot(2,2,2)
imshow(frameShape)