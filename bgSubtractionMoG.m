% This function applies Mixture of Gaussian(MoG) algorithm to subtract
% background image from a given video/image sequence.
function bg = bgSubtractionMoG(img, mean, w, sd, u_diff, p, rank)
    % initialize MoG algorithm parameters
    C = 3;          % number of gaussian components (typically 3-5)
    M = 3;          % number of background components
    D = 2.5;        % positive deviation threshold
    alpha = 0.01;   % learning rate (between 0 and 1)
    thres = 0.5;    % foreground threshold
    sd_init = 0.001;    % initial standard deviation (for new components)

    % calculate difference of pixel values from mean
    img_gray = rgb2gray(img);
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
    match = sum(indices_to_update, 3);

    for i = 1:width
        for j = 1:height
            % if no components match, create new component
            if (match(i,j) == 0)
                [w_min, w_index] = min(w(i,j,:));
                mean(i,j,w_index) = img_gray(i,j);
                sd(i,j,w_index) = sd_init;
            end
        end
    end
end