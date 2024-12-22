video = VideoReader('video.avi');
num_frames = video.NumFrames;

frame1 = read(video, 1);
gray_frame1 = rgb2gray(frame1);

frames_of_interest = [150, 300, 450, 600];
num_subplots = length(frames_of_interest);

figure;

subplot_index = 1;
for k = 2:num_frames
    frame2 = read(video, k);
    gray_frame2 = rgb2gray(frame2);
    [u, v] = hornSchunck(gray_frame1, gray_frame2, 150, 0.6);

    if ismember(k, frames_of_interest)
        img = flowToColor(u, v);
        
        subplot(2, 2, subplot_index); % 2x2 subplots
        imshow(img);
        title([num2str(k)]);
        
        subplot_index = subplot_index + 1;
    end

    gray_frame1 = gray_frame2;
end

sgtitle('Alpha = 0.6 & # iterations = 150');

