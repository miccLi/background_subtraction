clear;clc;close all;

foregroundDetector = vision.ForegroundDetector('NumGaussians', 3, ...
    'MinimumBackgroundRatio', 0.7);
img = imread('img/1.jpg');
[width, height] = size(img);

for n = 1:38
    imgName = strcat('img/', int2str(n), '.jpg');
    img = imread(imgName);
    blob = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
        'AreaOutputPort', false, 'CentroidOutputPort', false, ...
        'MinimumBlobAreaSource', 'Property', 'MinimumBlobArea', 100);
    shapeInserter = vision.ShapeInserter('BorderColor','Custom', 'CustomBorderColor', [255 0 0]);
    fgMask = step(foregroundDetector, img);
    bbox = step(blob, fgMask);
    out = step(shapeInserter, img, bbox);
    imshow(fgMask);drawnow;
end

figure; imshow(img); title('image');
figure; imshow(fgMask); title('foreground');
figure; imshow(out); title('background');