% This function applies Mixture of Gaussian(MoG) algorithm to subtract
% background image from a given video/image sequence.
function [bg, fg, w, mean, sd] = bgSubtractionMoG(img, w, mean, sd)
    % initialize MoG algorithm parameters
    D = 2.5;        % positive deviation threshold
    alpha = 0.01;   % learning rate (between 0 and 1)
    thres = 0.25;    % foreground threshold
    sd_init = 0.001;    % initial standard deviation (for new components)

    % calculate difference of pixel values from mean
    img_gray = double(rgb2gray(img));
    img_gray_dim3 = cat(3, img_gray, img_gray, img_gray);
    u_diff = img_gray_dim3 - mean;
    
    % update gaussian components for each pixel
    indices_to_update = u_diff<=D*sd;
    % update weights
    w = (1 - alpha) * w;
    w(indices_to_update) = w(indices_to_update) + alpha;
    % update means and standard deviations for each gaussian distribution
    p = alpha./w;
    mean_new = (1-p).*mean + p.*img_gray_dim3;
    sd_new = sqrt((1-p).*sd.^2) + p.*(img_gray_dim3-mean).^2;
    mean(indices_to_update) = mean_new(indices_to_update);
    sd(indices_to_update) = sd_new(indices_to_update);
    % calculate background model
    w = w ./ cat(3, sum(w,3),sum(w,3),sum(w,3));
    bg = sum(mean .* w, 3);
    
    % if no components match, create new component
    match = any(indices_to_update, 3);

    [width, height] = size(img_gray);
    for i = 1:width
        for j = 1:height
            % if no components match, create new component
            if (match(i,j) == 0)
                [~, w_index] = min(w(i,j,:));
                mean(i,j,w_index) = img_gray(i,j);
                sd(i,j,w_index) = sd_init;
            end
        end
    end
    
%     fg = zeros([width, height]);
%     rank = w(i,j,:)./sd(i,j,:);             % calculate component rank
%     sort(rank, 3, 'descend');
%     
%     is_foreground = (~match) & any((w>thres),3) & any((abs(u_diff)>(D*sd)),3);
%     fg(~match) = 255;

    fg = abs(img_gray - bg);
    fg(fg < 30) = 0;
    bg = uint8(bg);
    fg = logical(fg);
end