This function applies Gaussian Mixture Model(GMM) algorithm to subtract background image from a given video/image sequence.
Paper related to GMM: Stauffer, C., Grimson, W.E.L., "Adaptive background mixture models for real-time tracking"

input:
img - current frame image
mean - mean values of distributions of each pixel, calculated from previous frames
w - weight corresponding to the mean values of each distribution
sd - standard deviation of distributions of each pixel, calculated from previous frames

output:
bg - background gray image
fg - foreground mask
w, mean, sd - same parameters as input, values being updated using the current frame image

'demo.m' shows how each parameter is initialized and used for the function