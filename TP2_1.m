%BUENO

num_images = 300;
alpha = 0.5; 

first_img = imread('image_001.jpg');
gray_first_img = rgb2gray(first_img);
[height, width] = size(gray_first_img);

images = zeros(height, width, num_images);

for k = 1:num_images
    img = imread(sprintf('image_%03d.jpg', k));
    images(:, :, k) = rgb2gray(img);
end

N_values = [50, 100, 200, 300];
results = struct();

for n = N_values
    mean_img_N = mean(images(:, :, 1:n), 3);
    std_img_N = std(images(:, :, 1:n), 0, 3);
    results(n).mean_img = mean_img_N;
    results(n).std_img = std_img_N;
end

figure;
sgtitle('Images moyennes en variant N');
for i = 1:length(N_values)
    subplot(2, 2, i);
    imshow(results(N_values(i)).mean_img, []);
    title(sprintf('N = %d', N_values(i)));
end

figure;
sgtitle('Images écart type en variant N');
for i = 1:length(N_values)
    subplot(2, 2, i);
    imshow(results(N_values(i)).std_img, []);
    title(sprintf('N = %d', N_values(i)));
end

images_to_display = [50, 100, 200, 300];

figure;
sgtitle('Alpha = 3.0');
subplot_idx = 1; 

motion_mask = false(height, width);
for k = 1:num_images
    current_img = images(:, :, k);
    
    mask = abs(current_img - mean_img) > alpha * std_img;
    
    if ismember(k, images_to_display)
        subplot(2, 2, subplot_idx); % 2x2 grid de subplots
        imshow(mask, []); 
        title(sprintf('Image %d', k));
        subplot_idx = subplot_idx + 1;
    end
end