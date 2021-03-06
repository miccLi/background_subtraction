clear; clc; close all;

img = imread('img/1.jpg');
img_gray = rgb2gray(img); % convert to greyscale
[width, height] = size(img_gray);
fg = zeros(width, height);
bg = zeros(width, height);

C = 3;          % number of gaussian components (typically 3-5)
M = 3;          % number of background components
D = 2.5;        % positive deviation threshold
alpha = 0.01;   % learning rate (between 0 and 1)
thres = 0.5;    % foreground threshold
sd_init = 0.001;    % initial standard deviation (for new components)

pixel_depth = 8;
pixel_range = 2^pixel_depth - 1;
mean = rand([width, height, C])*pixel_range;    % pixel means
w = ones([width, height, C]) * 1/C;             % initialize weights array
sd = ones([width, height, C]) * sd_init;        % pixel standard deviations
u_diff = zeros(width,height,C);                 % difference of each pixel from mean
p = alpha/(1/C);                % initial p variable (used to update mean and sd)
rank = zeros(1,C);              % rank of components (w/sd)

for n = 1:38
    imgName = strcat('img/', int2str(n), '.jpg');
    img = imread(imgName);
    img_gray = double(rgb2gray(img));
    
    % calculate difference of pixel values from mean
    img_gray_dim3 = cat(3, img_gray, img_gray, img_gray);
    u_diff = img_gray_dim3 - mean;
    
    % update gaussian components for each pixel
    indices_to_update = u_diff<=D*sd;
    w = (1 - alpha) * w;
    w(indices_to_update) = w(indices_to_update) + alpha;
    p = alpha./w;
    mean_new = (1-p).*mean + p.*img_gray_dim3;
    sd_new = sqrt((1-p).*sd.^2) + p.*(img_gray_dim3-mean).^2;
    mean(indices_to_update) = mean_new(indices_to_update);
    sd(indices_to_update) = sd_new(indices_to_update);
    
    w = w ./ cat(3, sum(w,3),sum(w,3),sum(w,3));
    bg = sum(mean .* w, 3);
    
    % if no components match, create new component
    match = sum(indices_to_update, 3);

    for i = 1:width
        for j = 1:height
            % if no components match, create new component
            if (match(i,j) == 0)
                [w_min, w_index] = min(w(i,j,:));
                mean(i,j,w_index) = img_gray(i,j);
                sd(i,j,w_index) = sd_init;
            end
            
%             rank = w(i,j,:)./sd(i,j,:);             % calculate component rank
%             rank_ind = [1:1:C];
% 
%             % sort rank values
%             sort(rank, 3, 'descend');
%             % calculate foreground
%             matching = 0;
%             k = 1;
%             fg(i,j) = 0;
%             while ((matching == 0) && (k<= M))
%                 if (w(i,j,rank_ind(k)) >= thres)
%                     if (abs(u_diff(i,j,rank_ind(k))) <= D*sd(i,j,rank_ind(k)))
%                         fg(i,j) = 0;
%                         matching = 1;
%                     else
%                         fg(i,j) = 255;
%                     end
%                 end
%                 k = k+1;
%                 if (k==5)
%                     k = k-1;
%                     break
%                 end
%             end
        end
    end
    n
%    subplot(2,1,1);imshow(img);
%    subplot(2,1,2);
imshow(uint8(bg));
%    subplot(2,1,2);imshow(uint8(fg));
    drawnow
end