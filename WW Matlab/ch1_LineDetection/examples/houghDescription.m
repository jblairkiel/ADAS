function houghDescription
%% houghDescription
% visualize the hough matrix and image plane for two dots and a line

% Copyright 2014-2015 The MathWorks

%% 1. Image with two dots
b = zeros(150);
b(20,50) = 1; b(50,100) = 1;
[Hb,thetab,rhob] = hough(b);
% Plot the image and the Hough transform matrix
figure;
subplot(2,2,1), imshow(b);title('Image with two dots');
subplot(2,2,2),imshow(imadjust(mat2gray(Hb)),'XData',thetab,'YData',rhob);
xlabel('\theta'), ylabel('\rho');
axis on, axis normal;

%% Identify a peak in the Hough transform matrix H
peaksb = houghpeaks(Hb);
x = thetab(peaksb(:,2)); y = rhob(peaksb(:,1));
hold on
plot(x,y,'s','color','red');
title('Hough Transform with peaks marked');

%% 2. Image with a line
a = eye(150);

[H,theta,rho] = hough(a);
subplot(2,2,3),imshow(a),title('Image with a line');
subplot(2,2,4),imshow(imadjust(mat2gray(H)),'XData',theta,'YData',rho,...
    'InitialMagnification','fit','Border','tight');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal;
%% Identify peaks in the Hough transform matrix H
peaks = houghpeaks(H);
x = theta(peaks(:,2)); y = rho(peaks(:,1));
hold on
plot(x,y,'s','color','red');
title('Hough Transform with peaks marked');
colormap(hot);