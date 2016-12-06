clear; clc; close all;

C = 3;          % number of gaussian components (typically 3-5)

img = imread('seq3/img (1).jpg');
img_gray = rgb2gray(img); % convert to greyscale
[width, height] = size(img_gray);
pixel_depth = 8;
pixel_range = 2^pixel_depth - 1;
mean = rand([width, height, C])*pixel_range;    % pixel means
w = ones([width, height, C]) * 1/C;             % initialize weights array
sd_init = 0.001;    % initial standard deviation (for new components)
sd = ones([width, height, C]) * sd_init;        % pixel standard deviations

for n = 1:38
    imgName = strcat('seq3/img (', int2str(n), ').jpg');
    img = imread(imgName);
    
    [bg, fg, w, mean, sd] = bgSubtractionMoG(img, w, mean, sd);
    
    n
    subplot(3,1,1);imshow(img);
    subplot(3,1,2);imshow(bg);
    subplot(3,1,3);imshow(fg);
    drawnow;
end