clear; clc; close all;

C = 3;          % number of gaussian components (typically 3-5)

img = imread('seq3/img (1).bmp');
img_gray = rgb2gray(img); % convert to greyscale
[width, height] = size(img_gray);
pixel_depth = 8;
pixel_range = 2^pixel_depth - 1;
mean = rand([width, height, C])*pixel_range;    % pixel means
w = ones([width, height, C]) * 1/C;             % initialize weights array
sd_init = 0.001;    % initial standard deviation (for new components)
sd = ones([width, height, C]) * sd_init;        % pixel standard deviations

for n = 1:500
    imgName = strcat('seq3/img (', int2str(n), ').bmp');
    img = imread(imgName);
    
    [bg, fg, w, mean, sd] = bgSubtractionMoG(img, w, mean, sd);
    
    blob = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
        'AreaOutputPort', false, 'CentroidOutputPort', false, ...
        'MinimumBlobAreaSource', 'Property', 'MinimumBlobArea', 150);
    shapeInserter = vision.ShapeInserter('BorderColor','Custom', 'CustomBorderColor', [255 0 0]);
    bbox = step(blob, fg);
    out = step(shapeInserter, img, bbox);
    
    n
    subplot(3,1,1);imshow(fg);
    subplot(3,1,2);imshow(bg);
    subplot(3,1,3);imshow(out);
    drawnow;
end