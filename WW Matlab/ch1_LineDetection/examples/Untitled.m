wormSkel = imread('wormsBW1.png');
[H, T, R] = hough(wormSkel);
edit houghMatViz
houghMatViz(H,T,R)
houghDescription