%% Read an image
I = imread('businessCard.png');
figure;
subplot(2,2,1)
imshow(I)

%% Recognize Text
txtRes = ocr(I);

%% Visualize Result
frameTxt = insertText(I,[550 100],txtRes.Text,'FontSize',34);
subplot(2,2,2)
imshow(frameTxt)