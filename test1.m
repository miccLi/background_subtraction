clear;clc;close all;

foregroundDetector = vision.ForegroundDetector('NumGaussians', 5, ...
    'MinimumBackgroundRatio', 0.7);
img = imread('seq3/img (1).bmp');
[width, height] = size(img);

for n = 1:500
    imgName = strcat('seq3/img (', int2str(n), ').bmp');
    img = imread(imgName);
    blob = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
        'AreaOutputPort', false, 'CentroidOutputPort', false, ...
        'MinimumBlobAreaSource', 'Property', 'MinimumBlobArea', 100);
    shapeInserter = vision.ShapeInserter('BorderColor','Custom', 'CustomBorderColor', [255 0 0]);
    fgMask = step(foregroundDetector, img);
    bbox = step(blob, fgMask);
    out = step(shapeInserter, img, bbox);
    subplot(2,1,1);imshow(fgMask);drawnow;
    subplot(2,1,2);imshow(out);drawnow;
end